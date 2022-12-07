terraform {
  source = "tfr:///terraform-aws-modules/dms/aws?version=1.6.1"
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

dependency "vpc" {
  config_path = "../vpc"
}

dependency "sns" {
  config_path = "../sns"
}

dependency "source" {
  config_path = "../source"
}

dependency "target" {
  config_path = "../target"
}

inputs = {
  # Subnet group
  repl_subnet_group_name        = "dmssg"
  repl_subnet_group_description = "DMS Subnet group"
  repl_subnet_group_subnet_ids  = dependency.vpc.outputs.public_subnets

  # Instance
  repl_instance_id                           = "dmstest"
  repl_instance_allocated_storage            = 64
  repl_instance_auto_minor_version_upgrade   = true
  repl_instance_allow_major_version_upgrade  = true
  repl_instance_apply_immediately            = true
  repl_instance_engine_version               = "3.4.7"
  repl_instance_multi_az                     = true
  repl_instance_preferred_maintenance_window = "sun:10:30-sun:14:30"
  repl_instance_publicly_accessible          = true
  repl_instance_class                        = "dms.t3.micro"
  repl_instance_vpc_security_group_ids       = []

  endpoints = {
    source = {
      database_name               = dependency.source.outputs.db_instance_name
      endpoint_id                 = "source-db"
      endpoint_type               = "source"
      engine_name                 = dependency.source.outputs.db_instance_engine
      extra_connection_attributes = "heartbeatFrequency=1;"
      username                    = dependency.source.outputs.db_instance_username
      password                    = dependency.source.outputs.db_instance_password
      port                        = dependency.source.outputs.db_instance_port
      server_name                 = dependency.source.outputs.db_instance_address
      ssl_mode                    = "none"
      tags                        = { EndpointType = "source" }
    }

    target = {
      database_name               = dependency.target.outputs.db_instance_name
      endpoint_id                 = "target-db"
      endpoint_type               = "target"
      engine_name                 = dependency.target.outputs.db_instance_engine
      extra_connection_attributes = "heartbeatFrequency=1;"
      username                    = dependency.target.outputs.db_instance_username
      password                    = dependency.target.outputs.db_instance_password
      port                        = dependency.target.outputs.db_instance_port
      server_name                 = dependency.target.outputs.db_instance_address
      ssl_mode                    = "none"
      tags                        = { EndpointType = "target" }
    }
  }

  replication_tasks = {
    cdc_ex = {
      replication_task_id       = "dms-test-cdc"
      migration_type            = "full-load-and-cdc"
      replication_task_settings = file("task_settings.json")
      table_mappings            = file("table_mappings.json")
      source_endpoint_key       = "source"
      target_endpoint_key       = "target"
      ignore_changes            = ["replication_task_settings"]
      tags                      = { Task = "PostgreSQL-to-PostgreSQL" }
    }
  }

  event_subscriptions = {
    instance = {
      name                             = "instance-events"
      enabled                          = true
      instance_event_subscription_keys = ["dms_test_id"]
      source_type                      = "replication-instance"
      sns_topic_arn                    = dependency.sns.outputs.sns_topic_arn
      event_categories                 = [
        "failure",
        "creation",
        "deletion",
        "maintenance",
        "failover",
        "low storage",
        "configuration change"
      ]
    }
    task = {
      name                         = "task-events"
      enabled                      = true
      task_event_subscription_keys = ["cdc_ex"]
      source_type                  = "replication-task"
      sns_topic_arn                = dependency.sns.outputs.sns_topic_arn
      event_categories             = [
        "failure",
        "state change",
        "creation",
        "deletion",
        "configuration change"
      ]
    }
  }

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}
