variable "project" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Environment name (dev, stg, prod)"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private app subnets"
  type        = list(string)
}

variable "private_data_subnet_cidrs" {
  description = "CIDR blocks for private data subnets (RDS/Redis)"
  type        = list(string)
  default     = []
}

variable "availability_zones" {
  description = "Availability zones to deploy subnets into"
  type        = list(string)
}

variable "enable_nat_gateway" {
  description = "Whether to create NAT Gateway(s) for private subnets"
  type        = bool
  default     = true
}

variable "nat_gateway_per_az" {
  description = "Create one NAT gateway per AZ when true, otherwise single NAT in first public subnet"
  type        = bool
  default     = false
}
