module "tags" {
  source      = "./modules/tags"
  name        = var.name
  environment = var.environment
  project_url = var.project_url
  tags        = var.tags
}

module "vpc" {
  source                   = "./modules/vpc"
  name                     = var.name
  cidr_block               = var.cidr_block
  azs                      = var.azs
  private_subnet_cidrs     = var.private_subnet_cidrs
  endpoint_subnet_cidrs    = var.endpoint_subnet_cidrs
  environment              = var.environment
  project_url              = var.project_url
  tags                     = module.tags.tags
}

module "s3" {
  source        = "./modules/s3"
  name          = var.name
  environment   = var.environment
  project_url   = var.project_url
  tags          = module.tags.tags
  sqs_queue_arn = module.sqs.queue_arn
  filter_prefix = ""
}

module "sqs" {
  source      = "./modules/sqs"
  name        = var.name
  environment = var.environment
  project_url = var.project_url
  tags        = module.tags.tags
}

module "iam" {
  source      = "./modules/iam"
  name        = var.name
  environment = var.environment
  project_url = var.project_url
  tags        = module.tags.tags
  sqs_queue_arn = module.sqs.queue_arn
}

module "ecs" {
  source      = "./modules/ecs"
  name        = var.name
  environment = var.environment
  project_url = var.project_url
  tags        = module.tags.tags

  region              = var.region
  ecr_image           = var.ecr_image

  sqs_queue_url       = module.sqs.queue_url

  private_subnet_ids  = module.vpc.private_subnet_ids
  security_group_id   = module.vpc.security_group_id

  desired_count       = var.desired_count

  task_execution_role_arn = module.iam.task_execution_role_arn
  task_role_arn           = module.iam.task_role_arn
}

module "cloudwatch" {
  source      = "./modules/cloudwatch"
  name        = var.name
  environment = var.environment
  project_url = var.project_url
  tags        = module.tags.tags

  region            = var.region
  sqs_queue_arn     = module.sqs.queue_arn
  ecs_cluster_name  = module.ecs.ecs_cluster_name
  ecs_service_name  = module.ecs.ecs_service_name
  min_capacity      = var.min_capacity
  max_capacity      = var.max_capacity
}
