output "asg_name" {
  description = "The name of the Autoscaling Group (ASG)"
  value       = aws_autoscaling_group.asg[*].name
}

output "asg_arn" {
  description = "The ARN of the Autoscaling Group (ASG)"
  value       = aws_autoscaling_group.asg[*].arn
}

output "template_name" {
  description = "The name of the launch template"
  value       = aws_launch_template.launch_template[*].name
}

output "launch_template_id" {
  description = "The ID of the launch template"
  value       = aws_launch_template.launch_template[*].id
}
