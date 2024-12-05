variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

variable "security_group_ids" {
  description = "List of security group IDs"
  type        = list(string)
  default     = []
}

variable "region" {
  description = "region"
  type        = string
  default     = "ap-northeast-2"
}

variable "endpoints" {
  description = "List of VPC endpoint services to create"
  type        = list(string)
}

variable "name" {
  description = "Name for tags"
  type        = string
}

variable "route_table_id" {
  description = "ID of the route table to associate with Gateway endpoints"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs for Interface endpoints"
  type        = list(string)
}