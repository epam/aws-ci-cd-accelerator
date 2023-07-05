variable "repo_name" {}
variable "codepipeline_arn" {}
variable "codepipeline_name" {}
variable "email_addresses" {
  type = list(string)
}
variable "teams_web_hook" {}
variable "slack_web_hook" {}
variable "build_success" {
  description = "If true, you will also get notifications about successful builds"
  type = bool
}
variable "lambda_file" {
  type    = string
  default = "notification_lambda.py"
}

variable "lambda_zip_file" {
  type    = string
  default = "notification_lambda.zip"
}
variable "display_name" {}
variable "region_name" {}
variable "private_subnet_ids" {
  type = list(string)
}
variable "security_groups" {
  type = list(string)
}
variable "aws_kms_key" {}