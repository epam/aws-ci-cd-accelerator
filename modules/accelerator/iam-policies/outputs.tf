output "codepipeline_role_arn" {
  description = "The ARN of the CodePipeline IAM role"
  value       = aws_iam_role.codepipeline_role.arn
}

output "codebuild_role_arn" {
  description = "The ARN of the CodeBuild IAM role"
  value       = aws_iam_role.codebuild_role.arn
}

output "codepipeline_role_name" {
  description = "The name of the CodePipeline IAM role"
  value       = aws_iam_role.codepipeline_role.id
}

# output "codedeploy_role_arn" {
#  description = "The ARN of the CodeDeploy IAM role"
#  value = var.target_type == "ip" || var.target_type == "instance" ? aws_iam_role.codedeploy_role[0].arn : ""
# }
