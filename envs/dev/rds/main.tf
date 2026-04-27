provider "aws" {
  region = var.aws_region
}

data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = "tfstate-aws-ecs-platform"
    key    = "dev/vpc/terraform.tfstate"
    region = var.aws_region
  }
}

data "terraform_remote_state" "ecs" {
  backend = "s3"
  config = {
    bucket = "tfstate-aws-ecs-platform"
    key    = "dev/ecs/terraform.tfstate"
    region = var.aws_region
  }
}

module "rds" {
  source = "../../../modules/rds"

  project                 = var.project
  environment             = var.environment
  vpc_id                  = data.terraform_remote_state.vpc.outputs.vpc_id
  app_security_group_id   = data.terraform_remote_state.ecs.outputs.security_group_id
  private_data_subnet_ids = data.terraform_remote_state.vpc.outputs.private_data_subnet_ids
  db_name                 = var.db_name
  db_username             = var.db_username
  engine                  = var.engine
  engine_version          = var.engine_version
  instance_class          = var.instance_class
  allocated_storage       = var.allocated_storage
  max_allocated_storage   = var.max_allocated_storage
  backup_retention_period = var.backup_retention_period
  monitoring_interval     = var.monitoring_interval
}
