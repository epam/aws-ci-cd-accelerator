variable "region" {
  description = "The AWS region where the CodeCommit repository will be created."
  type        = string
}
variable "aws_repo_name" {
  description = "The name of the AWS CodeCommit repository to be created for mirroring."
  type        = string
  default     = ""
}
variable "project_id" {
  description = "The GitLab project ID where the CI/CD pipeline variables will be added."
  type        = string
  default     = ""
}

variable "aws_user_name" {
  description = "The name of the AWS IAM user to create the AWS CodeCommit repository and IAM policies."
  type        = string
  default     = ""
}
variable "gitlab_hostname" {
  description = "The GitLab instance's hostname, used to configure the GitLab provider's base URL."
  type        = string
  default     = ""
}
variable "gitlab_token" {
  description = "The GitLab API token, used to authenticate requests to the GitLab instance."
  type        = string
  default     = ""
}

variable "sonar_url" {
  description = "The URL of the SonarQube or SonarCloud instance used for code analysis."
  type        = string
  default     = ""
}
variable "sonarcloud_token" {
  description = "The SonarCloud API token used to authenticate requests to the SonarCloud instance."
  type        = string
  default     = ""
}
variable "organization_name" {
  description = "The name of the organization in SonarCloud where the project will be analyzed."
  type        = string
  default     = ""
}
variable "sonar_project_key" {
  description = "The unique identifier for the project in SonarCloud."
  type        = string
  default     = ""
}
variable "sonar_project_name" {
  description = "The name of the project in SonarCloud."
  type        = string
  default     = ""
}
variable "sonar_timeout" {
  description = "The timeout duration for waiting for the SonarQube or SonarCloud quality gate status."
  type        = number
  default     = 300
}
variable "app_language" {
  description = "The programming language of the application, used in the CI/CD pipeline."
  type        = string
  default     = ""
}
