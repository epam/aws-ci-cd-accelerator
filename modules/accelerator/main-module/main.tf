#================================== Combine all modules =============================#
module "buckets" {
  source               = "../../buckets_for_accelerator"
  region               = var.region
  project              = var.project
  aws_account_id       = var.aws_account_id
  repo_name            = var.repo_name
  force_destroy        = var.force_destroy
  versioning           = var.versioning
  target_type          = var.target_type
  region_name          = var.region_name
  artifact_bucket_name = var.artifact_bucket_name
  storage_bucket_name  = var.storage_bucket_name
  expiration_days      = var.expiration_days
}

module "aws_policies" {
  source                    = "../iam-policies"
  aws_account_id            = var.aws_account_id
  region                    = var.region
  region_name               = var.region_name
  private_subnet_ids        = var.private_subnet_ids
  project                   = var.project
  repo_name                 = var.repo_name
  storage_bucket_arn        = module.buckets.storage_bucket_arn
  build_artifact_bucket_arn = module.buckets.artifact_bucket_arn
  aws_kms_key               = module.buckets.aws_kms_key
  aws_kms_key_arn           = module.buckets.aws_kms_key_arn
  eks_role_arn              = var.eks_role_arn
  target_type               = var.target_type
  connection_provider       = var.connection_provider
  vpc_id                    = var.vpc_id
  depends_on                = [module.buckets]

}

module "dlt" {
  source                  = "../../distributed_load_testing"
  admin_email             = var.email_addresses[0]
  admin_name              = var.admin_name
  private_subnet_ids      = var.private_subnet_ids
  private_subnets         = var.private_subnets
  vpc_id                  = var.vpc_id
  vpc_cidr_block          = var.vpc_range
  storage_bucket          = module.buckets.storage_bucket
  region                  = var.region
  repo_name               = var.repo_name
  aws_acm_certificate_arn = var.aws_acm_certificate_usa_arn
  route53_zone_name       = var.route53_zone_name
  region_name             = var.region_name
  depends_on              = [module.buckets]
}

module "alb" {
  count                   = var.target_type == "eks" || var.target_type == "kube_cluster" ? 0 : 1
  source                  = "../alb_deploy"
  environments            = var.environments
  repo_name               = var.repo_name
  health_path             = var.health_path
  project                 = var.project
  route53_zone_name       = var.route53_zone_name
  vpc_id                  = var.vpc_id
  security_groups         = var.security_groups
  public_subnet_ids       = var.public_subnet_ids
  target_type             = var.target_type
  aws_acm_certificate_arn = var.aws_acm_certificate_arn
  region_name             = var.region_name
  target_port             = var.application_port
}

module "asg" {
  count                = var.target_type == "instance" ? 1 : 0
  source               = "../autoscaling_groups"
  repo_name            = var.repo_name
  elb_target_group_arn = module.alb[0].target_group_arn
  lb_id                = module.alb[0].alb_id
  security_groups      = var.security_groups
  private_subnet_ids   = var.private_subnet_ids
  instance_type        = var.instance_type
  region_name          = var.region_name
  desired_capacity     = var.desired_capacity
  max_size             = var.max_size
  min_size             = var.min_size
  environments         = var.environments
  artifact_bucket      = module.buckets.artifact_bucket
  aws_kms_key_arn      = module.buckets.aws_kms_key_arn
  region               = var.region
  project              = var.project
  depends_on           = [module.alb[0]]
}

module "ecs" {
  count                 = var.target_type == "ip" ? 1 : 0
  source                = "../ecs"
  region                = var.region
  region_name           = var.region_name
  repo_name             = var.repo_name
  vpc_id                = var.vpc_id
  security_groups       = var.security_groups
  private_subnet_ids    = var.private_subnet_ids
  cpu                   = var.cpu
  desired_capacity      = var.desired_capacity
  docker_container_port = var.application_port
  environments          = var.environments
  memory                = var.memory
  target_group_blue_arn = module.alb[0].target_group_blue_arn
  aws_account_id        = var.aws_account_id
  connection_provider   = var.connection_provider
  organization_name     = var.organization_name
  package_buildspec     = var.docker_buildspec
  repo_default_branch   = var.repo_default_branch
  storage_bucket        = module.buckets.storage_bucket
  codeartifact_domain   = var.codeartifact_create == true ? module.aws_codeartifact[0].codeartifact_domain : ""
  codeartifact_repo     = var.codeartifact_create == true ? module.aws_codeartifact[0].codeartifact_repo : ""
  aws_kms_key           = module.buckets.aws_kms_key
  aws_kms_key_arn       = module.buckets.aws_kms_key_arn
  execution_role        = module.aws_policies.ecs_execution_role
  task_role             = module.aws_policies.ecs_task_role # ADD if we need to access to aws resources
  depends_on            = [module.aws_policies, module.buckets]
}

