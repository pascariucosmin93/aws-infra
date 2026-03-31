output "user_pool_id" {
  description = "ID of the Cognito User Pool"
  value       = aws_cognito_user_pool.this.id
}

output "user_pool_arn" {
  description = "ARN of the Cognito User Pool"
  value       = aws_cognito_user_pool.this.arn
}

output "client_id" {
  description = "ID of the Cognito User Pool Client"
  value       = aws_cognito_user_pool_client.this.id
}

output "domain" {
  description = "Cognito hosted UI domain"
  value       = aws_cognito_user_pool_domain.this.domain
}

output "endpoint" {
  description = "Cognito User Pool endpoint"
  value       = aws_cognito_user_pool.this.endpoint
}
