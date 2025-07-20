resource "aws_security_group" "this" {
  name        = "${var.name}-${var.environment}-sg"
  description = "Security group for ECS tasks and VPC endpoints"
  vpc_id      = var.vpc_id

  revoke_rules_on_delete = true

  tags = merge(var.tags, {
    Name        = "${var.name}-${var.environment}-sg"
    Environment = var.environment
    ProjectURL  = var.project_url
  })
}

resource "aws_security_group_egress" "all" {
  security_group_id = aws_security_group.this.id

  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}
