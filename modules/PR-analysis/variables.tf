variable "region" {
  type = string
}
variable "project" {
  type = string
}
variable "organization_name" {
  type = string
}
variable "aws_account_id" {}

variable "auth_token" {
  type = string
}
variable "repo_name" {
  type = string
}
variable "build_timeout" {
  type = string
}
variable "service_role" {
  type = string
}
variable "connection_provider" {
  type = string
}
variable "location" {
  type = string
}
variable "bitbucket_user" {
  type = string
  default = ""
}
variable "webhook_pattern" {
  type = string
}
variable "sonarcloud_token_name" {}
variable "codeartifact_domain" {
  default = ""
}
variable "codeartifact_repo" {
  default = ""
}
variable "region_name" {}
variable "aws_kms_key" {}