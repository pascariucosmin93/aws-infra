variable "aws_region" {
  type    = string
  default = "eu-west-1"
}

variable "project" {
  type    = string
  default = "ecs-platform"
}

variable "environment" {
  type    = string
  default = "stg"
}

variable "vpc_cidr" {
  type = string
}

variable "public_subnet_cidrs" {
  type = list(string)
}

variable "private_subnet_cidrs" {
  type = list(string)
}

variable "private_data_subnet_cidrs" {
  type    = list(string)
  default = []
}

variable "availability_zones" {
  type = list(string)
}

variable "enable_nat_gateway" {
  type    = bool
  default = true
}

variable "nat_gateway_per_az" {
  type    = bool
  default = true
}
