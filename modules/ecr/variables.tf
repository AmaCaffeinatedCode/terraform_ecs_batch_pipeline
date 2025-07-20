variable "name" {
  type = string
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "environment" {
  type = string
}

variable "project_url" {
  description = "URL to the GitHub repository for the project"
  type        = string
  default     = ""
}