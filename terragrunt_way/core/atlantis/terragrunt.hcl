terraform {
  source = "../../../modules//atlantis/"
}

include "root" {
  path = find_in_parent_folders()
}
dependencies {
  # If we use run-all command
  paths = ["../vpc", "../parameter_store"]
}
locals {
  common_vars    = yamldecode(file(find_in_parent_folders("common_vars.yml")))
  parameter_vars = yamldecode(file(find_in_parent_folders("parameter_store.yml")))
}

dependency "vpc" {
  config_path = "../vpc"
}

inputs = merge(
  local.common_vars,
  local.parameter_vars,
  {
    security_group_ids        = [dependency.vpc.outputs.atlantis_sg_id, dependency.vpc.outputs.application_https_sg_id]
    vpc_id                    = dependency.vpc.outputs.vpc_id
    atlantis_ecr_repository   = dependency.vpc.outputs.atlantis_ecr_repository
    aws_acm_certificate_arn   = dependency.vpc.outputs.aws_acm_certificate_arn
    private_subnet_ids        = dependency.vpc.outputs.private_subnet_ids
    public_subnet_ids         = dependency.vpc.outputs.public_subnet_ids
    tfstate_bucket_policy_arn = dependency.vpc.outputs.tfstate_bucket_policy_arn

    #Custom environment variables for AWS Fargate task
    custom_environment_secrets_gitlab = [
      {
        "name" : "GITLAB_TOKEN",
        "valueFrom" : "/atlantis/gitlab/user/token"
      }
    ]
    custom_environment_secrets_github = [
      {
        "name" : "GITHUB_TOKEN",
        "valueFrom" : "/atlantis/github/user/token"
      }
    ]
    custom_environment_secrets_bitbucket = [
      {
        "name" : "BITBUCKET_TOKEN",
        "valueFrom" : "/atlantis/bitbucket/user/token"
      }
    ]
  }
)
