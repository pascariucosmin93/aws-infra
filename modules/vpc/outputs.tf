output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.this.id
}

output "vpc_cidr" {
  description = "CIDR block of the VPC"
  value       = aws_vpc.this.cidr_block
}

output "public_subnet_ids" {
  description = "IDs of the public subnets"
  value       = values(aws_subnet.public)[*].id
}

output "private_subnet_ids" {
  description = "IDs of the private app subnets"
  value       = values(aws_subnet.private_app)[*].id
}

output "private_data_subnet_ids" {
  description = "IDs of the private data subnets"
  value       = values(aws_subnet.private_data)[*].id
}

output "nat_gateway_ids" {
  description = "IDs of NAT Gateways"
  value       = values(aws_nat_gateway.this)[*].id
}
