terraform {
  source = "../../../../modules//parameter-store-apps/"
}

include "root" {
  path = find_in_parent_folders()
}

locals {
  parameter_vars = yamldecode(file("parameter_store.yml"))
}

inputs = merge(
  local.parameter_vars,
  {}
)