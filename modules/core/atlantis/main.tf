#======================= Infrastructure for Atlantis ===========================#
locals {
  storage_bucket = "${var.storage_bucket_prefix}-${var.project}-${var.region}"
}
data "aws_route53_zone" "selected" {
  name         = var.route53_zone_name
  private_zone = false
}


module "atlantis" {
  source  = "terraform-aws-modules/atlantis/aws"
  version = "4.0.8"

  name = var.atlantis_name

  # ECS Container Definition
  atlantis = {
    image = "${aws_ecr_repository.atlantis.repository_url}:latest"
    environment = [
      {
        name  = var.vcs == "github" ? "ATLANTIS_GH_USER" : (var.vcs == "gitlab" ? "ATLANTIS_GITLAB_USER" : "ATLANTIS_BITBUCKET_USER")
        value = var.git_user
      },
      {
        name  = "ATLANTIS_REPO_ALLOWLIST"
        value = join(",", formatlist("%s/%s/%s", var.git_hostname, var.git_owner, var.repo_names))
      },
      {
        name  = "ATLANTIS_ENABLE_DIFF_MARKDOWN_FORMAT"
        value = "true"
      },
      {
        name : "ATLANTIS_REPO_CONFIG_JSON",
        value : jsonencode(yamldecode(file("${path.module}/repos.yaml")))
      },
      {
        name  = "CUSTODIAN_ROLE"
        value = var.c7n_user != "" ? "arn:aws:iam::${var.aws_account_id}:role/Read-Only-Access-For-Custodian-${var.region}" : ""
      },
      {
        name  = "STORAGE_BUCKET"
        value = local.storage_bucket
      },
      {
        name  = "VCS"
        value = var.vcs
      },
    ]
    secrets = [
      {
        name      = var.vcs == "github" ? "ATLANTIS_GH_WEBHOOK_SECRET" : (var.vcs == "gitlab" ? "ATLANTIS_GITLAB_WEBHOOK_SECRET" : "ATLANTIS_BITBUCKET_WEBHOOK_SECRET")
        valueFrom = aws_ssm_parameter.atlantis_webhook_secret.arn
      },
      {
        name      = var.vcs == "github" ? "ATLANTIS_GH_TOKEN" : (var.vcs == "gitlab" ? "ATLANTIS_GITLAB_TOKEN" : "ATLANTIS_BITBUCKET_TOKEN")
        valueFrom = aws_ssm_parameter.atlantis_git_token.arn
      },
    ]
  }

  # ECS Service
  service = {
    task_exec_ssm_param_arns = [
      "arn:aws:ssm:${var.region}:${var.aws_account_id}:parameter/*",
      aws_ssm_parameter.atlantis_webhook_secret.arn,
      aws_ssm_parameter.atlantis_git_token.arn
    ]
    # Provide Atlantis permission necessary to create/destroy resources
    tasks_iam_role_policies = {
      AdministratorAccess = "arn:aws:iam::aws:policy/AdministratorAccess"
    }
    tasks_iam_role_name                = "${var.atlantis_name}-ecs-task-role"
    tasks_iam_role_use_name_prefix     = false
    task_exec_iam_role_name            = "${var.atlantis_name}-task-execution-role"
    task_exec_iam_role_use_name_prefix = false
    security_group_name                = "${var.atlantis_name}-ecs-SG"
    security_group_use_name_prefix     = false
    security_group_rules = {
      ingress = {
        type                     = "ingress"
        from_port                = 443
        to_port                  = 443
        protocol                 = "tcp"
        source_security_group_id = var.vpc_nat_security_group
      }
      egress = {
        type        = "egress"
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
      }
    }
  }
  service_subnets = var.private_subnet_ids
  vpc_id          = var.vpc_id

  # ALB
  alb = {
    enable_deletion_protection     = false
    create_security_group          = true
    security_group_name            = "${var.atlantis_name}-created-by-module"
    security_group_use_name_prefix = false
    security_groups = [
      module.security_group_http.security_group_id,
      module.security_group_alowed.security_group_id,
      module.security_group_https.security_group_id
    ]

    security_group_ingress_rules = {}
    security_group_egress_rules = {
      all = {
        ip_protocol = "-1"
        cidr_ipv4   = var.cidr
      }
    }
  }

  alb_subnets        = var.public_subnet_ids
  create_certificate = false
  certificate_arn    = module.acm_certificate.aws_acm_certificate_arn
  #  certificate_domain_name = var.route53_zone_name
  route53_zone_id = data.aws_route53_zone.selected.id

  depends_on = [null_resource.image_create, module.acm_certificate]
}

resource "random_password" "webhook_secret" {
  length  = 32
  special = false
}

# If we use EPAM Syndicate Rule Engine we create this role with read only access
module "read_only_role" {
  count             = var.c7n_user != "" ? 1 : 0
  source            = "../c7n_epam"
  atlantis_role_arn = module.atlantis.service["tasks_iam_role_arn"]
  region            = var.region
  depends_on        = [module.atlantis]
}

module "acm_certificate" {
  source            = "../../acm_certificate"
  route53_zone_name = var.route53_zone_name
}
