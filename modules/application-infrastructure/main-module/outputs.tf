output "asg_name" {
  description = "The name of the Auto Scaling Group"
  value       = var.target_type == "instance" ? module.asg[0].asg_name : null
}

output "asg_arn" {
  description = "The Amazon Resource Name (ARN) of the Auto Scaling Group"
  value       = var.target_type == "instance" ? module.asg[0].asg_arn : null
}

output "lt_id" {
  description = "The ID of the Launch Template associated with the Auto Scaling Group"
  value       = var.target_type == "instance" ? module.asg[0].launch_template_id : null
}

output "template_name" {
  description = "The name of the Launch Template used by the Auto Scaling Group"
  value       = var.target_type == "instance" ? module.asg[0].template_name : null
}

output "app_fqdn" {
  description = "The fully qualified domain name of the Application Load Balancer"
  value       = module.alb.app_fqdn
}

output "target_group_name" {
  description = "The name of the default target group for the Application Load Balancer"
  value       = module.alb.target_group_names
}

output "main_listener" {
  description = "The main listener for the Application Load Balancer"
  value       = module.alb.main_listener
}

output "target_group_green_name" {
  description = "The name of the green target group for the blue-green deployment"
  value       = module.alb.target_group_green_names
}

output "target_group_blue_name" {
  description = "The name of the blue target group for the blue-green deployment"
  value       = module.alb.target_group_blue_names
}

output "ecs_cluster_name" {
  description = "The name of the ECS Cluster"
  value       = var.target_type == "ip" ? module.ecs[0].cluster_name : null
}

output "ecs_service_name" {
  description = "The name of the ECS Service"
  value       = var.target_type == "ip" ? module.ecs[0].service_name : null
}

output "ecs_execution_role_arn" {
  description = "The ARN of the ECS Execution Role"
  value       = var.target_type == "ip" ? module.ecs[0].ecs_execution_role_arn : null
}

output "ecs_task_role_arn" {
  description = "The ARN of the ECS Task Role"
  value       = var.target_type == "ip" ? module.ecs[0].ecs_task_role_arn : null
}

output "application_name" {
  description = "The name of the CodeDeploy application"
  value       = module.codedeploy.application_name
}

output "deployment_group_name" {
  description = "The name of the deployment group used for deploying the application"
  value       = var.target_type == "instance" ? module.codedeploy.deployment_group_name_ec2 : module.codedeploy.deployment_group_name_ecs
}

output "nat_public_ips" {
  description = "The public IPs of the NAT gateways in the VPC"
  value       = var.vpc_create ? module.vpc[0].nat_public_ips : null
}

output "https_security_groups" {
  description = "The security groups associated with HTTPS traffic for the Application Load Balancer"
  value       = module.alb.security_group_https
}

output "http_security_groups" {
  description = "The security groups associated with HTTP traffic for the Application Load Balancer"
  value       = module.alb.security_group_http
}

output "vpc_nat_security_group" {
  description = "The security group associated with the NAT gateways in the VPC"
  value       = var.vpc_create ? module.vpc[0].vpc_nat_security_group : null
}
