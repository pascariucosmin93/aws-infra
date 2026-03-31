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

data "terraform_remote_state" "alb" {
  backend = "s3"
  config = {
    bucket = "tfstate-aws-ecs-platform"
    key    = "dev/alb/terraform.tfstate"
    region = var.aws_region
  }
}

data "terraform_remote_state" "ecr" {
  backend = "s3"
  config = {
    bucket = "tfstate-aws-ecs-platform"
    key    = "dev/ecr/terraform.tfstate"
    region = var.aws_region
  }
}

data "terraform_remote_state" "iam" {
  backend = "s3"
  config = {
    bucket = "tfstate-aws-ecs-platform"
    key    = "dev/iam/terraform.tfstate"
    region = var.aws_region
  }
}

data "terraform_remote_state" "secrets" {
  backend = "s3"
  config = {
    bucket = "tfstate-aws-ecs-platform"
    key    = "dev/secrets/terraform.tfstate"
    region = var.aws_region
  }
}

data "terraform_remote_state" "sns" {
  backend = "s3"
  config = {
    bucket = "tfstate-aws-ecs-platform"
    key    = "dev/sns/terraform.tfstate"
    region = var.aws_region
  }
}

module "ecs" {
  source = "../../../modules/ecs"

  project     = var.project
  environment = var.environment
  name        = var.service_name
  aws_region  = var.aws_region

  vpc_id                = data.terraform_remote_state.vpc.outputs.vpc_id
  private_subnet_ids    = data.terraform_remote_state.vpc.outputs.private_subnet_ids
  alb_security_group_id = data.terraform_remote_state.alb.outputs.security_group_id
  target_group_arn      = data.terraform_remote_state.alb.outputs.target_group_arn
  ecr_repository_url    = data.terraform_remote_state.ecr.outputs.repository_url
  execution_role_arn    = data.terraform_remote_state.iam.outputs.execution_role_arn
  task_role_arn         = data.terraform_remote_state.iam.outputs.task_role_arn
  sns_topic_arns        = [data.terraform_remote_state.sns.outputs.topic_arn]

  secrets_from_ssm = {
    DB_PASSWORD = data.terraform_remote_state.secrets.outputs.secret_arn
  }

  container_port     = var.container_port
  health_check_path  = var.health_check_path
  cpu                = var.cpu
  memory             = var.memory
  desired_count      = var.desired_count
  min_capacity       = var.min_capacity
  max_capacity       = var.max_capacity
  log_retention_days = var.log_retention_days
  image_tag          = var.image_tag

  environment_variables = {
    ENVIRONMENT = var.environment
    PROJECT     = var.project
  }
}
