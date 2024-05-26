variable "repo_name" {
  description = "The name of the repository"
  type        = string
}

variable "codepipeline_name" {
  description = "The name of the CodePipeline"
  type        = string
}

variable "email_addresses" {
  description = "List of email addresses to receive AWS CodePipeline notifications"
  type        = list(string)
}

variable "build_success" {
  description = "If true, you will also get notifications about successful builds"
  type        = bool
}
variable "lambda_file" {
  description = "The lambda file name for the notification"
  type        = string
  default     = "notification_lambda.py"
}

variable "lambda_zip_file" {
  description = "The zip archive name for the notification"
  type        = string
  default     = "notification_lambda.zip"
}
variable "display_name" {
  description = "Display name for AWS CodePipeline notifications"
  type        = string
}
variable "region_name" {
  description = "The name of the AWS region"
  type        = string
}
variable "private_subnet_ids" {
  description = "A list of private subnet IDs in the VPC"
  type        = list(string)
}
variable "security_groups" {
  description = "A list of security group IDs for the resources"
  type        = list(string)
}
variable "aws_kms_key" {
  description = "AWS KMS Key ARN used for encryption and decryption"
  type        = string
}
