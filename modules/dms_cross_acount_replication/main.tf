locals {
    service_name                               = var.service_name
    create_iam_roles                           = var.create_iam_roles
    repl_instance_class                        = var.repl_instance_class
    repl_instance_engine_version               = var.repl_instance_engine_version
    repl_instance_allocated_storage            = var.repl_instance_allocated_storage
    repl_instance_kms_key_arn                  = var.repl_instance_kms_key_arn
    repl_instance_multi_az                     = var.repl_instance_multi_az
    repl_instance_apply_immediately            = var.repl_instance_apply_immediately
    repl_instance_preferred_maintenance_window = var.repl_instance_preferred_maintenance_window
    repl_instance_publicly_accessible          = var.repl_instance_publicly_accessible
    repl_instance_vpc_security_group_ids       = var.repl_instance_vpc_security_group_ids 
    repl_subnet_group_subnet_ids               = var.repl_subnet_group_subnet_ids
    source_db_instance                         = var.source_db_instance
    target_db_instance                         = var.target_db_instance
    migration_type                             = var.migration_type
    sns_topic_arn                              = var.sns_topic_arn
    replication_task_settings                  = var.replication_task_settings
    table_mappings                             = var.table_mappings
    tags                                       = var.tags
}

module "database_migration_service" {
  source  = "terraform-aws-modules/dms/aws"
  version = "~> 1.0"
  create  = true

  # IAM Roles (The necessary roles should be created separately)
  create_iam_roles              = local.create_iam_roles

  # Subnet group
  create_repl_subnet_group      = true
  repl_subnet_group_name        = "repl-subnet-${local.service_name}"
  repl_subnet_group_description = "DMS Subnet group for ${local.service_name}"
  repl_subnet_group_subnet_ids  = local.repl_subnet_group_subnet_ids

  # Instance
  repl_instance_allocated_storage            = local.repl_instance_allocated_storage
  repl_instance_auto_minor_version_upgrade   = true
  repl_instance_allow_major_version_upgrade  = true
  repl_instance_apply_immediately            = local.repl_instance_apply_immediately
  repl_instance_engine_version               = local.repl_instance_engine_version
  repl_instance_multi_az                     = local.repl_instance_multi_az
  repl_instance_preferred_maintenance_window = local.repl_instance_preferred_maintenance_window
  repl_instance_publicly_accessible          = local.repl_instance_publicly_accessible
  repl_instance_class                        = local.repl_instance_class
  repl_instance_id                           = "dms-instance-${local.service_name}"
  repl_instance_vpc_security_group_ids       = local.repl_instance_vpc_security_group_ids

  endpoints = {
    source = {
      database_name               = local.source_db_instance.database_name
      endpoint_id                 = "source-db-${local.service_name}"
      endpoint_type               = "source"
      engine_name                 = local.source_db_instance.engine_name
      extra_connection_attributes = local.source_db_instance.extra_connection_attributes 
      username                    = local.source_db_instance.username
      password                    = local.source_db_instance.password
      port                        = local.source_db_instance.port
      server_name                 = local.source_db_instance.server_name
      ssl_mode                    = "none"
      tags                        = local.tags
    }

    target = {
      database_name               = local.target_db_instance.database_name
      endpoint_id                 = "target-db-${local.service_name}"
      endpoint_type               = "target"
      engine_name                 = local.target_db_instance.engine_name
      extra_connection_attributes = local.target_db_instance.extra_connection_attributes 
      username                    = local.target_db_instance.username
      password                    = local.target_db_instance.password
      port                        = local.target_db_instance.port
      server_name                 = local.target_db_instance.server_name
      ssl_mode                    = "none"
      tags                        = local.tags
    }
  }

  replication_tasks = {
    cdc_ex = {
      replication_task_id       = "replication-task-${local.service_name}"
      migration_type            = local.migration_type
      replication_task_settings = file("task_settings.json")
      table_mappings            = file("table_mappings.json")
      source_endpoint_key       = "source"
      target_endpoint_key       = "target"
      ignore_changes            = ["replication_task_settings"]
      tags                      = local.tags
    }
  }

  event_subscriptions = {
    instance = {
      name                             = "instance-events-${local.service_name}"
      enabled                          = true
      instance_event_subscription_keys = ["dms-instance-${local.service_name}"]
      source_type                      = "replication-instance"
      sns_topic_arn                    = local.sns_topic_arn
      event_categories                 = [
        "failure",
        "creation",
        "deletion",
        "maintenance",
        "failover",
        "low storage",
        "configuration change"
      ]
      tags = local.tags
    }
    task = {
      name                         = "task-events-${local.service_name}"
      enabled                      = true
      task_event_subscription_keys = ["cdc_ex"]
      source_type                  = "replication-task"
      sns_topic_arn                = local.sns_topic_arn
      event_categories             = [
        "failure",
        "state change",
        "creation",
        "deletion",
        "configuration change"
      ]
      tags = local.tags
    }
  }

  tags = local.tags
}