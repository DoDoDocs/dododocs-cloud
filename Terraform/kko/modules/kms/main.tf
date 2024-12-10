resource "aws_kms_key" "vault" {
  description         = var.key_description
  enable_key_rotation  = var.enable_key_rotation
  deletion_window_in_days = 7

  tags = var.tags
}

resource "aws_kms_alias" "vault_alias" {
  name          = "alias/${var.key_alias}"
  target_key_id = aws_kms_key.vault.id
}
