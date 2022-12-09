# dms_cross_account_replication module 

This is a Terraform module to migrate an AWS RDS database from one account/region to another account/region using [AWS Database Migration Service](https://aws.amazon.com/dms/).
It is implemented as a wrapper for the third-party [Terraform AWS DMS module](https://registry.terraform.io/modules/terraform-aws-modules/dms/aws/latest) to make the configuration simpler by adding some default configuration. Therefore, the functionality is a subset of AWS DMS.

## Prerequisites and assumptions

As this module is just a wrapper for AWS DMS, it cannot do beyond what AWS DMS can do. For more details about AWS DMS, check the [AWS User guide](https://docs.aws.amazon.com/dms/latest/userguide/Welcome.html).

The following AWS documentation explains more details for each database type.

- [Sources for data migration](https://docs.aws.amazon.com/dms/latest/userguide/CHAP_Source.html)

In addition, this module makes the following assumptions:

- The replication is 1 to 1, i.e. there is only one source database and only one target database.
- The following resources have already been made available:

    - A VPC for the replication instance. The subnet IDs must be specified in the configuration file.
    - An SNS topic for event subscription. The ARN of the SNS topic must be specified in the configuration file.
    - Required [DMS IAM resources](https://docs.aws.amazon.com/dms/latest/userguide/CHAP_Security.html#CHAP_Security.APIRole).




## Input variables

A subset of the input variables for [Terraform AWS DMS module](https://registry.terraform.io/modules/terraform-aws-modules/dms/aws/latest) can be specified in the configuration file.

| Variable | Description | Type | Required | Default |
| --- | --- | ---  | --- | --- |
| create_iam_roles | Determines whether the required [DMS IAM resources](https://docs.aws.amazon.com/dms/latest/userguide/CHAP_Security.html#CHAP_Security.APIRole) will be created| `bool` | No | `false` |
| migration_type | The migration type. Can be one of `full-load`, `cdc` or `full-load-and-cdc`| `string` |  No | `full-load-and-cdc` |  
| repl_instance_allocated_storage | The amount of storage (in gigabytes) to be initially allocated for the replication instance (Min: 5, Max: 6144).| `string`| No | `50` |
| repl_instance_apply_immediately | Indicates whether the changes should be applied immediately or during the next maintenance window. Only used when updating an existing resource.| `bool` | No | `false` |
| repl_instance_class | The compute and memory capacity of the replication instance as specified by the replication instance class. See [AWS DMS User Guide](https://docs.aws.amazon.com/dms/latest/userguide/CHAP_ReplicationInstance.Types.html) for available instance sizes and advice on which one to choose.| `string` | Yes | |
| repl_instance_engine_version | The [engine version](https://docs.aws.amazon.com/dms/latest/userguide/CHAP_ReleaseNotes.html) number of the replication instance.| `string` | No | `3.4.7` |
| repl_instance_kms_key_arn | The Amazon Resource Name (ARN) for the KMS key that will be used to encrypt the connection parameters. If you do not specify a value for kms_key_arn, then AWS DMS will use your default encryption key. AWS KMS creates the default encryption key for your AWS account. Your AWS account has a different default encryption key for each AWS region.| `string`| No | `null` |
| repl_instance_multi_az | Specifies if the replication instance is a multi-az deployment.| `bool` | No | `null` |
| repl_instance_preferred_maintenance_window | The weekly time range during which system maintenance can occur, in Universal Coordinated Time (UTC).| `string` | No | `sun:10:30-sun:14:30` |
| repl_instance_publicly_accessible | Specifies the accessibility options for the replication instance. A value of true represents an instance with a public IP address. A value of false represents an instance with a private IP address.| `bool` | No | `false` | 
| repl_instance_vpc_security_group_ids | A list of VPC security group IDs to be used with the replication instance. The VPC security groups must work with the VPC containing the replication instance.| list | No | `[]` |
| repl_subnet_group_subnet_ids | A list of the EC2 subnet IDs for the subnet group.| list(`string`) | Yes | |
| replication_task_settings | An escaped JSON string that contains the task settings. For a complete list of task settings, see [Task Settings for AWS Database Migration Service Tasks.](http://docs.aws.amazon.com/dms/latest/userguide/CHAP_Tasks.CustomizingTasks.TaskSettings.html). See [the example file](../../service/dms/task_settings.json). | any | Yes | |
| service_name | An identifier used to distinguish the DMS resources for each service. This must be unique across the AWS account. | `string` | Yes | |
| sns_topic_arn | The ARN of the SNS topic to be used for event subscriptions| `string` | Yes | | 
| source_db_instance | A map object that defines the source database instance with the following attributes: `database_name`, `engine_name`, `username`, `password`, `port` and `server_name`. See [the example Terragrunt file](../../service/dms/terragrunt.hcl). | map | Yes | | 
| table_mappings | An escaped JSON string that contains the table mappings. For information on table mapping see [Using Table Mapping with an AWS Database Migration Service Task to Select and Filter Data](http://docs.aws.amazon.com/dms/latest/userguide/CHAP_Tasks.CustomizingTasks.TableMapping.html). See [the example file](../../service/dms/table_mappings.json). | any | Yes | |
| tags | A map of tags to use on all resources| map | No | {} | 
| target_db_instance | A map object that defines the target database instance with the following attributes: `database_name`, `engine_name`, `username`, `password`, `port` and `server_name`. See [the example Terragrunt file](../../service/dms/terragrunt.hcl). | map | Yes | | 

## Configuration example

The configuration example to copy a PostgreSQL database can be found in the [../../service/dms](../../service/dms/) directory.

The sample assumes that the IAM roles, VPC and SNS topic are separately created, as shown in the [../../infra](../../infra/) directory and uses them as dependencies.

The source and target databases are created using AWS RDS module in [../../service/source](../../service/source/) and [../../service/target](../../service/target/), repsectively.

In the example, the resources are created in public VPCs. In reality, it is most likely that the resources are created in private VPCs. In that case, the connectivity between the VPCs need to be separately configured. 

## Provision the resources

After the terragrunt file has been created, the resources can be provisioned by running the standarad Terragrunt commands.

```
$ terragrunt init
$ terragrunt plan
$ terragrunt apply
```

## DMS operations

The replication task can be executed in AWS CLI if the user has appropriate permissions.

- To return information about replication tasks ([command reference](https://awscli.amazonaws.com/v2/documentation/api/latest/reference/dms/describe-replication-tasks.html))

    ```
    aws dms describe-replication-tasks
    ```

- To start a replication task ([command reference](https://awscli.amazonaws.com/v2/documentation/api/latest/reference/dms/start-replication-task.html))

    ```
    aws dms start-replication-task --replication-task-arn <replication task arn> --start-replication-task-type <task type>
    ```

    For example,

    ```
    aws dms start-replication-task --replication-task-arn "arn:aws:dms:us-east-1:009614822317:task:HDAJHEY526ILPDBGNQYGUDUWAU3XMYVLMUW3UNY" --start-replication-task-type resume-processing
    ```

- To stop a replication task ([command reference](https://awscli.amazonaws.com/v2/documentation/api/latest/reference/dms/stop-replication-task.html))

    ```
    aws dms stop-replication-task --replication-task-arn <replication task arn>
    ```

    For example,

    ```
    aws dms stop-replication-task --replication-task-arn "arn:aws:dms:us-east-1:009614822317:task:HDAJHEY526ILPDBGNQYGUDUWAU3XMYVLMUW3UNY"
    ```
