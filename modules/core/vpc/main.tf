#======================= Module for VPC ===========================#
##====================== Terraform module for VPS https://github.com/terraform-aws-modules/terraform-aws-vpc ==========================##
data "aws_availability_zones" "available" {}

locals {
  azs = slice(data.aws_availability_zones.available.names, 0, 3)

}
module "vpc" {
  source                 = "terraform-aws-modules/vpc/aws"
  version                = "5.4.0"
  name                   = var.project
  cidr                   = var.cidr
  azs                    = local.azs
  public_subnets         = [for k, v in local.azs : cidrsubnet(var.cidr, 8, k)]
  private_subnets        = [for k, v in local.azs : cidrsubnet(var.cidr, 8, k + 4)]
  database_subnets       = [for k, v in local.azs : cidrsubnet(var.cidr, 8, k + 8)]
  enable_nat_gateway     = var.enable_nat_gateway
  single_nat_gateway     = var.single_nat_gateway
  one_nat_gateway_per_az = var.one_nat_gateway_per_az
  reuse_nat_ips          = var.reuse_nat_ips       # <= Skip creation of EIPs for the NAT Gateways
  external_nat_ip_ids    = var.external_nat_ip_ids # <= IPs specified here as input to the module
  external_nat_ips       = var.external_nat_ips

  create_database_subnet_group  = false
  manage_default_network_acl    = false
  manage_default_route_table    = false
  manage_default_security_group = false

  ##====================== VPC Flow Logs (Cloudwatch log group and IAM role will be created) ==========================##
  enable_flow_log                      = true
  create_flow_log_cloudwatch_log_group = true
  create_flow_log_cloudwatch_iam_role  = true
  flow_log_max_aggregation_interval    = 60

}

module "security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.1.0"

  name                    = "VPC-NAT-${var.project}-SG"
  use_name_prefix         = false
  description             = "VPC security group for HTTP and HTTPS access from NAT"
  vpc_id                  = module.vpc.vpc_id
  ingress_cidr_blocks     = length(var.nat_prefix_list_ids) == 0 ? formatlist("%s/32", module.vpc.nat_public_ips) : []
  ingress_prefix_list_ids = var.nat_prefix_list_ids
  ingress_with_cidr_blocks = [
    {
      from_port = 80
      to_port   = 80
      protocol  = "tcp"
    },
    {
      from_port = 443
      to_port   = 443
      protocol  = "tcp"
    },
  ]
  egress_cidr_blocks = var.egress_cidr_blocks
  egress_rules       = ["all-all"]

  #  ingress_with_self = [
  #    {
  #      rule = "all-all"
  #    }
  #  ]
  tags = {
    Name = "VPC-NAT-${var.project}-SG"
  }
}
