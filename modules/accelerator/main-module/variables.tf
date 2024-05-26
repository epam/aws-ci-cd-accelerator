variable "aws_account_id" {
  description = "The AWS account ID"
  type        = string
}

variable "region" {
  description = "The AWS region to deploy into"
  type        = string
}

variable "environments" {
  description = "List of environment names"
  type        = list(string)
}

variable "organization_name" {
  description = "Name of a Sonar Organization"
  type        = string
}

variable "repo_name" {
  description = "Name of an application repository"
  type        = string
}

variable "git_owner" {
  description = "Git Repository Owner"
  type        = string
}

variable "repo_default_branch" {
  description = "Default branch name for the repository"
  type        = string
}

variable "project_key" {
  description = "Project key for SonarQube"
  type        = string
}

variable "sonar_url" {
  description = "URL for SonarQube or SonarCloud instance"
  type        = string
}

variable "sonarcloud_token_name" {
  description = "Name of the Parameter Store variable for SonarCloud token"
  type        = string
}

# VPC
variable "project" {
  description = "Name of the project for tags and resource naming"
  type        = string
}

variable "vpc_id" {
  description = "The ID of the existing VPC"
  type        = string
}

variable "security_groups" {
  description = "List of security group IDs to associate with resources for testing"
  type        = list(string)
  default     = []
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs to use for the deployment"
  type        = list(string)
}

variable "display_name" {
  description = "Display name for AWS CodePipeline notifications"
  type        = string
  default     = "AWS CodePipeline Notification"
}

variable "email_addresses" {
  description = "List of email addresses to receive AWS CodePipeline notifications"
  type        = list(string)
  default     = []
}

variable "build_success" {
  description = "If true, you will also get notifications about successful builds"
  type        = bool
  default     = false
}

variable "connection_provider" {
  description = "Valid values are Bitbucket, GitHub, or GitHubEnterpriseServer; leave blank for others"
  type        = string
  default     = "GitHub"
}

variable "provider_endpoint" {
  description = "Endpoint for the provider"
  type        = string
}

variable "codestarconnection_host_arn" {
  description = "The ARN of the host that the connection is associated with"
  type        = string
  default     = ""
}

variable "bitbucket_user" {
  description = "Username for Bitbucket integration"
  type        = string
  default     = ""
}

variable "force_destroy" {
  description = "Delete bucket when destroy: true or false"
  type        = bool
}

variable "target_type" {
  description = "Target type: <instance> for EC2 or <ip> for ECS"
  type        = string
}

variable "build_timeout" {
  description = "The time to wait for a CodeBuild to complete before timing out in minutes (default: 5)"
  type        = string
  default     = "30"
}

variable "build_compute_type" {
  description = "The build instance type for CodeBuild (default: BUILD_GENERAL1_SMALL)"
  type        = string
  default     = "BUILD_GENERAL1_MEDIUM"
}

variable "build_image" {
  description = "The build image for CodeBuild to use (default: aws/codebuild/standard:6.0)"
  default     = "aws/codebuild/standard:6.0"
  type        = string
}

variable "buildspec_sonar" {
  description = "The buildspec file to be used for the Test stage."
  type        = string
  default     = "buildspec_sonar.yml"
}

variable "buildspec_selenium" {
  description = "The buildspec file to be used for the Func Test stage."
  type        = string
  default     = "buildspec_selenium.yml"
}

variable "buildspec_package" {
  description = "The buildspec file to be used for the Package stage on EC2"
  type        = string
  default     = "buildspec.yml"
}

variable "buildspec_docker" {
  description = "The buildspec file to be used for the Package stage on ECS"
  type        = string
  default     = "buildspec_docker.yml"
}

variable "codeartifact_create" {
  description = "Create AWS Codeartifact for JAVA Application"
  type        = bool
  default     = false
}

variable "region_name" {
  description = "Name of region_name to deploy application, use for resources naming"
  type        = string
}

variable "selenium_create" {
  description = "Flag to specify whether to create Selenium resources"
  type        = bool
  default     = false
}

variable "dlt_create" {
  description = "Flag to specify whether to create DLT test resources"
  type        = bool
  default     = true
}

variable "buildspec_dlt" {
  description = "The buildspec to be used for the Performance Test stage"
  type        = string
  default     = "buildspec_dlt.yml"
}

variable "cognito_password_name" {
  description = "Parameter Store variable name for Cognito User for DLT"
  type        = string
  default     = "/cognito/password"
}

variable "admin_name" {
  description = "User Name for access to DLT WEB UI"
  type        = string
  default     = "user"
}

variable "dlt_ui_url" {
  description = "URL for the DLT WEB UI"
  type        = string
  default     = ""
}

variable "dlt_fqdn" {
  description = "Fully Qualified Domain Name (FQDN) for the DLT test"
  type        = string
  default     = ""
}

variable "dlt_api_host" {
  description = "API host for the DLT test"
  type        = string
  default     = ""
}

variable "cognito_user_pool_id" {
  description = "Cognito User Pool ID for the DLT test"
  type        = string
  default     = ""
}

variable "cognito_client_id" {
  description = "Cognito Client ID for the DLT test"
  type        = string
  default     = ""
}

variable "cognito_identity_pool_id" {
  description = "Cognito Identity Pool ID for the DLT test"
  type        = string
  default     = ""
}

variable "dlt_test_name" {
  description = "The name of your load test."
  type        = string
  default     = ""
}

variable "dlt_test_id" {
  description = "The ID of your load test."
  type        = string
  default     = ""
}

variable "dlt_test_type" {
  description = "DLT test type (`simple` / `jmeter`)"
  type        = string
  default     = "simple"
}

