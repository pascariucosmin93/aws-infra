provider "aws" {
  region = var.aws_region
}

module "cognito" {
  source = "../../../modules/cognito"

  project       = var.project
  environment   = var.environment
  callback_urls = var.callback_urls
  logout_urls   = var.logout_urls
}
