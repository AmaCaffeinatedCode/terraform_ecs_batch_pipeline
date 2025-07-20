resource "aws_ecr_repository" "this" {
  name = "${var.name}-${var.environment}"
  tags = var.tags
}
