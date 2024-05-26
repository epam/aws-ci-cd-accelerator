# Set account-wide variables. These are automatically pulled in to configure the remote state bucket in the root
# terragrunt.hcl configuration.
locals {
  account_name    = "accelerator" # Used as part of the names of some terraformed objects
  aws_account_id  = "" # AWS Account ID (TODO: replace it with your AWS account ID!)
  assume_role_arn = null # ARN of the role for assuming
}
