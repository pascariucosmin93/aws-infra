provider "aws" {
  region = var.aws_region
}

module "app_secret" {
  source = "../../../modules/secrets"

  project     = var.project
  environment = var.environment
  name        = "app"
  description = "Application secrets for ${var.environment}"

  secret_values = {
    DB_PASSWORD = "changeme"
    API_KEY     = "changeme"
  }
}
