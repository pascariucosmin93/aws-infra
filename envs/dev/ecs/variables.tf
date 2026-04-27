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

variable "service_name" {
  type    = string
  default = "app"
}

variable "container_port" {
  type    = number
  default = 3000
}

variable "health_check_path" {
  type    = string
  default = "/health"
}

variable "cpu" {
  type    = number
  default = 256
}

variable "memory" {
  type    = number
  default = 512
}

variable "desired_count" {
  type    = number
  default = 1
}

variable "min_capacity" {
  type    = number
  default = 1
}

variable "max_capacity" {
  type    = number
  default = 2
}

variable "cpu_target_utilization" {
  type    = number
  default = 70
}

variable "memory_target_utilization" {
  type    = number
  default = 75
}

variable "log_retention_days" {
  type    = number
  default = 30
}

variable "image_tag" {
  type    = string
  default = "latest"
}
