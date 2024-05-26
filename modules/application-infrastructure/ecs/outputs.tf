output "service_name" {
  description = "The name of the ECS service"
  value       = aws_ecs_service.app_ecs_service[*].name
}

output "cluster_name" {
  description = "The name of the ECS cluster"
  value       = aws_ecs_cluster.ecs_cluster.name
}

output "ecs_execution_role_arn" {
  description = "The ARN of the ECS execution role"
  value       = aws_iam_role.ecs_execution_role.arn
}

output "ecs_task_role_arn" {
  description = "The ARN of the ECS task role"
  value       = aws_iam_role.ecs_task_role.arn
}

output "log_group_arn" {
  description = "The ARN of the CloudWatch Logs group"
  value       = aws_cloudwatch_log_group.logs_group[*].arn
}
