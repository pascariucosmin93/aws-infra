resource "aws_elasticache_subnet_group" "this" {
  name       = "${var.project}-${var.environment}-redis-subnet-group"
  subnet_ids = var.private_data_subnet_ids

  tags = {
    Name        = "${var.project}-${var.environment}-redis-subnet-group"
    Environment = var.environment
    Project     = var.project
  }
}

resource "aws_security_group" "redis" {
  name        = "${var.project}-${var.environment}-redis-sg"
  description = "Security group for Redis"
  vpc_id      = var.vpc_id

  ingress {
    description     = "Redis from app"
    from_port       = 6379
    to_port         = 6379
    protocol        = "tcp"
    security_groups = [var.app_security_group_id]
  }

  tags = {
    Name        = "${var.project}-${var.environment}-redis-sg"
    Environment = var.environment
    Project     = var.project
  }
}

resource "aws_elasticache_replication_group" "this" {
  replication_group_id       = "${var.project}-${var.environment}-redis"
  description                = "${var.project}-${var.environment} redis"
  engine                     = "redis"
  engine_version             = var.engine_version
  node_type                  = var.node_type
  num_cache_clusters         = var.num_cache_clusters
  port                       = 6379
  automatic_failover_enabled = var.num_cache_clusters > 1
  multi_az_enabled           = var.num_cache_clusters > 1
  auto_minor_version_upgrade = true
  at_rest_encryption_enabled = var.at_rest_encryption_enabled
  transit_encryption_enabled = var.transit_encryption_enabled
  snapshot_retention_limit   = var.snapshot_retention_limit
  subnet_group_name          = aws_elasticache_subnet_group.this.name
  security_group_ids         = [aws_security_group.redis.id]

  tags = {
    Name        = "${var.project}-${var.environment}-redis"
    Environment = var.environment
    Project     = var.project
  }
}
