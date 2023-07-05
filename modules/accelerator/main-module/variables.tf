# All variables for Accelerator CI/CD
variable "aws_account_id" {}

variable "region" {
  description = "The AWS region to deploy into"
  type        = string
}
variable "environments" { type = list(string) }
# Route53
variable "route53_zone_name" {
  description = "Route53 zone name to create A-records, without trailing dot"
  type        = string
}

# Sonar
variable "organization_name" { type = string }
variable "repo_name" { type = string }
variable "repo_default_branch" { type = string }
variable "project_key" { type = string }
variable "sonar_url" {}
variable "sonarcloud_token_name" { type = string }

# VPC
variable "project" {}
variable "vpc_id" {}
variable "security_groups" { type = list(string) }
variable "private_subnet_ids" {
  type = list(string)
}
variable "public_subnet_ids" {
  type = list(string)
}
# notifications
variable "display_name" { type = string }
variable "email_addresses" { type = list(string) }
variable "teams_web_hook" {
  type    = string
  default = ""
}
variable "slack_web_hook" {
  type    = string
  default = ""
}
variable "build_success" {
  description = "If true, you will also get notifications about successful builds"
  type        = bool
}
variable "source_provider" {
  type        = string
  description = "*CodeStarSourceConnection* for Bitbucket, GitHub or *CodeCommit* for AWS CodeCommit and GitLab"
}
variable "connection_provider" {
  type        = string
  description = "Valid values are Bitbucket, GitHub, or GitHubEnterpriseServer; leave blank for others"
}
variable "auth_token" {
  description = "Substituted when atlantis apply"
  type        = string
  default     = ""
}

variable "bitbucket_user" {
  type    = string
  default = ""
}
#============================= Bucket Variables ====================================#
variable "storage_bucket_name" {
  default = ""
}
variable "artifact_bucket_name" {
  default = ""
}
variable "force_destroy" {
  description = "Delete bucket when destroy: true or false"
}

variable "versioning" {
  description = "Versioning bucket enabled: true or false"
}

variable "expiration_days" {
  type        = string
  description = "amount of days after artifacts of the AWS Code Pipeline will be removed"
}

#==================================================
variable "aws_acm_certificate_arn" {}
variable "health_path" {}
# The path for loadbalancer's health check
variable "target_type" {
  description = "Target type: <instance> for ec2 or <ip> for ecs"
}
# Numbers of instances in ASG or containers in ECS
variable "desired_capacity" { type = list(string) }
variable "max_size" { type = list(string) }
variable "min_size" { type = list(string) }
variable "instance_type" {
  description = "Instance type for launch template ex. t2.micro"
}

variable "application_port" {
  description = "Port where a loadbalanser redirects traffic"
}
variable "cpu" {
  description = "CPU Size for container, min=218"
}
variable "memory" {
  description = "Memory size for container, min=512"
}

# Variables for Codebuild
variable "build_timeout" {
  description = "The time to wait for a CodeBuild to complete before timing out in minutes (default: 5)"
  default     = "30"
}

variable "build_compute_type" {
  description = "The build instance type for CodeBuild (default: BUILD_GENERAL1_SMALL)"
  default     = "BUILD_GENERAL1_MEDIUM"
}
variable "build_image" {
  description = "The build image for CodeBuild to use (default: aws/codebuild/standard:5.0)"
  default     = "aws/codebuild/standard:6.0"
}
variable "build_privileged_override" {
  description = "Set the build privileged override to 'false' if you are not using a CodeBuild supported Docker base image. This is only relevant to building Docker images"
  default     = "true"
}

# Buildspec files for codebuilds
variable "test_buildspec" {
  description = "The buildspec to be used for the Test stage (default: buildspec_test.yml)"
  default     = "buildspec_test.yml"
}
variable "test_func_buildspec" {
  description = "The buildspec to be used for the Func Test stage (default: buildspec_test_func.yml)"
  default     = "buildspec_test_func.yml"
}
variable "test_perf_buildspec" {
  description = "The buildspec to be used for the Perf Test stage"
  default     = "buildspec_dlt.yml" #"buildspec_performance.yml"
}
variable "package_buildspec" {
  description = "The buildspec to be used for the Package stage on EC2"
  default     = "buildspec.yml"
}
variable "docker_buildspec" {
  description = "The buildspec to be used for the Package stage on ECS"
  default     = "buildspec_docker.yml"
}

variable "conf_all_at_once" {
  description = "Strategy if desired capacity equal 1 "
  default     = "CodeDeployDefault.AllAtOnce"
}
variable "conf_one_at_time" {
  description = "Strategy if desired capacity more then 1, we can change strategy https://docs.aws.amazon.com/codedeploy/latest/userguide/deployment-configurations.html "
  default     = "CodeDeployDefault.OneAtATime"
}

variable "codeartifact_create" {
  description = "Create AWS Codeartifact for JAVA Application"
  type        = bool
  default     = false
}
#===================================
variable "region_name" {
  description = "Name of region_name to deploy application, use for resources naming"
}

# Variables for DLT test
variable "aws_acm_certificate_usa_arn" {}
variable "cognito_password_name" {}
variable "admin_name" {}
variable "private_subnets" {
  type = list(string)
}
variable "vpc_range" {}


# Variables for Report Portal
variable "rp_endpoint" {}
variable "rp_token_name" {}
variable "rp_project" {}

# EKS Variables
variable "cluster_name" {}
variable "buildspec_eks" {
  default = "buildspec_eks.yml"
}
variable "eks_role_arn" {
  default = ""
}
variable "cluster_public_subnet_ids" {
  type = list(string)
  default = []
}
variable "cluster_security_groups" {
  type = list(string)
  default = []
}
variable "cluster_region" {}
variable "cluster_acm_certificate_arn" {
  default = ""
}

  variable "app_fqdn" {
    type = list(string)
    default = []
  }
variable "cluster_config" {
  description = "Name of AWS Parameter Store Variable, where K8s Cluster config stored in base64"
  default = ""
}
variable "docker_user" {
  description = "AWS Parameter Store variable of User to get Image from Docker Registry"
  default = ""
}
variable "docker_password" {
  description = "AWS Parameter Store variable Name to get password for Docker Registry"
  default = ""
}
variable "docker_repo" {
  description = "Name for Docker Registry REPO/NAME"
  default = ""
}
variable "helm_chart" {
  description = "Helm Chart URL with release"
  default = ""
}
variable "helm_chart_version" {
  default = ""
}

#=================== Unit Tests ====================
variable "unit_buildspec" {
  default = "buildspec_unit_tests.yml"
}