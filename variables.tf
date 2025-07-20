# General / Shared variables
variable "name" {
  description = "Name prefix for all resources"
  type        = string
}

variable "tags" {
  description = "Additional tags to apply to resources"
  type        = map(string)
  default     = {}
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "dev"
}

variable "project_url" {
  description = "URL to the GitHub repository for the project"
  type        = string
  default     = ""
}

# VPC module variables
variable "cidr_block" {
  description = "VPC CIDR block"
  type        = string
  default     = "10.0.0.0/16"
}

variable "azs" {
  description = "Availability Zones"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "private_subnet_cidrs" {
  description = "CIDRs for private subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "endpoint_subnet_cidrs" {
  description = "CIDRs for endpoint subnets"
  type        = list(string)
  default     = ["10.0.11.0/24", "10.0.12.0/24"]
}

variable "interface_endpoint_sg_ids" {
  description = "Security group IDs to attach to VPC interface endpoints"
  type        = list(string)
  default     = []
}

# IAM module variables
variable "sqs_queue_arn" {
  description = "SQS queue ARN for IAM policies"
  type        = string
}

# ECS module variables
variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "ecr_image" {
  description = "ECR image URI for the ECS task container"
  type        = string
}

variable "desired_count" {
  description = "Initial desired count of ECS tasks"
  type        = number
  default     = 1
}

variable "min_capacity" {
  description = "Minimum ECS task count for autoscaling"
  type        = number
  default     = 1
}

variable "max_capacity" {
  description = "Maximum ECS task count for autoscaling"
  type        = number
  default     = 4
}
