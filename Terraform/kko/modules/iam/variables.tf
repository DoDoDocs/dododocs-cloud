variable "name" {
  description = "Name of the IAM role"
  type        = string
}

variable "s3_bucket_arn" {
  description = "ARN of the S3 bucket to allow access"
  type        = string
}

variable "tags" {
  description = "Tags to apply to the IAM role"
  type        = map(string)
  default     = {}
}