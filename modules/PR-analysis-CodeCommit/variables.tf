variable "service_role" {
  type = string
}
variable "repo_name" {
  type = string
}
variable "aws_account_id" {
  type = string
}
variable "region" {
  type = string
}
variable "project" {
  type = string
}
variable "organization_name" {
  type = string
}
variable "sonarcloud_token_name" {}
variable "codeartifact_domain" {
  default = ""
}
variable "codeartifact_repo" {
  default = ""
}