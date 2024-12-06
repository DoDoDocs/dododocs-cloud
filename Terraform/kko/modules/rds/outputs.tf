output "db_instance_identifier" {
  description = "The RDS instance identifier"
  value       = module.db.db_instance_identifier
}

output "db_instance_endpoint" {
  description = "The connection endpoint for the RDS instance"
  value       = module.db.db_instance_endpoint
}

output "db_instance_port" {
  description = "The port the database is listening on"
  value       = module.db.db_instance_port
}

output "db_instance_arn" {
  description = "The ARN of the RDS instance"
  value       = module.db.db_instance_arn
}

output "db_instance_address" {
  description = "The address of the RDS instance"
  value       = module.db.db_instance_address
}

output "db_subnet_group_name" {
  description = "The name of the DB subnet group associated with the RDS instance"
  value       = module.db.db_subnet_group_id
}