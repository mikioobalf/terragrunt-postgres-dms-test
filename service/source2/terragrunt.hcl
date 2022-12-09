terraform {
  source = "tfr:///terraform-aws-modules/rds/aws?version=5.1.1"
}

locals {
  account      = read_terragrunt_config(find_in_parent_folders("account1.hcl"))
  profile      = local.account.locals.profile
  region       = local.account.locals.region
  service_name = "dms-test2"
}

generate "provider" {
  path = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
  provider "aws" {
    profile = "${local.profile}"
    region  = "${local.region}"
  }
EOF
}

inputs = {
  identifier = "source-db2"

  engine            = "mysql"
  engine_version    = "5.7.40"
  instance_class    = "db.t3.micro"
  allocated_storage = 5

  db_name  = "source_db2"
  username = "user"
  port     = "3306"

  publicly_accessible = true
  skip_final_snapshot = true

  iam_database_authentication_enabled = false

  maintenance_window      = "Mon:00:00-Mon:03:00"
  backup_window           = "03:00-06:00"
  backup_retention_period = 7

  # Enhanced Monitoring - see example for details on how to create the role
  # by yourself, in case you don't want to create it automatically
  create_monitoring_role = false

  tags = {
    Name: local.service_name
  }

  # DB subnet group
  create_db_subnet_group = false

  # DB parameter group
  family = "mysql5.7"

  # DB option group
  major_engine_version = "5.7"

  # Database Deletion Protection
  deletion_protection = false

  parameters = [
    {
      name = "binlog_format"
      value = "ROW"
    },
    {
      name = "binlog_checksum"
      value = "NONE"
    },
    {
      name = "binlog_row_image"
      value = "FULL"
    }
  ]
}
