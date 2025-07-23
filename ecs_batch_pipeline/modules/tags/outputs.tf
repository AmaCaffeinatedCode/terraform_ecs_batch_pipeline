output "tags" {
  description = "Merged tags map for resources"
  value = merge(
    {
      Name        = var.name
      Environment = var.environment
      ProjectURL  = var.project_url
    },
    var.tags
  )
}
