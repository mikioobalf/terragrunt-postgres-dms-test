terraform {
  source = "tfr:///terraform-aws-modules/sns/aws?version=4.1.0"
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

inputs = {
  version = "~> 3.0"
  name  = "dms-test-sns-topic"

  tags = {
    Terraform = "true"
    Environment = "dev"
  }
}
