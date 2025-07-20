resource "aws_vpc" "this" {
  cidr_block           = var.cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags                 = var.tags
}

resource "aws_subnet" "private" {
  count                   = length(var.private_subnet_cidrs)
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.private_subnet_cidrs[count.index]
  availability_zone       = var.azs[count.index]
  map_public_ip_on_launch = false
  tags                    = var.tags
}

resource "aws_subnet" "endpoints" {
  count                   = length(var.endpoint_subnet_cidrs)
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.endpoint_subnet_cidrs[count.index]
  availability_zone       = var.azs[count.index]
  map_public_ip_on_launch = false
  tags                    = var.tags
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.this.id
  tags   = var.tags
}

resource "aws_route_table_association" "private" {
  count          = length(aws_subnet.private)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}

# --- VPC Endpoints ---
resource "aws_vpc_endpoint" "s3" {
  vpc_id            = aws_vpc.this.id
  service_name      = "com.amazonaws.${data.aws_region.current.name}.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = [aws_route_table.private.id]
  tags              = var.tags
}

resource "aws_vpc_endpoint" "interface" {
  for_each = toset([
    "sqs",
    "ecr.api",
    "ecr.dkr",
    "logs"
  ])

  vpc_id            = aws_vpc.this.id
  service_name      = "com.amazonaws.${data.aws_region.current.name}.${each.key}"
  vpc_endpoint_type = "Interface"
  subnet_ids        = aws_subnet.endpoints[*].id
  security_group_ids = [] # Added in ECS module
  private_dns_enabled = true
  tags                = var.tags
}

data "aws_region" "current" {}
