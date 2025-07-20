resource "aws_sqs_queue" "dlq" {
  name                       = "${var.name}-${var.environment}-dlq"
  message_retention_seconds  = 1209600  # 14 days
  tags                       = var.tags
}

resource "aws_sqs_queue" "main" {
  name                       = "${var.name}-${var.environment}-queue"
  visibility_timeout_seconds = 30
  message_retention_seconds  = 345600  # 4 days
  redrive_policy             = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.dlq.arn
    maxReceiveCount     = 5
  })
  tags                       = var.tags
}
