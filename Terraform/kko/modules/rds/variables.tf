variable "name" {
  description = "Name prefix for resources"
  type        = string
  default     = "my-rds"
}

variable "vpc_security_group_ids" {
  description = "VPC Security Groups associated with the database"
  type        = list(string)
}

variable "engine" {
  description = "Database engine (e.g., mysql, postgres)"
  type        = string
  default     = "mysql"
}

variable "engine_version" {
  description = "Version of the database engine"
  type        = string
  default     = "8.0"
}

variable "instance_class" {
  description = "Instance class for the database"
  type        = string
}

variable "allocated_storage" {
  description = "Allocated storage size in GB"
  type        = number
}

variable "db_name" {
  description = "Name of the database"
  type        = string
  default     = "dododocs"
}

variable "username" {
  description = "Master username for the database"
  type        = string
  default     = "admin"
}

variable "port" {
  description = "Port number for the database"
  type        = string
}

variable "subnet_ids" {
  description = "DB와 연결된 서브넷목록입니다."
  type        = list(string)
}
