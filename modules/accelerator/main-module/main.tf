#======================= Consolidation of all infrastructure code modules =======================#
##====================== These modules create a CodePipeline with CodeBuilds and instruments for application testing ======================##
locals {
  service_bucket     = "${var.service_bucket_prefix}-${var.repo_name}-${var.region}"
  service_bucket_arn = "arn:aws:s3:::${local.service_bucket}"
}
module "buckets" {

  source                      = "../accelerator_storages"
  region                      = var.region
  aws_account_id              = var.aws_account_id
  repo_name                   = var.repo_name
  force_destroy               = var.force_destroy
  target_type                 = var.target_type
  key_service_users           = var.key_service_users
  account_identifiers         = var.account_identifiers
  image_tag_mutability        = var.image_tag_mutability
  kms_identifiers             = var.kms_identifiers
  artifact_bucket_identifiers = var.artifact_bucket_identifiers
  artifact_bucket_prefix      = var.artifact_bucket_prefix
  service_bucket_prefix       = var.service_bucket_prefix
  application_port            = var.application_port
  container_name              = var.container_name
  cpu                         = var.cpu
  memory                      = var.memory
  stages                      = var.stages
  env_vars                    = var.env_vars
  secrets                     = var.secrets
}

module "aws_policies" {
  source                 = "../iam-policies"
  aws_account_id         = var.aws_account_id
  region                 = var.region
  region_name            = var.region_name
  private_subnet_ids     = var.private_subnet_ids
  project                = var.project
  repo_name              = var.repo_name
  service_bucket_arn     = local.service_bucket_arn
  eks_role_arn           = var.eks_role_arn
  target_type            = var.target_type
  codedeploy_role_arns   = var.codedeploy_role_arns
  artifact_bucket_prefix = var.artifact_bucket_prefix
  stages                 = var.stages
  depends_on             = [module.buckets]
}

module "synthetics" {
  source          = "../synthetics"
  count           = var.synthetics_create ? 1 : 0
  repo_name       = var.repo_name
  aws_kms_key_arn = module.buckets.aws_kms_key_arn
  security_groups = var.security_groups
  subnet_ids      = var.private_subnet_ids
}

module "pipeline" {
  source                      = "../aws-codepipeline"
  repo_name                   = var.repo_name
  git_owner                   = var.git_owner
  organization_name           = var.organization_name
  project_key                 = var.project_key
  sonar_url                   = var.sonar_url
  aws_account_id              = var.aws_account_id
  region                      = var.region
  vpc_id                      = var.vpc_id
  security_groups             = var.security_groups
  connection_provider         = var.connection_provider
  provider_endpoint           = var.provider_endpoint
  codestarconnection_host_arn = var.codestarconnection_host_arn
  environments                = var.environments
  stage_regions               = var.stage_regions
  region_name                 = var.region_name
  app_fqdn                    = var.app_fqdn
  sonarcloud_token_name       = var.sonarcloud_token_name
  private_subnet_ids          = var.private_subnet_ids
  approve_sns_arn             = module.sns.approve_sns_arn
  service_bucket              = local.service_bucket
  target_type                 = var.target_type
  buildspec_package           = var.target_type == "instance" ? var.buildspec_package : var.buildspec_docker
  aws_kms_key                 = module.buckets.aws_kms_key
  aws_kms_key_arn             = module.buckets.aws_kms_key_arn
  codebuild_role              = module.aws_policies.codebuild_role_arn
  codepipeline_role           = module.aws_policies.codepipeline_role_arn
  codedeploy_role_arns        = var.target_type == "ip" || var.target_type == "instance" ? var.codedeploy_role_arns : null
  repo_default_branch         = var.repo_default_branch
  build_timeout               = var.build_timeout
  build_compute_type          = var.build_compute_type
  build_image                 = var.build_image
  buildspec_sonar             = var.buildspec_sonar
  buildspec_selenium          = var.buildspec_selenium
  selenium_create             = var.selenium_create
  #=============== AWS Codeartifact for JAVA Application ===========================
  codeartifact_domain = var.codeartifact_create == true ? module.aws_codeartifact[0].codeartifact_domain : ""
  codeartifact_repo   = var.codeartifact_create == true ? module.aws_codeartifact[0].codeartifact_repo : ""
  #====================== DLT Test Block ============================================
  dlt_create               = var.dlt_create
  buildspec_dlt            = var.buildspec_dlt
  cognito_password_name    = var.cognito_password_name
  admin_name               = var.admin_name
  dlt_ui_url               = var.dlt_ui_url
  dlt_fqdn                 = var.dlt_fqdn
  dlt_api_host             = var.dlt_api_host
  cognito_client_id        = var.cognito_client_id
  cognito_identity_pool_id = var.cognito_identity_pool_id
  cognito_user_pool_id     = var.cognito_user_pool_id
  concurrency              = var.concurrency
  dlt_task_count           = var.dlt_task_count
  dlt_test_id              = var.dlt_test_id
  dlt_test_name            = var.dlt_test_name
  dlt_test_type            = var.dlt_test_type
  hold_for                 = var.hold_for
  ramp_up                  = var.ramp_up
  #========================== Report Portal ===========================================
  report_portal_environments = var.report_portal_environments
  #============================== EKS ==================================================
  buildspec_eks  = var.target_type == "eks" || var.target_type == "kube_cluster" ? var.buildspec_eks : ""
  cluster_name   = var.target_type == "eks" || var.target_type == "kube_cluster" ? var.eks_cluster_name : ""
  eks_role_arn   = var.target_type == "eks" ? var.eks_role_arn : ""
  cluster_region = var.target_type == "eks" ? var.cluster_region : ""

