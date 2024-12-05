variable "public_subnet_id" {
  description = "Public subnet ID for NAT gateway"
  type        = string
}

variable "name" {
  description = "Name for NAT gateway"
  type        = string
  default     = "default-nat"
}

variable "az" {
  type        = string
  description = "The Availability Zone of the public subnet."
}
