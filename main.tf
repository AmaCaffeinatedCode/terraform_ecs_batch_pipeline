provider "aws" {
  region = var.region
}

resource "aws_ecr_repository" "this" {
  name                 = var.name
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = merge(
    var.tags,
    {
      Name        = var.name,
      Environment = var.environment,
      project_url = var.project_url
    }
  )
}
