output "codepipeline_arn" {
  description = "The ARN of the CodePipeline"
  value       = var.target_type == "instance" ? aws_codepipeline.codepipeline[0].arn : (var.target_type == "ip" ? aws_codepipeline.codepipeline_ecs[0].arn : aws_codepipeline.codepipeline_eks[0].arn)
}

output "codepipeline_name" {
  description = "The name of the CodePipeline"
  value       = var.target_type == "instance" ? aws_codepipeline.codepipeline[0].name : (var.target_type == "ip" ? aws_codepipeline.codepipeline_ecs[0].name : aws_codepipeline.codepipeline_eks[0].name)
}
