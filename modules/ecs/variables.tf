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

variable "region" {
  description = "AWS region"
  type        = string
}

variable "ecr_image" {
  description = "ECR image URI for the ECS task container"
  type        = string
}

variable "sqs_queue_url" {
  description = "SQS queue URL for the batch processing"
  type        = string
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs for ECS tasks"
  type        = list(string)
}

variable "security_group_id" {
  description = "Security Group ID for ECS tasks"
  type        = string
}

variable "desired_count" {
  description = "Initial desired count of ECS tasks"
  type        = number
  default     = 1
}

variable "task_execution_role_arn" {
  description = "IAM Role ARN used by ECS task execution"
  type        = string
}

variable "task_role_arn" {
  description = "IAM Role ARN used by ECS task"
  type        = string
}

variable "log_group_name" {
  description = "CloudWatch Log Group name passed in from the cloudwatch module"
  type        = string
}
