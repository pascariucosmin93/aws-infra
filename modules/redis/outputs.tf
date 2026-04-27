output "redis_endpoint" {
  description = "Primary Redis endpoint"
  value       = aws_elasticache_replication_group.this.primary_endpoint_address
}

output "redis_reader_endpoint" {
  description = "Reader Redis endpoint"
  value       = aws_elasticache_replication_group.this.reader_endpoint_address
}

output "redis_port" {
  description = "Redis port"
  value       = aws_elasticache_replication_group.this.port
}

output "redis_security_group_id" {
  description = "Security group ID used by Redis"
  value       = aws_security_group.redis.id
}
