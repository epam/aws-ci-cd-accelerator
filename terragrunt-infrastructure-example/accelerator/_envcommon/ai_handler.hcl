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
  #  source = "${local.base_source_url}?ref=v0.7.0"
  source = "${local.base_source_url}"
  after_hook "validate_tflint" {
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
}

# ---------------------------------------------------------------------------------------------------------------------
# Locals are named constants that are reusable within the configuration.
# ---------------------------------------------------------------------------------------------------------------------
locals {
  # Automatically load parameter-store-accelerator-account-level variables
  env_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  # Automatically load parameter-store-accelerator-account-level variables
  parameter_vars = read_terragrunt_config(find_in_parent_folders("app_parameter_store.hcl"))

  # Expose the base source URL so different versions of the module can be deployed in different environments. This will
  # be used to construct the terraform block in the child terragrunt configurations.
  # base_source_url = "git::git@github.com:gruntwork-io/terragrunt-infrastructure-modules-example.git//mysql"
  base_source_url = "${get_path_to_repo_root()}//modules//accelerator/ai_handler/"
}

# ---------------------------------------------------------------------------------------------------------------------
# MODULE PARAMETERS
# These are the variables we have to pass in to use the module. This defines the parameters that are common across all
# environments.
# ---------------------------------------------------------------------------------------------------------------------
inputs = merge(
  local.env_vars.locals,
  local.parameter_vars.locals,
  {}
)
