module "tags" {
  source      = "../modules/tags"
  name        = var.name
  environment = var.environment
  project_url = var.project_url
  tags        = var.tags
}

module "vpc" {
  source                = "../modules/vpc"
  name                  = var.name
  cidr_block            = var.cidr_block
  azs                   = var.azs
  private_subnet_cidrs  = var.private_subnet_cidrs
  endpoint_subnet_cidrs = var.endpoint_subnet_cidrs

  environment  = var.environment
  project_url  = var.project_url
  tags         = module.tags.tags
}

module "s3" {
  source      = "../modules/s3"
  name        = var.name
  environment = var.environment
  project_url = var.project_url
  tags        = module.tags.tags
}
