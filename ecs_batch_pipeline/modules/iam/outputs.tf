output "task_execution_role_arn" {
  description = "IAM Role ARN used by ECS task execution"
  value       = aws_iam_role.task_execution.arn
}

output "task_role_arn" {
  description = "IAM Role ARN used by ECS task"
  value       = aws_iam_role.task.arn
}
