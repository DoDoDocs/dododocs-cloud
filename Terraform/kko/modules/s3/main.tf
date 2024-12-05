module "s3_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"

  bucket        = var.bucket_name
  force_destroy = true

  block_public_acls       = var.public_access
  block_public_policy     = var.public_access
  ignore_public_acls      = var.public_access
  restrict_public_buckets = var.public_access

  tags = {
    Name        = var.bucket_name
    Environment = var.environment
  }
}

resource "aws_s3_bucket_policy" "s3_bucket_policy" {
  bucket = module.s3_bucket.s3_bucket_id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "AllowVPCEndpointAccess"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:*"
        Resource = [
          module.s3_bucket.s3_bucket_arn,
          "${module.s3_bucket.s3_bucket_arn}/*"
        ]
        Condition = {
          StringEquals = {
            "aws:SourceVpce" : var.vpc_endpoint
          }
        }
      }
    ]
  })
}
