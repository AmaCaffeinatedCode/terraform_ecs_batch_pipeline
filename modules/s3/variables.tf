variable "name" {
  description = "Resource name prefix"
  type        = string
}

variable "sqs_queue_arn" {
  description = "ARN of the SQS queue to send S3 event notifications to"
  type        = string
  default     = ""
}

variable "filter_prefix" {
  description = "Optional prefix filter for S3 event notifications"
  type        = string
  default     = ""
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
}

variable "environment" {
  description = "Deployment environment"
  type        = string
}

variable "project_url" {
  description = "Project GitHub URL"
  type        = string
  default     = ""
}
