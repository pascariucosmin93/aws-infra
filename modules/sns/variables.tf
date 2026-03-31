variable "project" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "name" {
  description = "Topic name suffix"
  type        = string
}

variable "email_addresses" {
  description = "List of email addresses to subscribe to the topic"
  type        = list(string)
  default     = []
}
