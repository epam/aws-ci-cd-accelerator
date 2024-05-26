variable "repo_name" {
  description = "The name of the GitHub/Bitbucket/CodeCommit repository"
  type        = string
}

variable "codebuild_role_arn" {
  description = "The Amazon Resource Name (ARN) of the IAM role for CodeBuild to assume"
  type        = string
}

variable "project" {
  description = "The project name"
  type        = string
}
