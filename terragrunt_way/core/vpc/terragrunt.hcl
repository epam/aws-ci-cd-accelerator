terraform {
  source = "../../../modules//vpc/"
}

include "root" {
  path = find_in_parent_folders()
}

locals {
  common_vars = yamldecode(file(find_in_parent_folders("common_vars.yml")))
}

inputs = merge(
  local.common_vars,
  {
    # additional inputs
  }
)
