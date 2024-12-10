variable "region" {
  description = "AWS region for the VPC endpoint"
  type        = string
  default     = "ap-northeast-2"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "name" {
  description = "Name prefix for resources"
  type        = string
  default     = "my-vpc"
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
  default     = ["ap-northeast-2a", "ap-northeast-2c"]
}

variable "public_subnet_cidrs" {
  description = "List of CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "List of CIDR blocks for private subnets"
  type        = list(string)
  default     = ["10.0.101.0/24", "10.0.102.0/24"]
}

variable "public_subnet_name" {
  description = "Name prefix for public subnets"
  type        = string
  default     = "my-public-subnet"
}

variable "private_subnet_name" {
  description = "Name prefix for private subnets"
  type        = string
  default     = "my-private-subnet"
}

variable "igw_name" {
  description = "Name for the internet gateway"
  type        = string
  default     = "my-igw"
}

variable "nat_name" {
  description = "Name for NAT gateway"
  type        = string
  default     = "my-nat"
}

variable "private_rt_name" {
  description = "Name for private route table"
  type        = string
  default     = "my-private-rt"
}

variable "public_rt_name" {
  description = "Name for public route table"
  type        = string
  default     = "my-public-rt"
}

### sg
variable "sg_description" {
  description = "The description of the security group"
  type        = string
  default     = "Security group managed by Terraform"
}

variable "sg_ingress_rules" {
  description = "Ingress rules for the security group"
  type = list(object({
    id               = string
    from_port        = number
    to_port          = number
    protocol         = string
    cidr_blocks      = list(string)
    ipv6_cidr_blocks = list(string)
  }))
  default = []
}

variable "sg_egress_rules" {
  description = "Egress rules for the security group"
  type = list(object({
    id               = string
    from_port        = number
    to_port          = number
    protocol         = string
    cidr_blocks      = list(string)
    ipv6_cidr_blocks = list(string)
  }))
  default = []
}

### endpoint
variable "endpoints" {
  description = "List of VPC endpoint services to create"
  type        = list(string)
}

### s3
variable "bucket_name" {
  description = "The name of the S3 bucket"
  type        = string
  default     = "dododocs-vault"
}

variable "environment" {
  description = "The environment tag (e.g., dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "s3_public_access" {
  description = "s3 퍼블릭 엑세스 설정입니다, true로 설정하면 퍼블릭엑세스들이 차단됩니다."
  type        = bool
  default     = true
}

### rds
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

variable "db_port" {
  description = "Port number for the database"
  type        = string
  default     = "3306"
}






