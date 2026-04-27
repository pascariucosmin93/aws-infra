output "db_instance_id" {
  description = "RDS instance identifier"
  value       = aws_db_instance.this.id
}

output "db_endpoint" {
  description = "RDS endpoint address"
  value       = aws_db_instance.this.endpoint
}

output "db_port" {
  description = "RDS endpoint port"
  value       = aws_db_instance.this.port
}

output "db_security_group_id" {
  description = "Security group ID used by RDS"
  value       = aws_security_group.rds.id
}

output "master_user_secret_arn" {
  description = "Secrets Manager ARN for the RDS master user password"
  value       = aws_db_instance.this.master_user_secret[0].secret_arn
}
