variable "project" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "secret_arns" {
  description = "ARNs of Secrets Manager secrets the ECS tasks need access to"
  type        = list(string)
  default     = []
}

variable "ecr_repo_arns" {
  description = "ARNs of ECR repositories the execution role needs to pull from"
  type        = list(string)
  default     = []
}

variable "sns_topic_arns" {
  description = "ARNs of SNS topics the task role can publish to"
  type        = list(string)
  default     = []
}
