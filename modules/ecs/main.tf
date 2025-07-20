resource "aws_ecs_cluster" "this" {
  name = "${var.name}-${var.environment}-ecs-cluster"
  tags = var.tags
}

resource "aws_cloudwatch_log_group" "ecs" {
  name              = "/ecs/${var.name}-${var.environment}-batch"
  retention_in_days = 7
  tags              = var.tags
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
          "awslogs-group"         = aws_cloudwatch_log_group.ecs.name
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
  name            = "${var.name}-${var.environment}-batch-service"
  cluster         = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.batch.arn
  desired_count   = var.desired_count
  launch_type     = "FARGATE"
  platform_version = "LATEST"

  network_configuration {
    subnets          = var.private_subnet_ids
    assign_public_ip = false
    security_groups  = [var.security_group_id]
  }

  depends_on = [aws_iam_role_policy_attachment.task_execution_managed]
}

resource "aws_appautoscaling_target" "ecs" {
  max_capacity       = var.max_capacity
  min_capacity       = var.min_capacity
  resource_id        = "service/${aws_ecs_cluster.this.name}/${aws_ecs_service.batch.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_cloudwatch_metric_alarm" "scale_out" {
  alarm_name          = "${var.name}-${var.environment}-scale-out"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "ApproximateNumberOfMessagesVisible"
  namespace           = "AWS/SQS"
  period              = 60
  statistic           = "Average"
  threshold           = 10
  alarm_actions       = [aws_appautoscaling_policy.scale_out.arn]
  dimensions = {
    QueueName = regex("^arn:aws:sqs:[^:]+:[^:]+:(.+)$", var.sqs_queue_arn)[0]
  }
}

resource "aws_cloudwatch_metric_alarm" "scale_in" {
  alarm_name          = "${var.name}-${var.environment}-scale-in"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 1
  metric_name         = "ApproximateNumberOfMessagesVisible"
  namespace           = "AWS/SQS"
  period              = 60
  statistic           = "Average"
  threshold           = 0
  alarm_actions       = [aws_appautoscaling_policy.scale_in.arn]
  dimensions = {
    QueueName = regex("^arn:aws:sqs:[^:]+:[^:]+:(.+)$", var.sqs_queue_arn)[0]
  }
}

resource "aws_appautoscaling_policy" "scale_out" {
  name               = "${var.name}-${var.environment}-scale-out-policy"
  policy_type        = "StepScaling"
  resource_id        = aws_appautoscaling_target.ecs.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs.service_namespace

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 60
    metric_aggregation_type = "Average"

    step_adjustment {
      scaling_adjustment          = 1
      metric_interval_lower_bound = 0
    }
  }
}

resource "aws_appautoscaling_policy" "scale_in" {
  name               = "${var.name}-${var.environment}-scale-in-policy"
  policy_type        = "StepScaling"
  resource_id        = aws_appautoscaling_target.ecs.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs.service_namespace

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 300
    metric_aggregation_type = "Average"

    step_adjustment {
      scaling_adjustment          = -1
      metric_interval_upper_bound = 0
    }
  }
}
