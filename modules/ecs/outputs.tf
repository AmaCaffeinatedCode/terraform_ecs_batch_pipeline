output "ecs_cluster_id" {
  description = "ECS Cluster ID"
  value       = aws_ecs_cluster.this.id
}

output "ecs_service_name" {
  description = "ECS Service Name"
  value       = aws_ecs_service.batch.name
}
