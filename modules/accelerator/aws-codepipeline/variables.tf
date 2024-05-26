variable "region" {
  description = "The AWS region where resources will be created"
  type        = string
}
variable "aws_account_id" {
  description = "The AWS account ID where resources will be created"
  type        = string
}
variable "vpc_id" {
  description = "The ID of the VPC in which resources will be deployed"
  type        = string
}
variable "private_subnet_ids" {
  description = "List of VPC Private Subnet IDs"
  type        = list(string)
}
variable "security_groups" {
  description = "List of security group IDs to be applied to resources"
  type        = list(string)
}
variable "organization_name" {
  description = "The organization name for Sonar"
  type        = string
}
variable "repo_name" {
  description = "The name of the GitHub/Bitbucket/CodeCommit repository"
  type        = string
}
variable "git_owner" {
  description = "The owner of the git repository"
  type        = string
}
variable "repo_default_branch" {
  description = "The name of the default repository branch"
  type        = string
}
variable "build_timeout" {
  description = "The time to wait for a CodeBuild to complete before timing out in minutes"
  type        = string
}
variable "build_compute_type" {
  description = "The build instance type for CodeBuild"
  type        = string
}
variable "build_image" {
  description = "The build image for CodeBuild to use"
  type        = string
}
variable "buildspec_sonar" {
  description = "The buildspec file to be used for the Sonar Test stage"
  type        = string
}
variable "buildspec_selenium" {
  description = "The buildspec file to be used for the Func Test stage"
  type        = string
}
variable "buildspec_package" {
  description = "The buildspec file to be used for the Package stage on EC2 or ECS"
  type        = string
}
variable "project_key" {
  description = "Project Key for Sonar"
  type        = string
}
variable "sonar_url" {
  description = "Sonar URL"
  type        = string
}
variable "sonarcloud_token_name" {
  description = "The name of the SonarCloud token"
  type        = string
}
variable "environments" {
  description = "List of environments for deployments. Used for creation according CodeGuru profiling groups"
  type        = list(string)
}
variable "connection_provider" {
  description = "Valid values are Bitbucket, GitHub, or GitHubEnterpriseServer"
  type        = string
}
variable "provider_endpoint" {
  description = "Endpoint for the provider"
  type        = string
}
variable "codestarconnection_host_arn" {
  description = "The ARN of the host that the connection is associated with"
  type        = string
}
variable "app_fqdn" {
  description = "Fully Qualified Domain Name of the application"
  type        = list(string)
}
variable "approve_sns_arn" {
  description = "SNS Topic ARN for approval notifications"
  type        = string
}
variable "service_bucket" {
  description = "Bucket where additional files are stored (for ECS task definitions, deb script)"
  type        = string
}
variable "aws_kms_key" {
  description = "AWS KMS Key used for encryption and decryption"
  type        = string
}
variable "aws_kms_key_arn" {
  description = "AWS KMS Key ARN used for encryption and decryption"
  type        = string
}
variable "region_name" {
  description = "Name of the AWS region"
  type        = string
}
variable "target_type" {
  description = "Type of the deployment target (e.g., instance, lambda, or ecs)"
  type        = string
}
variable "codebuild_role" {
  description = "IAM Role for AWS CodeBuild"
  type        = string
}
variable "codepipeline_role" {
  description = "IAM Role for AWS CodePipeline"
  type        = string
}
variable "codeartifact_domain" {
  description = "Domain for AWS CodeArtifact, used for Java applications"
  type        = string
}
variable "codeartifact_repo" {
  description = "Repository for AWS CodeArtifact, used for Java applications"
  type        = string
}
variable "selenium_create" {
  description = "Flag to control the creation of Selenium resources"
  type        = bool
}
variable "dlt_create" {
  description = "Flag to control the creation of DLT Test resources"
  type        = bool
}
variable "buildspec_dlt" {
  description = "The buildspec to be used for the Performance Test"
  type        = string
}
variable "dlt_ui_url" {
  description = "User Interface URL for DLT"
  type        = string
}
variable "cognito_password_name" {
  description = "The name of the AWS Cognito password"
  type        = string
}
variable "admin_name" {
  description = "Name of the admin user"
  type        = string
}
variable "dlt_api_host" {
  description = "Host for DLT API"
  type        = string
}
variable "cognito_user_pool_id" {
  description = "ID of AWS Cognito User Pool"
  type        = string
}
variable "cognito_client_id" {
  description = "ID of AWS Cognito Client"
  type        = string
}
variable "cognito_identity_pool_id" {
  description = "ID of AWS Cognito Identity Pool"
  type        = string
}
variable "dlt_fqdn" {
  description = "Fully Qualified Domain Name for DLT service"
  type        = string
}
variable "dlt_test_name" {
  description = "Name of the DLT Test"
  type        = string
}
variable "dlt_test_id" {
  description = "ID of the DLT Test"
  type        = string
}
variable "dlt_test_type" {
  description = "Type of the DLT Test"
  type        = string
}
variable "dlt_task_count" {
  description = "Count of DLT tasks"
  type        = number
}
variable "concurrency" {
  description = "Concurrency level for tasks"
  type        = number
}
variable "ramp_up" {
  description = "Ramp up time for tasks"
  type        = string
}
variable "hold_for" {
  description = "Duration to hold for tasks"
  type        = string
}
variable "buildspec_eks" {
  description = "The buildspec for EKS"
  type        = string
}
variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}
variable "eks_role_arn" {
  description = "ARN of the IAM role used by EKS"
  type        = string
}
variable "ecr_repo_name" {
  description = "Name of the ECR repository"
  type        = string
}
variable "cluster_region" {
  description = "AWS region where the cluster is located"
  type        = string
}
variable "cluster_config" {
  description = "Base64-encoded K8s cluster configuration"
  type        = string
}
variable "docker_user" {
  description = "Username for Docker Registry"
  type        = string
}
variable "docker_password" {
  description = "Name of the AWS Parameter Store variable storing the Docker Registry password"
  type        = string
}
variable "docker_repo" {
  description = "Name for Docker Registry repository"
  type        = string
}
variable "helm_chart" {
  description = "Url to the Helm chart with release"
  type        = string
}
variable "helm_chart_version" {
  description = "Version of the Helm chart"
  type        = string
}
variable "tryvi_severity" {
  description = "Severity level for Trivy (a vulnerability scanner for containers)"
  type        = string
}
variable "buildspec_unit" {
  description = "The buildspec for unit tests"
  type        = string
}
variable "deployment_group_names" {
  description = "List of deployment group names for AWS CodeDeploy"
  type        = list(string)
}
variable "application_name" {
  description = "Name of the application for AWS CodeDeploy"
  type        = string
}
variable "codedeploy_role_arns" {
  description = "List of Role ARNs for AWS CodeDeploy"
  type        = list(string)
}
variable "report_portal_environments" {
  description = "List of environments for AWS Report Portal"
  type        = list(map(string))
}
variable "stage_regions" {
  description = "List of regions where application infrastructure for stage is deployed"
  type        = list(list(string))
}
variable "artifact_bucket_prefix" {
  description = "Prefix for the S3 bucket where the artifacts are stored"
  type        = string
}
variable "carrier_create" {
  description = "Flag to enable the creation of Carrier resources"
  type        = bool
}
variable "buildspec_carrier" {
  description = "The buildspec for Carrier"
  type        = string
}
variable "carrier_url" {
  description = "URL for Carrier"
  type        = string
}
variable "carrier_project_id" {
  description = "Project ID for Carrier"
  type        = string
}
variable "carrier_token_name" {
  description = "Name of Carrier token"
  type        = string
}
variable "carrier_test_id" {
  description = "Test ID for Carrier"
  type        = string
}
variable "synthetics_create" {
  description = "Flag to enable the creation of Synthetics resources"
  type        = bool
}
variable "statemachine_arn" {
  description = "ARN of the StateMachine for Synthetics"
  type        = string
}
