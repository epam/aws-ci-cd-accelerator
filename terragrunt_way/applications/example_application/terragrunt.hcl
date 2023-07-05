terraform {
  source = "../../..//modules/accelerator/main-module/"
}

include "root" {
  path = find_in_parent_folders()
}

dependency "vpc" {
  config_path = "../../core/vpc"
}

locals {
  common_vars = yamldecode(file(find_in_parent_folders("common_vars.yml")))
  app_vars    = yamldecode(file("application_vars.yml"))

}

inputs = merge(
  local.common_vars,
  local.app_vars,
  {
    #================= DLT Block ======================================================#
    aws_acm_certificate_usa_arn = dependency.vpc.outputs.aws_acm_certificate_usa_arn

    #================= VPC Block ======================================================#
    vpc_id          = dependency.vpc.outputs.vpc_id
    security_groups = [
      dependency.vpc.outputs.application_https_sg_id, dependency.vpc.outputs.application_80_sg_id,
      dependency.vpc.outputs.application_sg_nat
    ]

    private_subnet_ids                 = dependency.vpc.outputs.private_subnet_ids
    public_subnet_ids                  = dependency.vpc.outputs.public_subnet_ids
    aws_acm_certificate_arn            = dependency.vpc.outputs.aws_acm_certificate_arn

    default_tags                       = {
      "Project" = local.common_vars.project
    }
  }
)
