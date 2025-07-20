# General / Shared variables
name        = "terraform_ecs_batch_pipeline"

tags = {
  "Owner"       = "infrastructure-team"
  "Project"     = "terraform_ecs_batch_pipeline"
}

# "environment" tag is set dinamically in the CI/CD pipeline

# "project_url" tag is set dinamically in the CI/CD pipeline


# VPC module variables
cidr_block             = "10.0.0.0/16"
azs                    = ["us-east-1a", "us-east-1b"]
private_subnet_cidrs   = ["10.0.1.0/24", "10.0.2.0/24"]
endpoint_subnet_cidrs  = ["10.0.11.0/24", "10.0.12.0/24"]


# ECS module variables
region        = "us-east-1"

desired_count = 1
min_capacity  = 1
max_capacity  = 4

# "ecr_image" is set dinamically in the CI/CD pipeline
