# AWS DMS test set up using a custom Terraform module 

This repositoy contains an example configuration to set up a simple database copy from one AWS account to another.

The module [dms_cross_account_replication](./modules/dms_cross_acount_replication/) is a wrapper module of the third-party [Terraform AWS DMS module](https://registry.terraform.io/modules/terraform-aws-modules/dms/aws/latest) to make the configuration simpler by adding some default configuration.

The [example configuration set up](./service/dms/) uses this module to perform a database copy with the following configuration.

- [Source](./service/source/)
    - PostgreSQL database
    - Account: `account1`
    - Region: `us-east-1`
- [Target](./service/target/)
    - PostgreSQL database
    - Account: `account2`
    - Region: `eu-west-1`

In this example, all resources (databases, replication instance) are in public VPCs. To use private VPCs, additional configurations will be required (e.g. VPC Peering, securigy groups).

The repository is structured as follows:

```
.
├── README.md                     <= This file
├── account1.hcl                  <= Settings for the AWS account `account1`
├── account2.hcl                  <= Settings for the AWS account `account1`
├── infra                         <= The AWS resources required for the DMS module
│   ├── iam 
│   │   ├── iam.tf
│   │   ├── main.tf
│   │   └── terraform.tfstate
│   ├── sns
│   │   └── terragrunt.hcl
│   └── vpc
│       └── terragrunt.hcl
├── modules                       <= The custome DMS module `dms_cross_acount_replication`)
│   └── dms_cross_acount_replication
│       ├── README.md
│       ├── main.tf
│       ├── outputs.tf
│       └── variables.tf
├── service                       <= The resources the user creates
│   ├── dms                       <= A sample configuration to copy a PostgreSQL database from `account1` to `account2`
│   │   ├── README.md
│   │   ├── table_mappings.json
│   │   ├── task_settings.json
│   │   └── terragrunt.hcl
│   ├── dms2                      <= A sample configuration to copy a MySQL database from `account1` to `account2`
│   │   ├── README.md
│   │   ├── table_mappings.json
│   │   ├── task_settings.json
│   │   └── terragrunt.hcl
│   ├── source                    <= The source PostgreSQL database used in the sample configuration
│   │   └── terragrunt.hcl
│   ├── source2                   <= The source MySQL database used in the sample configuration
│   │   └── terragrunt.hcl
│   ├── target                    <= The target PostgreSQL database used in the sample configuration
│   │   └── terragrunt.hcl
│   └── target2                   <= The target MySQL database used in the sample configuration
│       └── terragrunt.hcl
└── terragrunt.hcl
```


