variable "key_alias" {
  description = "Alias for the KMS key"
  type        = string
}

variable "key_description" {
  description = "Description for the KMS key"
  type        = string
  default     = "KMS key for Vault auto unseal"
}

variable "enable_key_rotation" {
  description = "Enable automatic key rotation"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags for the KMS key"
  type        = map(string)
  default     = {}
}
