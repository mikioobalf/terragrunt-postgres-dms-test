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