resource "aws_ecs_cluster" "this" {
  name = "${var.name}-${var.environment}-ecs-cluster"
  tags = var.tags
}

resource "aws_ecs_task_definition" "batch" {
  family                   = "${var.name}-${var.environment}-batch"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "512"
  memory                   = "1024"
  execution_role_arn       = var.task_execution_role_arn
  task_role_arn            = var.task_role_arn

  container_definitions = jsonencode([
    {
      name      = "batch-processor"
      image     = var.ecr_image
      essential = true
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = var.log_group_name
          "awslogs-region"        = var.region
          "awslogs-stream-prefix" = "ecs"
        }
      }
      environment = [
        { name = "SQS_QUEUE_URL", value = var.sqs_queue_url },
        { name = "SOURCE_BUCKET", value = "${var.name}-${var.environment}-source" },
        { name = "DESTINATION_BUCKET", value = "${var.name}-${var.environment}-destination" }
      ]
    }
  ])
}

resource "aws_ecs_service" "batch" {
  name             = "${var.name}-${var.environment}-batch-service"
  cluster          = aws_ecs_cluster.this.id
  task_definition  = aws_ecs_task_definition.batch.arn
  desired_count    = var.desired_count
  launch_type      = "FARGATE"
  platform_version = "LATEST"

  network_configuration {
    subnets          = var.private_subnet_ids
    assign_public_ip = false
    security_groups  = [var.security_group_id]
  }

  depends_on = [aws_iam_role_policy_attachment.task_execution_managed]
}
