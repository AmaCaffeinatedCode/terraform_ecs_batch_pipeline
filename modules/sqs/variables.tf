variable "name" {
  description = "Resource name prefix"
  type        = string
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
