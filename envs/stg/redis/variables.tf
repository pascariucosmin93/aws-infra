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

variable "node_type" {
  type    = string
  default = "cache.t4g.medium"
}

variable "engine_version" {
  type    = string
  default = "7.1"
}

variable "num_cache_clusters" {
  type    = number
  default = 2
}

variable "at_rest_encryption_enabled" {
  type    = bool
  default = true
}

variable "transit_encryption_enabled" {
  type    = bool
  default = true
}

variable "snapshot_retention_limit" {
  type    = number
  default = 7
}
