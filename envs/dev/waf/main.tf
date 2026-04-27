provider "aws" {
  region = var.aws_region
}

data "terraform_remote_state" "alb" {
  backend = "s3"
  config = {
    bucket = "tfstate-aws-ecs-platform"
    key    = "dev/alb/terraform.tfstate"
    region = var.aws_region
  }
}

module "waf" {
  source = "../../../modules/waf"

  project          = var.project
  environment      = var.environment
  alb_arn          = data.terraform_remote_state.alb.outputs.alb_arn
  rate_limit       = var.rate_limit
  allowed_ip_cidrs = var.allowed_ip_cidrs
}
