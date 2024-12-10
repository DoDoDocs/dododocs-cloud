terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.70.0"
    }
  }
  backend "s3" {
    bucket         = "terraform-state-backup-kko"  # S3 버킷 이름
    key            = "terraform/terraform.tfstate" # tfstate 저장 경로
    region         = "ap-northeast-2"
    dynamodb_table = "terraform-tfstate-lock" # dynamodb table 이름
  }
}

provider "aws" {
  region = "ap-northeast-2"
}