module "pipeline" {
  source                      = "../aws-codepipeline"
  repo_name                   = var.repo_name
  organization_name           = var.organization_name
  project_key                 = var.project_key
  sonar_url                   = var.sonar_url
  aws_account_id              = var.aws_account_id
  region                      = var.region
  vpc_id                      = var.vpc_id
  security_groups             = var.security_groups
  connection_provider         = var.connection_provider
  source_provider             = var.source_provider
  environments                = var.environments
  region_name                 = var.region_name
  asg_name                    = var.target_type == "instance" ? module.asg[0].asg_name : null
  app_fqdn                    = var.target_type == "eks" || var.target_type == "kube_cluster" ? var.app_fqdn : module.alb[0].app_fqdn
  sonarcloud_token_name       = var.sonarcloud_token_name
  template_name               = var.target_type == "instance" ? module.asg[0].template_name : null
  private_subnet_ids          = var.private_subnet_ids
  desired_capacity            = var.desired_capacity
  target_group_name           = var.target_type == "instance" ? module.alb[0].target_group_name : null
  approve_sns_arn             = module.sns.approve_sns_arn
  storage_bucket              = module.buckets.storage_bucket
  target_type                 = var.target_type
  image_repo_name             = var.target_type == "instance" ? "" : "${var.repo_name}-${var.region_name}"
  package_buildspec           = var.target_type == "instance" ? var.package_buildspec : var.docker_buildspec
  main_listener               = var.target_type == "eks" || var.target_type == "kube_cluster" ? null : module.alb[0].main_listener
  target_group_green_name     = var.target_type == "ip" ? module.alb[0].target_group_green_name : null
  target_group_blue_name      = var.target_type == "ip" ? module.alb[0].target_group_blue_name : null
  aws_kms_key                 = module.buckets.aws_kms_key
  aws_kms_key_arn             = module.buckets.aws_kms_key_arn
  build_artifact_bucket       = module.buckets.artifact_bucket
  codebuild_role              = module.aws_policies.codebuild_role_arn
  codepipeline_role           = module.aws_policies.codepipeline_role_arn
  codedeploy_role             = var.target_type == "ip" || var.target_type == "instance" ? module.aws_policies.codedeploy_role_arn : null
  repo_default_branch         = var.repo_default_branch
  build_timeout               = var.build_timeout
  build_compute_type          = var.build_compute_type
  build_image                 = var.build_image
  build_privileged_override   = var.build_privileged_override
  test_buildspec              = var.test_buildspec
  test_func_buildspec         = var.test_func_buildspec
  test_perf_buildspec         = var.test_perf_buildspec
  conf_all_at_once            = var.conf_all_at_once
  conf_one_at_time            = var.conf_one_at_time
  ecs_cluster_name            = var.target_type == "ip" ? module.ecs[0].cluster_name : ""
  ecs_service_name            = var.target_type == "ip" ? module.ecs[0].service_name : []
  #=============== AWS Codeartifact for JAVA Application ===========================
  codeartifact_domain         = var.codeartifact_create == true ? module.aws_codeartifact[0].codeartifact_domain : ""
  codeartifact_repo           = var.codeartifact_create == true ? module.aws_codeartifact[0].codeartifact_repo : ""
  #====================== DLT Test Block ============================================
  cognito_password_name       = var.cognito_password_name
  admin_name                  = var.admin_name
  dlt_ui_url                  = module.dlt.console
  dlt_api_host                = module.dlt.api
  cognito_client_id           = module.dlt.cognito_client_id
  cognito_identity_pool_id    = module.dlt.cognito_identity_pool_id
  cognito_user_pool_id        = module.dlt.cognito_user_pool_id
  route53_zone_name           = var.route53_zone_name
  #========================== Report Portal ===========================================
  rp_endpoint                 = var.rp_endpoint
  rp_token_name               = var.rp_token_name
  rp_project                  = var.rp_project
  #============================== EKS ==================================================
  buildspec_eks               = var.target_type == "eks" || var.target_type == "kube_cluster" ? var.buildspec_eks : null
  cluster_name                = var.target_type == "eks" || var.target_type == "kube_cluster" ? var.cluster_name : null
  aws_acm_certificate_arn     = var.aws_acm_certificate_arn
  health_path                 = var.health_path
  public_subnet_ids           = var.target_type == "eks" || var.target_type == "kube_cluster" ? var.public_subnet_ids : null
  target_port                 = var.application_port
  eks_role_arn                = var.target_type == "eks" || var.target_type == "kube_cluster" ? var.eks_role_arn : null
  cluster_acm_certificate_arn = var.target_type == "eks" || var.target_type == "kube_cluster" ? var.cluster_acm_certificate_arn : null
  cluster_public_subnet_ids   = var.target_type == "eks" || var.target_type == "kube_cluster" ? var.cluster_public_subnet_ids : null
  cluster_region              = var.target_type == "eks" || var.target_type == "kube_cluster" ? var.cluster_region : null
  cluster_security_groups     = var.target_type == "eks" || var.target_type == "kube_cluster" ? var.cluster_security_groups : null
  #=============== Stand alone cluster ======================
  cluster_config              = var.target_type == "eks" || var.target_type == "kube_cluster" ? var.cluster_config : null
  docker_password             = var.target_type == "eks" || var.target_type == "kube_cluster" ? var.docker_password : null
  docker_repo                 = var.target_type == "eks" || var.target_type == "kube_cluster" ? var.docker_repo : null
  docker_user                 = var.target_type == "eks" || var.target_type == "kube_cluster" ? var.docker_user : null
  helm_chart                  = var.target_type == "eks" || var.target_type == "kube_cluster" ? var.helm_chart : null
  helm_chart_version          = var.target_type == "eks" || var.target_type == "kube_cluster" ? var.helm_chart_version : null
}

