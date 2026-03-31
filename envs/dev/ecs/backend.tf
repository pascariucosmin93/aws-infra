terraform {
  backend "s3" {
    bucket = "tfstate-aws-ecs-platform"
    key    = "dev/ecs/terraform.tfstate"
    region = "eu-west-1"

    dynamodb_table = "tfstate-aws-ecs-platform-locks"
    encrypt        = true
  }
}
