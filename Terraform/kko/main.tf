provider "aws" {
  region = var.region
}

module "vpc" {
  source     = "./modules/vpc"
  cidr_block = var.vpc_cidr
  name       = var.name
}

module "public_subnets" {
  source             = "./modules/subnet"
  vpc_id             = module.vpc.vpc_id
  subnet_cidrs       = var.public_subnet_cidrs
  availability_zones = var.availability_zones
  name               = var.public_subnet_name
  public             = true
  additional_tags = {
    "kubernetes.io/role/elb"                     = "1"
    "kubernetes.io/cluster/dododocs-eks-cluster" = "shared"
  }
}

module "private_subnets" {
  source             = "./modules/subnet"
  vpc_id             = module.vpc.vpc_id
  subnet_cidrs       = var.private_subnet_cidrs
  availability_zones = var.availability_zones
  name               = var.private_subnet_name
  additional_tags = {
    "kubernetes.io/cluster/dododocs-eks-cluster" = "shared"
  }
}

module "igw" {
  source = "./modules/igw"
  vpc_id = module.vpc.vpc_id
  name   = var.igw_name
}

module "nat" {
  source           = "./modules/nat"
  public_subnet_id = module.public_subnets.subnet_ids[0]
  az               = module.public_subnets.subnet_availability_zones[0]
  name             = var.nat_name
}

module "route_table_private" {
  source         = "./modules/route_table"
  vpc_id         = module.vpc.vpc_id
  subnet_ids     = module.private_subnets.subnet_ids
  gateway_id     = null
  nat_gateway_id = module.nat.nat_gateway_id
  name           = var.private_rt_name
}

module "route_table_public" {
  source         = "./modules/route_table"
  vpc_id         = module.vpc.vpc_id
  subnet_ids     = module.public_subnets.subnet_ids
  gateway_id     = module.igw.igw_id
  nat_gateway_id = null
  name           = var.public_rt_name
}

module "sg" {
  source      = "./modules/sg"
  name        = var.name
  description = var.sg_description
  vpc_id      = module.vpc.vpc_id

  ingress_rules = var.sg_ingress_rules
  egress_rules  = var.sg_egress_rules
}

module "iam" {
  source        = "./modules/iam"
  name          = "ec2-ssm-etc..-role-kko"
  s3_bucket_arn = module.s3_bucket.s3_bucket_arn
  tags = {
    Environment = var.environment
    Team        = "DevOps-kko"
  }
}

module "vpc_endpoints" {
  source             = "./modules/vpc_endpoints"
  name               = var.name
  vpc_id             = module.vpc.vpc_id
  region             = var.region
  subnet_ids         = module.private_subnets.subnet_ids
  security_group_ids = [module.sg.security_group_id]
  endpoints          = var.endpoints
  route_table_id     = module.route_table_private.route_table_id
}

module "s3_bucket" {
  source        = "./modules/s3"
  bucket_name   = var.bucket_name
  public_access = var.s3_public_access
  environment   = var.environment
  vpc_endpoint  = module.vpc_endpoints.s3_endpoint
}

module "kms_vault" {
  source              = "./modules/kms"
  key_alias           = "vault-auto-unseal"
  key_description     = "KMS key for Vault auto unseal"
  enable_key_rotation = true
  tags = {
    Environment = "prod"
    Project     = "vault-auto-unseal"
  }
}

module "rds" {
  source                 = "./modules/rds"
  name                   = var.name
  instance_class         = var.instance_class
  allocated_storage      = var.allocated_storage
  vpc_security_group_ids = [module.sg.security_group_id]
  port                   = var.db_port
  subnet_ids             = module.private_subnets.subnet_ids
}
