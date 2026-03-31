provider "aws" {
  region = var.aws_region
}

module "sns" {
  source = "../../../modules/sns"

  project         = var.project
  environment     = var.environment
  name            = "alerts"
  email_addresses = var.alert_email_addresses
}
