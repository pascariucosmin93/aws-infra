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

variable "container_port" {
  type    = number
  default = 3000
}

variable "health_check_path" {
  type    = string
  default = "/health"
}

variable "certificate_arn" {
  type    = string
  default = ""
}

variable "enable_access_logs" {
  type    = bool
  default = false
}

variable "access_logs_bucket" {
  type    = string
  default = ""
}

variable "access_logs_prefix" {
  type    = string
  default = "alb"
}
