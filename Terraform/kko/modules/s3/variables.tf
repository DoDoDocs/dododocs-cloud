variable "bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
}

variable "force_destroy" {
  description = "Whether to force destroy the S3 bucket"
  type        = bool
  default     = false
}

variable "environment" {
  description = "Environment for tagging (e.g., dev, staging, prod)"
  type        = string
}

variable "tags" {
  description = "Additional tags to apply to the bucket"
  type        = map(string)
  default     = {}
}

variable "public_access" {
  description = "퍼블릭 액세스 통합 컨트롤입니다."
  type        = bool
  default     = true
}

variable "vpc_endpoint" {
  description = "연결할 vpc_endpoint에 대한 정보"
  type        = string
  default     = ""
}
