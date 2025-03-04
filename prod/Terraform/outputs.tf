output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

output "ec2_role_arn" {
  value = module.iam_ec2.role_arn
}

output "ec2_instance_profile_name" {
  value = module.iam_ec2.instance_profile_name
}

output "ec2_mapped_by_name" {
  description = "배포된 모든 EC2 인스턴스 정보"
  value       = module.ec2.ec2_mapped_by_name
}

# output "sg" {
#   description = "sg 목록"
#   value       = local.sg_ids
# }

output "sg_ids" {
  description = "List of security group IDs"
  value       = module.sg[*].sg_id  # 리스트 형식으로 출력
}

# output "s3_buckets" {
#   description = "Created S3 bucket details"
#   value       = { for k, v in module.s3 : k => v.s3_bucket_id }
# }