output "vpc_id" {
  value = aws_vpc.this.id
}

output "private_subnet_ids" {
  value = aws_subnet.private[*].id
}

output "endpoint_subnet_ids" {
  value = aws_subnet.endpoints[*].id
}

output "security_group_id" {
  description = "Security Group ID created inside the VPC module"
  value = module.security-group.security_group_id
}
