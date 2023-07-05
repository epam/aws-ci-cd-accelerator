terraform {
  source = "../../../modules//vcs_integration/${local.parameter_vars.vcs}"
}

include "root" {
  path = find_in_parent_folders()
}
dependency "atlantis" {
  config_path = "../atlantis"
}

locals {
  parameter_vars = yamldecode(file(find_in_parent_folders("parameter_store.yml")))
}

inputs = merge(
  local.parameter_vars,
  {
    atlantis_url_events     = dependency.atlantis.outputs.atlantis_url_events
    atlantis_webhook_secret = dependency.atlantis.outputs.webhook_secret
  }
)