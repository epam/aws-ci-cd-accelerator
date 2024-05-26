output "application_name" {
  description = "The name of the CodeDeploy application"
  value       = aws_codedeploy_app.application.name
}

output "deployment_group_name_ec2" {
  description = "The name of the EC2 deployment group"
  value       = var.target_type == "instance" ? aws_codedeploy_deployment_group.ec2[*].deployment_group_name : null
}

output "deployment_group_name_ecs" {
  description = "The name of the ECS deployment group"
  value       = var.target_type == "ip" ? aws_codedeploy_deployment_group.ecs[*].deployment_group_name : null
}

output "codedeploy_role_name" {
  description = "The name of the CodeDeploy role"
  value       = var.codedeploy_role_create ? aws_iam_role.codedeploy_role[*].name : null
}

output "codedeploy_role_arn" {
  description = "The ARN of the CodeDeploy role"
  value       = var.codedeploy_role_create ? aws_iam_role.codedeploy_role[*].arn : null
}
