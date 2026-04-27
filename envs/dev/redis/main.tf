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

module "redis" {
  source = "../../../modules/redis"

  project                    = var.project
  environment                = var.environment
  vpc_id                     = data.terraform_remote_state.vpc.outputs.vpc_id
  app_security_group_id      = data.terraform_remote_state.ecs.outputs.security_group_id
  private_data_subnet_ids    = data.terraform_remote_state.vpc.outputs.private_data_subnet_ids
  node_type                  = var.node_type
  engine_version             = var.engine_version
  num_cache_clusters         = var.num_cache_clusters
  at_rest_encryption_enabled = var.at_rest_encryption_enabled
  transit_encryption_enabled = var.transit_encryption_enabled
  snapshot_retention_limit   = var.snapshot_retention_limit
}
