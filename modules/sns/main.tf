resource "aws_sns_topic" "this" {
  name = "${var.project}-${var.environment}-${var.name}"

  tags = {
    Name        = "${var.project}-${var.environment}-${var.name}"
    Environment = var.environment
    Project     = var.project
  }
}

resource "aws_sns_topic_subscription" "email" {
  for_each = toset(var.email_addresses)

  topic_arn = aws_sns_topic.this.arn
  protocol  = "email"
  endpoint  = each.value
}
