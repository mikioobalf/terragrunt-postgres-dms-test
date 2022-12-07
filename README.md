# AWS DMS test set up using Terragrunt

- Source
    - PostgreSQL database
    - Account: `account1`
    - Region: `us-east-1`
- Target: PostgreSQL database
    - PostgreSQL database
    - Account: `account2`
    - Region: `eu-west-1`

In this example, all resources (databases, replication instance) are in public VPCs. To use private VPCs, additional configurations will be required (e.g. VPC Peering, securigy groups).