module "db" {
  source = "terraform-aws-modules/rds/aws"

  identifier = "${var.name}-rds-main"

  engine            = var.engine
  engine_version    = var.engine_version
  instance_class    = var.instance_class
  allocated_storage = var.allocated_storage

  db_name                     = var.db_name
  username                    = var.username
  manage_master_user_password = false
  password                    = ""
  port                        = "3306"

  iam_database_authentication_enabled = true

  vpc_security_group_ids = var.vpc_security_group_ids

  #   maintenance_window = "Mon:00:00-Mon:03:00"
  backup_window = "03:00-06:00"

  tags = {
    Owner       = "dododocs"
    Environment = "prod"
  }

  # DB subnet group
  create_db_subnet_group = true
  subnet_ids             = var.subnet_ids

  # Database Deletion Protection
  deletion_protection = true

  # DB parameter group
  family = "${var.engine}${var.engine_version}"

  # DB option group
  major_engine_version = var.engine_version
}