module "sns" {
  source             = "../notifications"
  codepipeline_arn   = module.pipeline.codepipeline_arn
  repo_name          = var.repo_name
  build_success      = var.build_success
  teams_web_hook     = var.teams_web_hook
  slack_web_hook     = var.slack_web_hook
  display_name       = var.display_name
  email_addresses    = var.email_addresses
  region_name        = var.region_name
  codepipeline_name  = module.pipeline.codepipeline_name
  aws_kms_key        = module.buckets.aws_kms_key
  security_groups    = var.security_groups
  private_subnet_ids = var.private_subnet_ids
}

module "pr" {
  count                 = var.connection_provider == "GitHub" ? 1 : (var.connection_provider == "Bitbucket" ? 1 : 0)
  source                = "../../../modules/PR-analysis"
  aws_account_id        = var.aws_account_id
  auth_token            = var.auth_token
  repo_name             = var.repo_name
  build_timeout         = "20"
  service_role          = module.aws_policies.codebuild_role_arn
  connection_provider   = var.connection_provider
  location              = "https://github.com/${var.organization_name}/${var.repo_name}"
  webhook_pattern       = "PULL_REQUEST_REOPENED, PULL_REQUEST_CREATED, PULL_REQUEST_UPDATED"
  region                = var.region
  organization_name     = var.organization_name
  project               = var.project
  sonarcloud_token_name = var.sonarcloud_token_name
  region_name           = var.region_name
  aws_kms_key           = module.buckets.aws_kms_key_arn
}

module "pr_CodeCommit" {
  count                 = var.connection_provider == "CodeCommit" ? 1 : 0
  source                = "../../../modules/PR-analysis-CodeCommit"
  service_role          = module.aws_policies.codebuild_role_arn
  repo_name             = var.repo_name
  aws_account_id        = var.aws_account_id
  region                = var.region
  organization_name     = var.organization_name
  project               = var.project
  sonarcloud_token_name = var.sonarcloud_token_name
  depends_on            = [module.aws_policies]
}

module "aws_codeartifact" {
  count              = var.codeartifact_create == true ? 1 : 0
  source             = "../../aws_codeartifact"
  codebuild_role_arn = module.aws_policies.codebuild_role_arn
  region_name        = var.region_name
  repo_name          = var.repo_name
}