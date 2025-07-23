terraform {
  backend "s3" {
    bucket         = "terraform-remote-state-central-bucket"
    key            = "terraform_ecr_repo/production/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-remote-state-lock-table"
    encrypt        = true
  }
}