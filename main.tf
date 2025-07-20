module "tags" {
  source      = "./modules/tags"
  name        = var.name
  environment = var.environment
  project_url = var.project_url
  tags        = var.tags
}

module "security-group" {
  source      = "./modules/security-group"
  name        = var.name
  vpc_id      = module.vpc.vpc_id
  environment = var.environment
  project_url = var.project_url
  tags        = module.tags.tags
}

module "vpc" {
  source                   = "./modules/vpc"
  name                     = var.name
  cidr_block               = var.cidr_block
  azs                      = var.azs
  private_subnet_cidrs     = var.private_subnet_cidrs
  endpoint_subnet_cidrs    = var.endpoint_subnet_cidrs
  interface_endpoint_sg_ids = [module.security_group.security_group_id] ###
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
  sqs_queue_arn       = module.sqs.queue_arn

  private_subnet_ids  = module.vpc.private_subnet_ids
  security_group_id   = module.security_group.security_group_id

  desired_count       = 1
  min_capacity        = 1
  max_capacity        = 4

  task_execution_role_arn = module.iam.task_execution_role_arn
  task_role_arn           = module.iam.task_role_arn
}
