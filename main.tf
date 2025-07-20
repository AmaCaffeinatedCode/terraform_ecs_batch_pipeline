provider "aws" {
  region = var.region
}

resource "aws_ecr_repository" "this" {
  name                 = "${var.name}_${var.environment}_repo"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = var.tags
}