variable "dlt_task_count" {
  description = "Number of containers that will be launched in the Fargate cluster to run the test scenario. Additional tasks will not be created once the account limit on Fargate resources has been reached, however tasks already running will continue."
  type        = number
  default     = 1
}

variable "concurrency" {
  description = "The number of concurrent virtual users generated per task. The recommended limit based on default settings is 200 virtual users."
  type        = number
  default     = 1
}

variable "ramp_up" {
  description = "The time to reach target concurrency."
  type        = string
  default     = "1m"
}

variable "hold_for" {
  description = "Time to hold target concurrency."
  type        = string
  default     = "1m"
}

variable "buildspec_unit" {
  description = "The buildspec file to be used for Unit Tests stage"
  type        = string
  default     = "buildspec_unit_tests.yml"
}

variable "application_name" {
  description = "AWS CodeDeploy Application Name"
  type        = string
  default     = ""
}

variable "deployment_group_names" {
  description = "AWS CodeDeploy Deployment Group"
  type        = list(string)
  default     = []
}

variable "codedeploy_role_arns" {
  description = "List of AWS CodeDeploy role ARNs"
  type        = list(string)
  default     = []
}

variable "key_service_users" {
  description = "A list of IAM ARNs for [key service users](https://docs.aws.amazon.com/kms/latest/developerguide/key-policy-default.html#key-policy-service-integration)"
  type        = list(string)
  default     = []
}

variable "kms_identifiers" {
  description = "Identifiers for KMS policy."
  type        = list(string)
  default     = []
}

variable "image_tag_mutability" {
  description = "Mutability of docker image tag of application"
  type        = string
  default     = "IMMUTABLE"
}

variable "tryvi_severity" {
  description = "Trivy Scan Severity"
  type        = string
  default     = ""
}

variable "account_identifiers" {
  description = "Identifiers for the AWS account"
  type        = list(string)
}

variable "artifact_bucket_identifiers" {
  description = "Identifiers for the artifact bucket"
  type        = list(string)
}

variable "report_portal_environments" {
  description = "List of Report Portal environments to deploy"
  type        = list(map(string))
}

variable "stages" {
  description = "Map of stage settings"
  type = map(object({
    account      = string
    regions      = list(string)
    region_names = list(string)
  }))
}

variable "artifact_bucket_prefix" {
  description = "Prefix for an artifact bucket"
  type        = string
  default     = "artifact-bucket"
}

variable "service_bucket_prefix" {
  description = "Prefix for a storage bucket"
  type        = string
  default     = "service-bucket"
}

variable "carrier_create" {
  description = "Flag to specify whether to create Carrier resources"
  type        = bool
  default     = false
}

variable "buildspec_carrier" {
  description = "The name of buildspec file if we use Carrier"
  type        = string
  default     = "buildspec_carrier.yml"
}

variable "carrier_url" {
  description = "URL for Carrier integration"
  type        = string
  default     = ""
}

variable "carrier_project_id" {
  description = "The Carrier project ID"
  type        = string
  default     = ""
}

variable "carrier_token_name" {
  description = "Name of the Parameter Store variable for Carrier token"
  type        = string
  default     = "/carrier/token"
}

variable "carrier_test_id" {
  description = "The Carrier test ID"
  type        = string
  default     = ""
}

variable "cpu" {
  description = "CPU Size for container, min=256"
  type        = number
}

variable "memory" {
  description = "Memory size for container, min=512"
  type        = number
}

variable "container_name" {
  description = "Container name for the application"
  type        = string
  default     = "application"
}

variable "application_port" {
  description = "Port where a load balancer redirects traffic"
  type        = string
  default     = "8080"
}

variable "eks_cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "buildspec_eks" {
  description = "Buildspec file to be used for EKS deployment"
  type        = string
  default     = "buildspec_eks.yml"
}

variable "eks_role_arn" {
  description = "ARN of the role used for EKS resources"
  type        = string
  default     = ""
}


variable "cluster_region" {
  description = "Region for the EKS cluster"
  type        = string
  default     = ""
}


variable "app_fqdn" {
  description = "List of Fully Qualified Domain Names (FQDN) for the application"
  type        = list(string)
  default     = []
}

variable "cluster_config" {
  description = "Name of AWS Parameter Store Variable, where K8s Cluster config stored in base64"
  type        = string
  default     = ""
}

variable "docker_user" {
  description = "AWS Parameter Store variable of User to get Image from Docker Registry"
  type        = string
  default     = ""
}

variable "docker_password" {
  description = "AWS Parameter Store variable Name to get password for Docker Registry"
  type        = string
  default     = ""
}

variable "docker_repo" {
  description = "Name for Docker Registry REPO/NAME"
  type        = string
  default     = ""
}

variable "helm_chart" {
  description = "Helm Chart URL with release"
  type        = string
  default     = ""
}

variable "helm_chart_version" {
  description = "Version of the Helm chart to use"
  type        = string
  default     = ""
}

variable "stage_regions" {
  description = "List of lists containing stage regions"
  type        = list(list(string))
}

variable "env_vars" {
  description = "Map containing environment variables per environment"
  type        = map(list(map(string)))
  default = {
    dev = []
    qa  = []
    uat = []
  }
}

variable "secrets" {
  description = "Map containing secret variables per environment"
  type        = map(list(map(string)))
  default = {
    dev = []
    qa  = []
    uat = []
  }
}

variable "synthetics_create" {
  description = "Flag to specify whether to create Synthetics resources"
  type        = bool
  default     = false
}

variable "llm_model" {
  description = "LLM Model for AI"
  type        = string
}

variable "openai_api_endpoint" {
  type        = string
  description = "Open AI Endpoint"
}

variable "openai_token_name" {
  type        = string
  description = "Parameter Store Variable Name for OPEN AI API KEY"
}
