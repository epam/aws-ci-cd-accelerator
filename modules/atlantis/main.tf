
locals {
  custom_environment_secrets = var.gitlab_user != "" ? var.custom_environment_secrets_gitlab : var.github_user != "" ? var.custom_environment_secrets_github : var.custom_environment_secrets_bitbucket
  atlantis_gitlab_hostname   = var.gitlab_user != "" ? var.atlantis_gitlab_hostname : ""
}

module "atlantis" {
  source  = "terraform-aws-modules/atlantis/aws"
  version = "3.28.0"

  atlantis_image = "${var.atlantis_ecr_repository}:latest"

  policies_arn = [
    "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy",
    var.tfstate_bucket_policy_arn,
    "arn:aws:iam::aws:policy/AdministratorAccess"
  ]

  name = var.atlantis_name

  # VPC
  vpc_id                       = var.vpc_id
  private_subnet_ids           = var.private_subnet_ids
  public_subnet_ids            = var.public_subnet_ids
  enable_ephemeral_storage     = true
  # Get GitHub subnets, fallback to VPC range as default value
  alb_ingress_cidr_blocks      = ["10.0.0.0/8"] #local.alb_ingress_cidr_blocks
  alb_ingress_ipv6_cidr_blocks = []

  security_group_ids = var.security_group_ids
  # DNS (without trailing dot)
  route53_zone_name  = var.route53_zone_name

  # ACM (SSL certificate) - Specify ARN of an existing certificate or new one will be created and validated using Route53 DNS
  certificate_arn = var.certificate_arn

  # Atlantis
  atlantis_repo_allowlist = var.repo_whitelist

  # GitHub integration
  atlantis_github_user                          = var.github_user
  atlantis_github_user_token                    = var.atlantis_github_user_token
  atlantis_github_user_token_ssm_parameter_name = var.atlantis_github_user_token_ssm_parameter_name
  # Gitlab integration
  atlantis_gitlab_user                          = var.gitlab_user
  atlantis_gitlab_user_token                    = var.atlantis_gitlab_user_token
  atlantis_gitlab_hostname                      = var.atlantis_gitlab_hostname
  atlantis_gitlab_user_token_ssm_parameter_name = var.atlantis_gitlab_user_token_ssm_parameter_name

  # Bitbucket integration
  atlantis_bitbucket_base_url   = var.atlantis_bitbucket_base_url
  atlantis_bitbucket_user       = var.bitbucket_user
  atlantis_bitbucket_user_token = var.atlantis_bitbucket_user_token

  # Additional environment variables
  custom_environment_secrets   = local.custom_environment_secrets
  custom_environment_variables = [
    {
      name : "ATLANTIS_REPO_CONFIG_JSON",
      value : jsonencode(yamldecode(file("${path.module}/repos.yaml")))
    }
  ]
  depends_on = [null_resource.image_create]
}

# If you use EPAM Cloud Custodian you need to create this role
module "read_only_role" {
  count             = var.c7n_user != "" ? 1 : 0
  source            = "../c7n_epam"
  atlantis_role_arn = module.atlantis.task_role_arn
  region            = var.region
  depends_on        = [module.atlantis]
}