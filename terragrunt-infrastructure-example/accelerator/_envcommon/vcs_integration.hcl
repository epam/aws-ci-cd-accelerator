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
  # Automatically load parameter-store-level variables
  parameter_vars    = read_terragrunt_config(find_in_parent_folders("parameter_store.hcl"))
  env_vars          = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  ai_handler_create = local.env_vars.locals.ai_handler_create
  # Expose the base source URL so different versions of the module can be deployed in different environments. This will
  # be used to construct the terraform block in the child terragrunt configurations.
  # base_source_url = "git::git@github.com:gruntwork-io/terragrunt-infrastructure-modules-example.git//mysql"
  base_source_url = "${get_path_to_repo_root()}/modules//core/atlantis_vcs_integration/${local.env_vars.locals.vcs}"
}

dependency "atlantis" {
  config_path = "${get_terragrunt_dir()}/../atlantis"
  mock_outputs = {
    atlantis_url_events = "atlantis-url"
    webhook_secret      = "123456789"
  }
  mock_outputs_allowed_terraform_commands = ["validate", "plan", "init", "destroy"]
}

dependency "ai_handler" {
  config_path = "${get_terragrunt_dir()}/../atlantis_ai_handler"
  mock_outputs = {
    function_url = ["function_url"]
  }
  mock_outputs_allowed_terraform_commands = ["validate", "plan", "init", "destroy", "apply"]

  skip_outputs = local.ai_handler_create ? false : true
}
# ---------------------------------------------------------------------------------------------------------------------
# MODULE PARAMETERS
# These are the variables we have to pass in to use the module. This defines the parameters that are common across all
# environments.
# ---------------------------------------------------------------------------------------------------------------------
inputs = merge(
  local.parameter_vars.locals,
  {
    atlantis_url_events     = dependency.atlantis.outputs.atlantis_url_events
    atlantis_webhook_secret = dependency.atlantis.outputs.webhook_secret
    function_url            = local.ai_handler_create ? dependency.ai_handler.outputs.function_url : ["function_url"]
  }
)
