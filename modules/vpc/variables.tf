variable "name" {
  description = "Name prefix for resources"
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
  description = "Security group IDs for interface endpoints"
  type        = list(string)
  default     = []
}
