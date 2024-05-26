variable "repo_name" {
  description = "The name of the repository"
  type        = string
}

variable "subnet_ids" {
  description = "A list of subnet IDs to be used in the deployment"
  type        = list(string)
}

variable "security_groups" {
  description = "A list of security group IDs to be used in the deployment"
  type        = list(string)
}
variable "aws_kms_key_arn" {
  description = "The Amazon Resource Name (ARN) of the AWS KMS key"
  type        = string
}
