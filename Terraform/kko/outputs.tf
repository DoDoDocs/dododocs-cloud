# VPC Module Outputs
output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

# Public Subnets Outputs
output "public_subnet_ids" {
  description = "The IDs of the public subnets"
  value       = module.public_subnets.subnet_ids
}

# Internet Gateway Outputs
output "internet_gateway_id" {
  description = "The ID of the Internet Gateway"
  value       = module.igw.igw_id
}

# Security Group Outputs
output "security_group_id" {
  description = "The ID of the security group"
  value       = module.sg.security_group_id
}

# IAM Role Outputs
output "iam_role_name" {
  description = "The name of the IAM role"
  value       = module.iam.role_name
}

# VPC Endpoints Outputs
output "vpc_endpoints" {
  description = "The VPC endpoints created"
  value       = module.vpc_endpoints.endpoints
}

output "s3_endpoint" {
  description = "The S3 VPC endpoint ID"
  value       = lookup(module.vpc_endpoints.endpoints, "s3", null).id
}

# Route Table Outputs
output "public_route_table_ids" {
  description = "The IDs of the public route tables"
  value       = module.route_table_public.route_table_ids
}

output "private_route_table_ids" {
  description = "The IDs of the private route tables"
  value       = module.route_table_private.route_table_ids
}

output "s3_bucket_arn" {
  description = "The ARN of the S3 bucket"
  value       = module.s3_bucket.s3_bucket_arn
}