  #========================= Stand alone cluster =======================================
  cluster_config     = var.target_type == "kube_cluster" ? var.cluster_config : ""
  docker_password    = var.target_type == "kube_cluster" ? var.docker_password : ""
  docker_repo        = var.target_type == "kube_cluster" ? var.docker_repo : ""
  docker_user        = var.target_type == "kube_cluster" ? var.docker_user : ""
  helm_chart         = var.target_type == "eks" || var.target_type == "kube_cluster" ? var.helm_chart : ""
  helm_chart_version = var.target_type == "eks" || var.target_type == "kube_cluster" ? var.helm_chart_version : ""
  #============================ AWS CodDeploy =========================================
  application_name       = var.application_name
  deployment_group_names = var.deployment_group_names
  artifact_bucket_prefix = var.artifact_bucket_prefix
  #=============================== ECR ================================================
  tryvi_severity = var.tryvi_severity
  ecr_repo_name  = var.target_type != "instance" ? module.buckets.ecr_repo_name : ""
  #=================================== Carrier ========================================
  carrier_create     = var.carrier_create
  carrier_token_name = var.carrier_token_name
  buildspec_carrier  = var.buildspec_carrier
  carrier_project_id = var.carrier_project_id
  carrier_test_id    = var.carrier_test_id
  carrier_url        = var.carrier_url
  #==================================== Synthetics ====================================
  statemachine_arn  = var.synthetics_create ? module.synthetics[0].statemachine_arn : ""
  synthetics_create = var.synthetics_create
  buildspec_unit    = var.buildspec_unit
}

module "sns" {
  source             = "../notifications"
  repo_name          = var.repo_name
  build_success      = var.build_success
  display_name       = var.display_name
  email_addresses    = var.email_addresses
  region_name        = var.region_name
  codepipeline_name  = module.pipeline.codepipeline_name
  aws_kms_key        = module.buckets.aws_kms_key
  security_groups    = var.security_groups
  private_subnet_ids = var.private_subnet_ids
}

module "pr" {
  count                      = contains(["GitHub", "GitHubEnterpriseServer", "Bitbucket"], var.connection_provider) ? 1 : 0
  source                     = "../PR-analysis"
  aws_account_id             = var.aws_account_id
  repo_name                  = var.repo_name
  git_owner                  = var.git_owner
  build_timeout              = "20"
  service_role               = module.aws_policies.codebuild_role_arn
  connection_provider        = var.connection_provider
  organization_name          = var.organization_name
  project_key                = var.project_key
  sonarcloud_token_name      = var.sonarcloud_token_name
  aws_kms_key_arn            = module.buckets.aws_kms_key_arn
  build_compute_type         = var.build_compute_type
  build_image                = var.build_image
  private_subnet_ids         = var.private_subnet_ids
  report_portal_environments = var.report_portal_environments
  security_groups            = var.security_groups
  sonar_url                  = var.sonar_url
  vpc_id                     = var.vpc_id
  bitbucket_user             = var.bitbucket_user
  llm_model                  = var.llm_model
  openai_api_endpoint        = var.openai_api_endpoint
  openai_token_name          = var.openai_token_name
}

module "pr_codecommit" {
  count                 = var.connection_provider == "CodeCommit" ? 1 : 0
  source                = "../PR-analysis-CodeCommit"
  service_role          = module.aws_policies.codebuild_role_arn
  repo_name             = var.repo_name
  aws_account_id        = var.aws_account_id
  region                = var.region
  organization_name     = var.organization_name
  project               = var.project
  sonarcloud_token_name = var.sonarcloud_token_name
  build_image           = var.build_image
  depends_on            = [module.aws_policies]
}

module "aws_codeartifact" {
  count              = var.codeartifact_create ? 1 : 0
  source             = "../aws_codeartifact"
  codebuild_role_arn = module.aws_policies.codebuild_role_arn
  repo_name          = var.repo_name
  project            = var.project
}
