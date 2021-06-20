output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

output "public_subnets" {
  description = "List of IDs of public subnets"
  value       = module.vpc.public_subnets
}

output "public_subnets_cidr_blocks" {
  description = "List of Cidr blocks for public subnets"
  value       = module.vpc.public_subnets_cidr_blocks
}

output "region" {
    description = "The AWS region the VPC is deployed in"
    value       = var.region
}

output "environment" {
    description = "Name of environment"
    value       = var.environment
}
