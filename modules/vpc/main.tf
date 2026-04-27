locals {
  public_subnets = {
    for idx, cidr in var.public_subnet_cidrs : idx => {
      cidr = cidr
      az   = var.availability_zones[idx]
    }
  }

  private_app_subnets = {
    for idx, cidr in var.private_subnet_cidrs : idx => {
      cidr = cidr
      az   = var.availability_zones[idx]
    }
  }

  private_data_subnets = {
    for idx, cidr in var.private_data_subnet_cidrs : idx => {
      cidr = cidr
      az   = var.availability_zones[idx]
    }
  }

  nat_gateway_indexes = var.enable_nat_gateway ? (
    var.nat_gateway_per_az ? keys(local.public_subnets) : ["0"]
  ) : []

  private_route_indexes = var.nat_gateway_per_az ? keys(local.private_app_subnets) : ["0"]
}

resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name        = "${var.project}-${var.environment}-vpc"
    Environment = var.environment
    Project     = var.project
  }
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name        = "${var.project}-${var.environment}-igw"
    Environment = var.environment
    Project     = var.project
  }
}

resource "aws_subnet" "public" {
  for_each = local.public_subnets

  vpc_id                  = aws_vpc.this.id
  cidr_block              = each.value.cidr
  availability_zone       = each.value.az
  map_public_ip_on_launch = true

  tags = {
    Name        = "${var.project}-${var.environment}-public-${each.value.az}"
    Environment = var.environment
    Project     = var.project
    Tier        = "public"
  }
}

resource "aws_subnet" "private_app" {
  for_each = local.private_app_subnets

  vpc_id            = aws_vpc.this.id
  cidr_block        = each.value.cidr
  availability_zone = each.value.az

  tags = {
    Name        = "${var.project}-${var.environment}-private-app-${each.value.az}"
    Environment = var.environment
    Project     = var.project
    Tier        = "private-app"
  }
}

resource "aws_subnet" "private_data" {
  for_each = local.private_data_subnets

  vpc_id            = aws_vpc.this.id
  cidr_block        = each.value.cidr
  availability_zone = each.value.az

  tags = {
    Name        = "${var.project}-${var.environment}-private-data-${each.value.az}"
    Environment = var.environment
    Project     = var.project
    Tier        = "private-data"
  }
}

resource "aws_eip" "nat" {
  for_each = toset(local.nat_gateway_indexes)
  domain   = "vpc"

  tags = {
    Name        = "${var.project}-${var.environment}-nat-eip-${each.key}"
    Environment = var.environment
    Project     = var.project
  }
}

resource "aws_nat_gateway" "this" {
  for_each = toset(local.nat_gateway_indexes)

  allocation_id = aws_eip.nat[each.key].id
  subnet_id     = aws_subnet.public[each.key].id

  tags = {
    Name        = "${var.project}-${var.environment}-nat-${each.key}"
    Environment = var.environment
    Project     = var.project
  }

  depends_on = [aws_internet_gateway.this]
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  tags = {
    Name        = "${var.project}-${var.environment}-public-rt"
    Environment = var.environment
    Project     = var.project
  }
}

resource "aws_route_table_association" "public" {
  for_each = aws_subnet.public

  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "private_app" {
  for_each = toset(local.private_route_indexes)
  vpc_id   = aws_vpc.this.id

  dynamic "route" {
    for_each = var.enable_nat_gateway ? [1] : []
    content {
      cidr_block     = "0.0.0.0/0"
      nat_gateway_id = var.nat_gateway_per_az ? aws_nat_gateway.this[each.key].id : aws_nat_gateway.this["0"].id
    }
  }

  tags = {
    Name        = "${var.project}-${var.environment}-private-app-rt-${each.key}"
    Environment = var.environment
    Project     = var.project
  }
}

resource "aws_route_table_association" "private_app" {
  for_each = aws_subnet.private_app

  subnet_id      = each.value.id
  route_table_id = var.nat_gateway_per_az ? aws_route_table.private_app[each.key].id : aws_route_table.private_app["0"].id
}

resource "aws_route_table" "private_data" {
  for_each = toset(local.private_route_indexes)
  vpc_id   = aws_vpc.this.id

  dynamic "route" {
    for_each = var.enable_nat_gateway ? [1] : []
    content {
      cidr_block     = "0.0.0.0/0"
      nat_gateway_id = var.nat_gateway_per_az ? aws_nat_gateway.this[each.key].id : aws_nat_gateway.this["0"].id
    }
  }

  tags = {
    Name        = "${var.project}-${var.environment}-private-data-rt-${each.key}"
    Environment = var.environment
    Project     = var.project
  }
}

resource "aws_route_table_association" "private_data" {
  for_each = aws_subnet.private_data

  subnet_id      = each.value.id
  route_table_id = var.nat_gateway_per_az ? aws_route_table.private_data[each.key].id : aws_route_table.private_data["0"].id
}
