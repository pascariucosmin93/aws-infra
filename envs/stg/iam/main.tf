provider "aws" {
  region = var.aws_region
}

data "terraform_remote_state" "secrets" {
  backend = "s3"
  config = {
    bucket = "tfstate-aws-ecs-platform"
    key    = "dev/secrets/terraform.tfstate"
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

data "terraform_remote_state" "sns" {
  backend = "s3"
  config = {
    bucket = "tfstate-aws-ecs-platform"
    key    = "dev/sns/terraform.tfstate"
    region = var.aws_region
  }
}

module "iam" {
  source = "../../../modules/iam"

  project     = var.project
  environment = var.environment

  secret_arns    = [data.terraform_remote_state.secrets.outputs.secret_arn]
  ecr_repo_arns  = [data.terraform_remote_state.ecr.outputs.repository_arn]
  sns_topic_arns = [data.terraform_remote_state.sns.outputs.topic_arn]
}
