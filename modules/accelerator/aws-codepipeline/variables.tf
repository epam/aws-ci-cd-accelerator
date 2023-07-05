variable "region" {}
variable "aws_account_id" {
  description = "The AWS account ID to deploy to"
}

variable "vpc_id" {}
variable "private_subnet_ids" {
  type = list(string)
}
variable "public_subnet_ids" {
  type = list(string)
}
variable "security_groups" {
  type = list(string)
}

variable "organization_name" {
  description = "The organization name provisioning the template (e.g. pets)"
}
variable "repo_name" {
  description = "The name of the GitHub/Bitbucket/CodeCommit repository (e.g. new-repo)."
}
variable "repo_default_branch" {
  description = "The name of the default repository branch (default: main)"
}
variable "build_timeout" {
  description = "The time to wait for a CodeBuild to complete before timing out in minutes (default: 5)"
}
variable "build_compute_type" {
  description = "The build instance type for CodeBuild (default: BUILD_GENERAL1_SMALL)"
}
variable "build_image" {
  description = "The build image for CodeBuild to use (default: aws/codebuild/standard:4.0)"
}
variable "build_privileged_override" {
  description = "Set the build privileged override to 'false' if you are not using a CodeBuild supported Docker base image. This is only relevant to building Docker images"
}
variable "test_buildspec" {
  description = "The buildspec to be used for the Test stage (default: buildspec_test.yml)"
}

variable "test_func_buildspec" {
  description = "The buildspec to be used for the Func Test stage (default: buildspec_test_func.yml)"
}

variable "test_perf_buildspec" {
  description = "The buildspec to be used for the Perf Test stage"
}

variable "package_buildspec" {
  description = "The buildspec to be used for the Package stage on EC2 or ECS"
}

variable "project_key" {
  description = "Project Key for Sonar"
}
variable "sonar_url" {
  description = "Sonar URL"
}

variable "sonarcloud_token_name" { type = string }

variable "environments" {
  description = "List of enviroments for deployments. Used for creation according CodeGuru profiling_groups"
  type        = list(string)
}

variable "source_provider" {
  type = string
}
variable "connection_provider" {
  type = string
  description = "Valid values are Bitbucket, GitHub, or GitHubEnterpriseServer."
}

variable "template_name" {}
variable "app_fqdn" {}
variable "approve_sns_arn" {}

variable "storage_bucket" {
  description = "Bucket where additional artifacts store(for dlt, deb script)"
  type        = string
}
variable "build_artifact_bucket" {}
variable "aws_kms_key" {}
variable "aws_kms_key_arn" {}
variable "region_name" {}
variable "asg_name" {}
variable "target_group_name" { type = list(string) }
variable "target_group_green_name" { type = list(string) }
variable "target_group_blue_name" { type = list(string) }
variable "desired_capacity" { type = list(string) }
variable "conf_all_at_once" {}
variable "conf_one_at_time" {}
variable "target_type" {}
variable "image_repo_name" {}
variable "main_listener" {}
variable "termination_wait_time_in_minutes" {
  default = 0
}
variable "codebuild_role" {}
variable "codepipeline_role" {}
variable "codedeploy_role" {}
variable "codeartifact_domain" {
  description = "Use for Java application"
}
variable "codeartifact_repo" {
  description = "Use for Java application"
}
## For ECS Service usage
variable "ecs_cluster_name" {}
variable "ecs_service_name" {
  type = list(string)
}

# Variables for DLT test
variable "dlt_ui_url" {}
variable "cognito_password_name" {}
variable "admin_name" {}
variable "dlt_api_host" {}
variable "cognito_user_pool_id" {}
variable "cognito_client_id" {}
variable "cognito_identity_pool_id" {}
variable "route53_zone_name" {}
# Variables for Report Portal
variable "rp_endpoint" {}
variable "rp_token_name" {}
variable "rp_project" {}

#============================ EKS =================================================#
variable "buildspec_eks" {}
variable "cluster_name" {}
variable "health_path" {}
variable "target_port" {}
variable "aws_acm_certificate_arn" {}
variable "eks_role_arn" {}
variable "cluster_public_subnet_ids" {
  type = list(string)
}
variable "cluster_security_groups" {
  type = list(string)
}
variable "cluster_region" {}
variable "cluster_acm_certificate_arn" {}
variable "cluster_config" {
  description = "Name of AWS Parameter Store Variable, where K8s Cluster config stored in base64"
}
variable "docker_user" {
  description = "User for Docker Registry to get Image from"
}
variable "docker_password" {
  description = "AWS Parameter Store variable Name to get password for Docker Registry"
}
variable "docker_repo" {
  description = "Name for Docker Registry REPO/NAME"
}
variable "helm_chart" {
  description = "Helm Chart URL with release"
}
variable "helm_chart_version" {}

#======================= Unit Tests ===========================#
variable "unit_buildspec" {
  default = "buildspec_unit_tests.yml"
}