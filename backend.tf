terraform {
  backend "s3" {
    bucket         = "terraform-remote-state-central-bucket"
    key            = "terraform_ecs_batch_pipeline/production/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-remote-state-lock-table"
    encrypt        = true
  }
}