output "endpoints" {
  description = "Map containing the full resource object and attributes for all endpoints created"
  value = {
    for key, endpoint in aws_vpc_endpoint.endpoints :
    key => {
      id                 = endpoint.id
      service_name       = endpoint.service_name
      vpc_endpoint_type  = endpoint.vpc_endpoint_type
      network_interface_ids = endpoint.network_interface_ids
      tags               = endpoint.tags
    }
  }
}

output "s3_endpoint" {
  description = "S3 VPC Endpoint ID"
  value       = try(aws_vpc_endpoint.endpoints["s3"].id, null)
}

output "kms_endpoint" {
  description = "KMS VPC Endpoint ID"
  value       = try(aws_vpc_endpoint.endpoints["kms"].id, null)
}