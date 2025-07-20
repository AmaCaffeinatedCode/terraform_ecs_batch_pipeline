variable "name" {
  type = string
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "environment" {
  type = string
  default = "dev"
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