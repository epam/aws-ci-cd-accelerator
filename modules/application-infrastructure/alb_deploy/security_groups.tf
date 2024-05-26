#======================= SG for an application =======================#
module "security_group_https" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.1.0"

  name                    = "${var.project}-${var.repo_name}-application-https"
  use_name_prefix         = false
  description             = "Application security group for HTTPS access"
  vpc_id                  = var.vpc_id
  ingress_cidr_blocks     = var.allowed_cidr_blocks
  ingress_prefix_list_ids = var.allowed_prefix_list_ids

  ingress_with_prefix_list_ids = [
    {
      from_port = 443
      to_port   = 443
      protocol  = "tcp"
    }
  ]
  egress_cidr_blocks = var.egress_cidr_blocks
  egress_rules       = ["all-tcp"]
  tags = {
    Name = "${var.project}-${var.repo_name}-application-https"
  }
}
module "security_group_http" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.1.0"

  name                    = "${var.project}-${var.repo_name}-application-http"
  use_name_prefix         = false
  description             = "Application security group for HTTP access"
  vpc_id                  = var.vpc_id
  ingress_cidr_blocks     = var.allowed_cidr_blocks
  ingress_prefix_list_ids = var.allowed_prefix_list_ids
  ingress_with_prefix_list_ids = [
    {
      from_port = 80
      to_port   = 80
      protocol  = "tcp"
    }
  ]
  egress_cidr_blocks = var.egress_cidr_blocks
  egress_rules       = ["http-80-tcp"]
  tags = {
    Name = "${var.project}-${var.repo_name}-application-http"
  }
}
module "security_group_self_port" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.1.0"

  name            = "${var.project}-${var.repo_name}-application-${var.target_port}"
  use_name_prefix = false
  description     = "Application security group for ${var.target_port} access"
  vpc_id          = var.vpc_id
  ingress_with_self = [
    {
      from_port   = var.target_port
      to_port     = var.target_port
      protocol    = "tcp"
      description = "Service Port"
      self        = true
    }
  ]
  egress_with_self = [
    {
      from_port   = var.target_port
      to_port     = var.target_port
      protocol    = "tcp"
      description = "Service Port"
      self        = true
    }
  ]
  tags = {
    Name = "${var.project}-${var.repo_name}-application-${var.target_port}"
  }
}
