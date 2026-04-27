provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source = "../../../modules/vpc"

  project                   = var.project
  environment               = var.environment
  vpc_cidr                  = var.vpc_cidr
  public_subnet_cidrs       = var.public_subnet_cidrs
  private_subnet_cidrs      = var.private_subnet_cidrs
  private_data_subnet_cidrs = var.private_data_subnet_cidrs
  availability_zones        = var.availability_zones
  enable_nat_gateway        = var.enable_nat_gateway
  nat_gateway_per_az        = var.nat_gateway_per_az
}
