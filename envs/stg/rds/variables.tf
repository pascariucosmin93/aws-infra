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

variable "db_name" {
  type    = string
  default = "appdb"
}

variable "db_username" {
  type    = string
  default = "appadmin"
}

variable "engine" {
  type    = string
  default = "postgres"
}

variable "engine_version" {
  type    = string
  default = "16.3"
}

variable "instance_class" {
  type    = string
  default = "db.t4g.large"
}

variable "allocated_storage" {
  type    = number
  default = 150
}

variable "max_allocated_storage" {
  type    = number
  default = 700
}

variable "backup_retention_period" {
  type    = number
  default = 14
}

variable "monitoring_interval" {
  type    = number
  default = 60
}
