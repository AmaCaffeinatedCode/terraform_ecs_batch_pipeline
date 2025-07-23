variable "name" {
  description = "Name prefix for the security group"
  type        = string
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
}

variable "environment" {
  description = "Deployment environment"
  type        = string
}

variable "project_url" {
  description = "URL of the GitHub repository"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID to associate with the security group"
  type        = string
}
