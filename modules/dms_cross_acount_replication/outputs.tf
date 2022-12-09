# https://registry.terraform.io/modules/terraform-aws-modules/dms/aws/latest?tab=outputs

output "certificates" {
  description = "A map of maps containing the certificates created and their full output of attributes and values"
  value       = module.database_migration_service.certificates
  sensitive   = true
}

output "dms_access_for_endpoint_iam_role_arn" {
  description = "Amazon Resource Name (ARN) specifying the role"
  value       = module.database_migration_service.dms_access_for_endpoint_iam_role_arn
}

output "dms_access_for_endpoint_iam_role_id" {
  description = "Name of the IAM role"
  value       = module.database_migration_service.dms_access_for_endpoint_iam_role_id
}

output "dms_access_for_endpoint_iam_role_unique_id" {
  description = "Stable and unique string identifying the role"
  value       = module.database_migration_service.dms_access_for_endpoint_iam_role_unique_id
}

output "dms_cloudwatch_logs_iam_role_arn" {
  description = "Amazon Resource Name (ARN) specifying the role"
  value       = module.database_migration_service.dms_cloudwatch_logs_iam_role_arn
}

output "dms_cloudwatch_logs_iam_role_id" {
  description = "Name of the IAM role"
  value       = module.database_migration_service.dms_cloudwatch_logs_iam_role_id
}

output "dms_cloudwatch_logs_iam_role_unique_id" {
  description = "Stable and unique string identifying the role"
  value       = module.database_migration_service.dms_cloudwatch_logs_iam_role_unique_id
}

output "dms_vpc_iam_role_arn" {
  description = "Amazon Resource Name (ARN) specifying the role"
  value       = module.database_migration_service.dms_vpc_iam_role_arn
}

output "dms_vpc_iam_role_id" {
  description = "Name of the IAM role"
  value       = module.database_migration_service.dms_vpc_iam_role_id
}

output "dms_vpc_iam_role_unique_id" {
  description = "Stable and unique string identifying the role"
  value       = module.database_migration_service.dms_vpc_iam_role_unique_id
}

output "endpoints" {
  description = "A map of maps containing the endpoints created and their full output of attributes and values"
  value       = module.database_migration_service.endpoints
  sensitive   = true
}

output "event_subscriptions" {
  description = "A map of maps containing the event subscriptions created and their full output of attributes and values"
  value       = module.database_migration_service.event_subscriptions
}

output "replication_instance_arn" {
  description = "The Amazon Resource Name (ARN) of the replication instance"
  value       = module.database_migration_service.replication_instance_arn
}

output "replication_instance_private_ips" {
  description = "A list of the private IP addresses of the replication instance"
  value       = module.database_migration_service.replication_instance_private_ips
}

output "replication_instance_public_ips" {
  description = "A list of the public IP addresses of the replication instance"
  value       = module.database_migration_service.replication_instance_public_ips
}

output "replication_instance_tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider `default_tags` configuration block"
  value       = module.database_migration_service.replication_instance_tags_all
}

output "replication_subnet_group_id" {
  description = "The ID of the subnet group"
  value       = module.database_migration_service.replication_subnet_group_id
}

output "replication_tasks" {
  description = "A map of maps containing the replication tasks created and their full output of attributes and values"
  value       = module.database_migration_service.replication_tasks
}