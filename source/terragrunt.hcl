terraform {
  source = "tfr:///terraform-aws-modules/rds/aws?version=5.1.1"
}

generate "provider" {
  path = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
  provider "aws" {
    profile = "account1"
    region  = "us-east-1"
  }
EOF
}

inputs = {
  identifier = "source-db"

  create_cloudwatch_log_group = true
  create_db_subnet_group      = true 

  engine                = "postgres"
  engine_version        = "13.7"
  instance_class        = "db.t3.micro"
  allocated_storage     = 5
  max_allocated_storage = 20

  db_name                = "source_db"
  username               = "postgres"
  port                   = "5432"
  create_random_password = true
  publicly_accessible    = true
  skip_final_snapshot    = true

  # Enhanced Monitoring - see example for details on how to create the role
  # by yourself, in case you don't want to create it automatically
  create_monitoring_role = false

  tags = {
    Owner       = "user"
    Environment = "dev"
  }

  # DB subnet group
  create_db_subnet_group = false
  subnet_ids             = []


  # DB option group
  major_engine_version = "13.7"

  # Database Deletion Protection
  deletion_protection = false

  # DB parameter group
  family               = "postgres13"
  parameter_group_use_name_prefix = false
  parameters           = [
    {
      name = "rds.logical_replication"
      value = "1"
      apply_method = "pending-reboot"
    },
    {
      name = "max_logical_replication_workers"
      value = "20"
      apply_method = "pending-reboot"
    }
  ]
}
