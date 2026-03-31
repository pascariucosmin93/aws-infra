variable "project" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "name" {
  description = "Repository name suffix"
  type        = string
}

variable "image_count_limit" {
  description = "Number of images to retain per repository"
  type        = number
  default     = 10
}
