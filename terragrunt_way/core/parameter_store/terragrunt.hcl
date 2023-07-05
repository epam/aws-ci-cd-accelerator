terraform {
  source = "../../../modules//parameter-store/"
}

include "root" {
  path = find_in_parent_folders()
}

locals {
  parameter_vars = yamldecode(file(find_in_parent_folders("parameter_store.yml")))
}

inputs = merge(
  local.parameter_vars,
  {}
)