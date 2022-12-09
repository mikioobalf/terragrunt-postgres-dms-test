# Sample configuration to copy a PostgreSQL database

This directory contains example files to copy a PostgreSQL database from [account1](../../account1.hcl) to [account2](../../account2.hcl) using the [dms_cross_account_replication module](../../modules/dms_cross_acount_replication/) with Teragrunt.

For the details about the module, please read the [README](../../modules/dms_cross_acount_replication/README.md) file.

The databases might need specific configuration to use DMS. Please check the following AWS documentation:

- [Using a PostgreSQL database as an AWS DMS source](https://docs.aws.amazon.com/dms/latest/userguide/CHAP_Source.PostgreSQL.html)

