variable "project" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "name" {
  description = "Secret name suffix"
  type        = string
}

variable "description" {
  description = "Secret description"
  type        = string
  default     = ""
}

variable "secret_values" {
  description = "Map of key-value pairs to store as the secret. Values are written once; subsequent changes are ignored to avoid overwriting manually rotated secrets."
  type        = map(string)
  sensitive   = true
  default     = {}
}
