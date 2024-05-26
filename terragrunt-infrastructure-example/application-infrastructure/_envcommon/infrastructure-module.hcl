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
  base_source_url  = "${get_path_to_repo_root()}//modules//application-infrastructure/main-module/"
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  repo_name        = local.environment_vars.locals.repo_name
  stages           = local.environment_vars.locals.environments
  account_vars     = read_terragrunt_config(find_in_parent_folders("account.hcl"))
  account          = local.account_vars.locals.aws_account_id
}

# ---------------------------------------------------------------------------------------------------------------------
# MODULE PARAMETERS
# These are the variables we have to pass in to use the module. This defines the parameters that are common across all
# environments.
# ---------------------------------------------------------------------------------------------------------------------
inputs = merge(
  {
    codedeploy_role_arns = [
      for stage in local.environment_vars.locals.environments :
      "arn:aws:iam::${local.account}:role/Codedeploy-${local.repo_name}-${stage}"
    ]
    codedeploy_role_names = [
      for stage in local.environment_vars.locals.environments : "Codedeploy-${local.repo_name}-${stage}"
    ]
    profile_role_names = [
      for stage in local.environment_vars.locals.environments : "EC2-Profile-Role-${local.repo_name}-${stage}"
    ]
  }
)
