# Set common variables for the environment. This is automatically pulled in in the root terragrunt.hcl configuration to
# feed forward to the child modules.
locals {
 ##=========================== Accounts and variables for stages ===========================##
  stages = {
    dev = { account = "", regions = [], region_names = [] }
    qa  = { account = "", regions = [], region_names = [] }
    uat = { account = "", regions = [], region_names = [] }
  }
  # Non-sensitive environment variables (For ECS deployment only)
  env_vars = {
    dev = []
    qa  = []
    uat = []
  }
  # Sensitive environment variables (For ECS deployment only. Will be stored like ParameterStore Parameters, or SecretsManager Secrets)
  secrets = {
    dev = []
    qa  = []
    uat = []
  }
  ##=========================== Application Pipeline block ===========================##
  repo_name           = "${repo_name}" # Git Repository Name
  git_owner           = "" # GitHub owner/personal, Bitbucket
  connection_provider = "" # Bitbucket, GitHub or GitHubEnterpriseServer, GitLab or GitLabSelfManaged. Leave "" for CodeCommit
  provider_endpoint   = "" # GitHubEnterpriseServer or GitLabSelfManaged URL
  repo_default_branch = "" # Git Branch AWS CodePipeline works with
  email_addresses     = [] # E-mails for Notification
  target_type         = "instance" # "ip", "instance", "eks" or "kube_cluster"
  app_fqdn            = [] # FQDN for application endpoints to be tested

  ##=========================== Sonar block ===========================##
  sonar_url             = "https://sonarcloud.io" # The URL for Sonar endpoint
  sonarcloud_token_name = "/$${local.repo_name}/sonar/token" # The token for Sonar
  project_key           = "" # The Sonar unique identifier for your project
  organization_name     = "" # The Name for the Sonar organization

  ##=========================== AI handler block ===========================##
  ai_handler_create     = false # AI handler creation switch
  llm_model             = "text-davinci-003" # The LLM model for AI handler
  openai_api_endpoint   = "https://api.openai.com/v1/completions" # The API endpoint
  openai_token_name     = "/accelerator/openai_token" # The API token for AI

  ##=========================== Selenium Test Stage block  ===========================##
  selenium_create       = false # Selenium Test Stage creation switch

  ##=========================== Synthetics Test Stage block ===========================##
  synthetics_create     = false # Synthetics Test Stage creation switch

  ##=========================== Artifact Bucket block ===========================##
  force_destroy         = true #  Delete bucket when destroy: true or false

  ##=========================== Notifications block ===========================##
  build_success = false # If true, you will also get notifications about successful builds
  display_name  = "AWS CodePipeline Notification" # A title for E-mail notification

  ##=========================== Report Portal block ===========================##
  rp_token_name = "/$${local.repo_name}/report/portal/token" # The token name for Report Portal in ParameterStore
  rp_project    = "" # The Report Portal project name
  rp_endpoint   = "" # The Report Portal endpoint

  ##=========================== DLT block ===========================##
  dlt_create              = false # DLT Stage creation switch
  dlt_test_id             = "" # DLT test ID
  admin_name              = "user" # DLT Administrator account name
  cognito_password_name   = "/cognito/password" # Name of the ParameterStore parameter for the DLT administrator password (The parameter value must contain a permanent password, to which the temporary password will be changed upon the first login to the console)
  dlt_test_name           = "DLT-JMeter-Test-$${local.repo_name}" # The Name for DLT test
  dlt_test_type           = "jmeter" # The type of DLT test
  dlt_task_count          = 1 # Number of tasks per one run
  concurrency             = 10 # Concurrency for test
  ramp_up                 = "1m" # Ramp up time for a test
  hold_for                = "1m" # Test time

  ##=========================== Carrier block ===========================##
  carrier_create          = false # Carrier Stage creation switch
  carrier_auth_token_name = "" # The token for Carrier
  carrier_project_id      = "" # ID for Carrier Project
  carrier_test_id         = "" # ID for Carrier test
  carrier_url             = "" # The URL for Carrier

  ##=========================== ECS Task Definition block ===========================##
  cpu                     = 256 # The CPU limit for ECS task
  memory                  = 512 # The Memory limit for ECS task

  ##=========================== ECR block ===========================##
  image_tag_mutability    = "IMMUTABLE" # Mutability for image version tag
  tryvi_severity          = "CRITICAL" # Threat Filter Severity for Tryvi(Can be CRITICAL, HIGH, LOW)

  ##=========================== EKS block ===========================##
  # These variables depends on Helm Chart

  eks_cluster_name = "" # The EKS Cluster name
  eks_role_arn     = "" # The role created EKS Cluster administrator to manage Helm Chart
  cluster_region   = "" # The AWS EKS Cluster region
  ##=========================== Stand Alone Cluster block ===========================##
  cluster_config   = ""  # Cluster config for Kubernetes Stand Alone Cluster
  docker_repo      = ""  # Docker repo for Kubernetes Stand Alone Cluster
  docker_user      = ""  # Docker user name for Kubernetes Stand Alone Cluster
  docker_password  = ""  # Docker user password for Kubernetes StandAlone Cluster

  ##=========================== Common Variables for any Kubernetes Cluster ===========================##
  helm_chart_version = "" # The version for Helm Chart


  #============================ Automatically defined variables ============================#
  #                 Don't change anything, all variables compute automatically              #
  #=========================================================================================#
  environments = keys(local.stages)

  stage_accounts = [for stage in local.environments : local.stages["$${stage}"].account]

  # Regions for stages
  stage_regions = [for stage in local.environments : local.stages["$${stage}"].regions]

  deployment_group_names = [for stage in local.environments : "$${local.repo_name}-$${stage}"]
  application_name       = local.repo_name

  codedeploy_role_arns = [
    for stage in local.environments :
    "arn:aws:iam::$${local.stages["$${stage}"].account}:role/Codedeploy-$${local.repo_name}-$${stage}"
  ]
  ec2_profile_role_arns = local.target_type == "instance" ? [
    for stage in local.environments :
    "arn:aws:iam::$${local.stages["$${stage}"].account}:role/EC2-Profile-Role-$${local.repo_name}-$${stage}"
  ] : []
  account_identifiers = distinct(local.stage_accounts)

  ecr_identifiers = [
    for account in local.account_identifiers :"arn:aws:iam::$${account}:role/Ecs-Execution-$${local.repo_name}"
  ]

  kms_identifiers = concat(local.codedeploy_role_arns, local.ec2_profile_role_arns)

  artifact_bucket_identifiers = concat(local.codedeploy_role_arns, local.ec2_profile_role_arns)

  #============================ CodeBuild Variables are generated dynamically ============================#

  ##=========================== Report Portal block ===========================##
  report_portal_environments = [
    {
      name  = "RP_PROJECT"
      value = local.rp_project
    },
    {
      name  = "RP_ENDPOINT"
      value = local.rp_endpoint
    },
    {
      name  = "RP_TOKEN_NAME"
      value = local.rp_token_name
    }
  ]
}
