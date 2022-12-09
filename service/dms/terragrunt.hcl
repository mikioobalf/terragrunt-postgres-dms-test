terraform {
  source = "${get_repo_root()}//modules/dms_cross_acount_replication"
}

locals {
  account      = read_terragrunt_config(find_in_parent_folders("account1.hcl"))
  profile      = local.account.locals.profile
  region       = local.account.locals.region
  service_name = "dms-test"
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

dependency "source_db_instance" {
  config_path = "../source"
}

dependency "target_db_instance" {
  config_path = "../target"
}

dependency "vpc" {
  config_path = "../../infra/vpc"
}

dependency "sns" {
  config_path = "../../infra/sns"
}


inputs = {
    service_name                               = local.service_name
    repl_instance_class                        = "dms.t3.micro"
    repl_instance_engine_version               = "3.4.7"
    repl_instance_allocated_storage            = 64
    repl_instance_multi_az                     = true
    repl_instance_apply_immediately            = true
    repl_instance_preferred_maintenance_window = "sun:10:30-sun:14:30"
    repl_instance_publicly_accessible          = true
    repl_subnet_group_subnet_ids               = dependency.vpc.outputs.public_subnets

    source_db_instance = {
      database_name               = dependency.source_db_instance.outputs.db_instance_name
      engine_name                 = dependency.source_db_instance.outputs.db_instance_engine
      username                    = dependency.source_db_instance.outputs.db_instance_username
      password                    = dependency.source_db_instance.outputs.db_instance_password
      port                        = dependency.source_db_instance.outputs.db_instance_port
      server_name                 = dependency.source_db_instance.outputs.db_instance_address
      extra_connection_attributes = "heartbeatFrequency=1;"
    }
    target_db_instance = {
      database_name               = dependency.target_db_instance.outputs.db_instance_name
      engine_name                 = dependency.target_db_instance.outputs.db_instance_engine
      username                    = dependency.target_db_instance.outputs.db_instance_username
      password                    = dependency.target_db_instance.outputs.db_instance_password
      port                        = dependency.target_db_instance.outputs.db_instance_port
      server_name                 = dependency.target_db_instance.outputs.db_instance_address
      extra_connection_attributes = "heartbeatFrequency=1;"
    }
    migration_type                = "full-load-and-cdc"
    replication_task_settings     = file("task_settings.json")
    table_mappings                = file("table_mappings.json")
    sns_topic_arn                 = dependency.sns.outputs.sns_topic_arn

    tags = {
      Name: local.service_name
    }
}
