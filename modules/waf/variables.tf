variable "project" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "alb_arn" {
  description = "ARN of the ALB to associate the WAF WebACL with"
  type        = string
}

variable "rate_limit" {
  description = "Maximum number of requests per 5-minute window per IP before blocking"
  type        = number
  default     = 2000
}

variable "allowed_ip_cidrs" {
  description = "Optional allowlist CIDRs"
  type        = list(string)
  default     = []
}
