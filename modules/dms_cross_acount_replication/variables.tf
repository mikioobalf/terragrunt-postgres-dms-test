# Service name
variable "service_name" {
  description = "An identifier used to distinguish the DMS resources"
  type        = string
}

# IAM Roles
variable "create_iam_roles" {
  description = "Determines whether the required [DMS IAM resources](https://docs.aws.amazon.com/dms/latest/userguide/CHAP_Security.html#CHAP_Security.APIRole) will be created"
  type        = bool
  default     = false
}

# Replication instance class
variable "repl_instance_class" {
  description = "The compute and memory capacity of the replication instance as specified by the replication instance class. See [AWS DMS User Guide](https://docs.aws.amazon.com/dms/latest/userguide/CHAP_ReplicationInstance.Types.html) for available instance sizes and advice on which one to choose."
  type        = string
}

# Replication instance engine version
variable "repl_instance_engine_version" {
  description = "The [engine version](https://docs.aws.amazon.com/dms/latest/userguide/CHAP_ReleaseNotes.html) number of the replication instance."
  type        = string
  default     = "3.4.7"
}

# Allocated_storage
variable "repl_instance_allocated_storage" {
  description = "The amount of storage (in gigabytes) to be initially allocated for the replication instance (Min: 5, Max: 6144)."
  type        = string
  default     = "50"
}

# Replication instance KMS key ARN
variable "repl_instance_kms_key_arn" {
  description = "The Amazon Resource Name (ARN) for the KMS key that will be used to encrypt the connection parameters. If you do not specify a value for kms_key_arn, then AWS DMS will use your default encryption key. AWS KMS creates the default encryption key for your AWS account. Your AWS account has a different default encryption key for each AWS region."
  type        = string
  default     = null
}

# Multi AZ 
variable "repl_instance_multi_az" {
  description = "Specifies if the replication instance is a multi-az deployment."
  type        = bool
  default     = null
}

# Apply immediately
variable "repl_instance_apply_immediately" {
  description = "Indicates whether the changes should be applied immediately or during the next maintenance window. Only used when updating an existing resource."
  type        = bool
  default     = false
}

# Replication instance preferred maintenance window
variable "repl_instance_preferred_maintenance_window" {
  description = "The weekly time range during which system maintenance can occur, in Universal Coordinated Time (UTC)."
  type        = string
  default     = "sun:10:30-sun:14:30"
}

# Replication instance publicly accessible
variable "repl_instance_publicly_accessible" {
  description = "Specifies the accessibility options for the replication instance. A value of true represents an instance with a public IP address. A value of false represents an instance with a private IP address."
  type        = bool
  default     = false
}

# Replication instance VPC security group IDs
variable "repl_instance_vpc_security_group_ids" {
  description = "A list of VPC security group IDs to be used with the replication instance. The VPC security groups must work with the VPC containing the replication instance."
  type        = list
  default     = []
}

# VPC subnet group subnet IDs
variable "repl_subnet_group_subnet_ids" {
  description = "A list of the EC2 subnet IDs for the subnet group."
  type        = list(string)
}

# Source
variable "source_db_instance" {
  description = "A map object that defines the source database instance"
  type        = map
  default     = {}
}

# Target
variable "target_db_instance" {
  description = "A map object that defines the target database instance"
  type        = map
  default     = {}
}

# Migration type
variable "migration_type" {
  description = "The migration type. Can be one of `full-load` | `cdc` | `full-load-and-cdc`"
  type        = string
  default     = "full-load-and-cdc"
}

# Replication task settings
variable "replication_task_settings" {
  description = "An escaped JSON string that contains the task settings. For a complete list of task settings, see [Task Settings for AWS Database Migration Service Tasks.](http://docs.aws.amazon.com/dms/latest/userguide/CHAP_Tasks.CustomizingTasks.TaskSettings.html)"
  type        = any
}

# Table mappings
variable "table_mappings" {
  description = "An escaped JSON string that contains the table mappings. For information on table mapping see [Using Table Mapping with an AWS Database Migration Service Task to Select and Filter Data](http://docs.aws.amazon.com/dms/latest/userguide/CHAP_Tasks.CustomizingTasks.TableMapping.html)"
  type        = any
}

# SNS topic
variable "sns_topic_arn" {
  description = "The ARN of the SNS topic to be used for event subscriptions"
  type        = string
}

# Tags
variable "tags" {
  description = "A map of tags to use on all resources"
  type        = map
  default     = {}
}

