variable "aws_region" {
  type    = string
  default = "eu-west-1"
}

variable "project" {
  type    = string
  default = "ecs-platform"
}

variable "environment" {
  type    = string
  default = "stg"
}

variable "name" {
  type    = string
  default = "app"
}

variable "image_count_limit" {
  type    = number
  default = 10
}
