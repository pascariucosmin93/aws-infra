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
  default = "dev"
}

variable "rate_limit" {
  type    = number
  default = 2000
}

variable "allowed_ip_cidrs" {
  type    = list(string)
  default = []
}
