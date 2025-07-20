output "ecs_cluster_id" {
  description = "ECS Cluster ID"
  value       = aws_ecs_cluster.this.id
}

output "ecs_service_name" {
  description = "ECS Service Name"
  value       = aws_ecs_service.batch.name
}

output "task_execution_role_arn" {
  description = "IAM Role ARN used by ECS task execution"
  value       = aws_iam_role.task_execution.arn
}

output "task_role_arn" {
  description = "IAM Role ARN used by ECS task"
  value       = aws_iam_role.task.arn
}

output "security_group_id" {
  description = "Security Group ID used by ECS and interface endpoints"
  value       = aws_security_group.ecs.id
}
