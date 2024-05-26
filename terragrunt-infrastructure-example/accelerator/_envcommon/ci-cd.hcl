# ---------------------------------------------------------------------------------------------------------------------
# COMMON TERRAGRUNT CONFIGURATION
# This configuration will be merged into the environment configuration
# via an include block.
# ---------------------------------------------------------------------------------------------------------------------

# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder. If any environment
# needs to deploy a different module version, it should redefine this block with a different ref to override the
# deployed version.
terraform {
  source = "${local.base_source_url}"
  before_hook "validate_tflint" {
    commands = ["validate"]
    execute = [
      "sh", "-c", <<EOT
            echo "---------------- TFLint Report --------------"
            tflint -v || exit 0
            tflint --init --config "${get_repo_root()}/.tflint.hcl" || exit 0
            tflint --config "${get_repo_root()}/.tflint.hcl" || exit 0
          EOT
    ]
  }
  before_hook "checkov" {
    commands = ["plan"]
    execute = [
      "sh", "-c", <<EOT
            source $HOME/.venv/bin/activate || exit 0
            checkov -d . --quiet --framework terraform --skip-check CKV_TF_1 > /tmp/checkov_report.log || exit 0
            deactivate || exit 0
          EOT
    ]
  }
  after_hook "tfsec" {
    commands = ["plan"]
    execute = [
      "sh", "-c", <<EOT
            tfsec --no-colour --soft-fail -f json --concise-output --out /tmp/tfsec_report.log . || exit 0
          EOT
    ]
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# Locals are named constants that are reusable within the configuration.
# ---------------------------------------------------------------------------------------------------------------------
locals {

  # Expose the base source URL so different versions of the module can be deployed in different environments. This will
  # be used to construct the terraform block in the child terragrunt configurations.
  # base_source_url = "git::git@github.com:gruntwork-io/terragrunt-infrastructure-modules-example.git//mysql"
  base_source_url = "${get_path_to_repo_root()}//modules/accelerator/main-module/"

  env_vars   = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  dlt_create = local.env_vars.locals.dlt_create
}

dependency "vpc" {
  config_path = "${get_terragrunt_dir()}/../../../core/vpc"
  mock_outputs = {
    vpc_id                 = "temporary-dummy-id"
    public_subnets         = ["subnet-dummy-1", "subnet-dummy-2", "subnet-dummy-3"]
    private_subnets        = ["subnet-dummy-1", "subnet-dummy-2", "subnet-dummy-3"]
    vpc_nat_security_group = "sg-dummy-1"
    vpc_cidr_block         = "10.0.0.0/16"
  }
  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan"]
}
dependency "dlt" {
  config_path = "${get_terragrunt_dir()}/../../../core/dlt"
  mock_outputs = {
    console                  = "temprory-dummy-url"
    api                      = "temprory-dummy-api"
    cognito_client_id        = "temprory-dummy-client-id"
    cognito_identity_pool_id = "temprory-dummy-cognito_identity_pool_id"
    cognito_user_pool_id     = "temprory-dummy-cognito_user_pool_id"
    dlt_fqdn                 = "temprory-dummy-dlt_fqdn"
  }
  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan"]

  skip_outputs = local.dlt_create ? false : true
}

inputs = {
  #========================= VPC Block ==================================#
  vpc_id = dependency.vpc.outputs.vpc_id
  security_groups = [
    dependency.vpc.outputs.vpc_nat_security_group
  ]

  private_subnet_ids = dependency.vpc.outputs.private_subnets
  public_subnet_ids  = dependency.vpc.outputs.public_subnets
  vpc_range          = dependency.vpc.outputs.vpc_cidr_block
  #============================ DLT ======================================#
  dlt_ui_url               = local.dlt_create ? dependency.dlt.outputs.console : null
  dlt_api_host             = local.dlt_create ? dependency.dlt.outputs : null
  cognito_client_id        = local.dlt_create ? dependency.dlt.outputs.cognito_client_id : null
  cognito_identity_pool_id = local.dlt_create ? dependency.dlt.outputs.cognito_identity_pool_id : null
  cognito_user_pool_id     = local.dlt_create ? dependency.dlt.outputs.cognito_user_pool_id : null
  dlt_fqdn                 = local.dlt_create ? dependency.dlt.outputs.dlt_fqdn : null
}
