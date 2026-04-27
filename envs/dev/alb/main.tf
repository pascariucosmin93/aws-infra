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

module "alb" {
  source = "../../../modules/alb"

  project            = var.project
  environment        = var.environment
  vpc_id             = data.terraform_remote_state.vpc.outputs.vpc_id
  public_subnet_ids  = data.terraform_remote_state.vpc.outputs.public_subnet_ids
  container_port     = var.container_port
  health_check_path  = var.health_check_path
  certificate_arn    = var.certificate_arn
  enable_access_logs = var.enable_access_logs
  access_logs_bucket = var.access_logs_bucket
  access_logs_prefix = var.access_logs_prefix
}
