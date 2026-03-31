provider "aws" {
  region = var.aws_region
}

module "ecr" {
  source = "../../../modules/ecr"

  project           = var.project
  environment       = var.environment
  name              = var.name
  image_count_limit = var.image_count_limit
}
