resource "aws_secretsmanager_secret" "this" {
  name                    = "${var.project}/${var.environment}/${var.name}"
  description             = var.description
  recovery_window_in_days = var.environment == "prod" ? 30 : 7

  tags = {
    Name        = "${var.project}/${var.environment}/${var.name}"
    Environment = var.environment
    Project     = var.project
  }
}

resource "aws_secretsmanager_secret_version" "this" {
  secret_id     = aws_secretsmanager_secret.this.id
  secret_string = jsonencode(var.secret_values)

  lifecycle {
    ignore_changes = [secret_string]
  }
}
