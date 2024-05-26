variable "repo_name" {
  description = "The name of the GitHub/Bitbucket/CodeCommit repository"
  type        = string
}

variable "region" {
  description = "The AWS region to deploy the resources"
  type        = string
}

variable "key_users" {
  description = "A list of IAM ARNs for [key users](https://docs.aws.amazon.com/kms/latest/developerguide/key-policy-default.html#key-policy-default-allow-users)"
  type        = list(string)
}

variable "key_service_users" {
  description = "A list of IAM ARNs for [key service users](https://docs.aws.amazon.com/kms/latest/developerguide/key-policy-default.html#key-policy-service-integration)"
  type        = list(string)
}
