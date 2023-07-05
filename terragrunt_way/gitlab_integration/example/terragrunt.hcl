terraform {
  source = "../../../modules//gitlab_integration/"
  extra_arguments "app_vars" {
    commands = [
      "apply",
      "plan",
      "import",
      "push",
      "refresh",
      "destroy"
    ]

    arguments = [
      "-var-file=gitlab.tfvars",
    ]
  }
}

include "root" {
  path = find_in_parent_folders()
}

locals {
  common_vars = yamldecode(file(find_in_parent_folders("common_vars.yml")))
}

inputs = {
  # additional inputs
  region = local.common_vars.region
}
