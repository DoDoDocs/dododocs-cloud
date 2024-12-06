output "key_id" {
  description = "The ID of the KMS key"
  value       = aws_kms_key.vault.id
}

output "key_arn" {
  description = "The ARN of the KMS key"
  value       = aws_kms_key.vault.arn
}