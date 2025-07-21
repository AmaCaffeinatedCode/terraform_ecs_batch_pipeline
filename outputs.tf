output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

output "private_subnet_ids" {
  description = "Private subnet IDs"
  value       = module.vpc.private_subnet_ids
}

output "security_group_id" {
  description = "Security Group ID used for ECS tasks"
  value       = module.vpc.security_group_id
}

output "s3_source_bucket_name" {
  description = "Source S3 bucket name"
  value       = module.s3.source_bucket_name
}

output "s3_destination_bucket_name" {
  description = "Destination S3 bucket name"
  value       = module.s3.destination_bucket_name
}

output "sqs_queue_url" {
  description = "SQS queue URL"
  value       = module.sqs.queue_url
}

output "sqs_queue_arn" {
  description = "SQS queue ARN"
  value       = module.sqs.queue_arn
}

output "iam_task_execution_role_arn" {
  description = "IAM Role ARN for ECS task execution"
  value       = module.iam.task_execution_role_arn
}

output "iam_task_role_arn" {
  description = "IAM Role ARN for ECS task role"
  value       = module.iam.task_role_arn
}

output "cloudwatch_log_group_name" {
  description = "Name of the CloudWatch log group used by ECS"
  value       = module.cloudwatch.log_group_name
}

output "ecs_cluster_id" {
  description = "ECS cluster ID"
  value       = module.ecs.ecs_cluster_id
}

output "ecs_service_name" {
  description = "ECS service name"
  value       = module.ecs.ecs_service_name
}
