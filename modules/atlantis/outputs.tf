output "atlantis_url" {
  description = "URL of Atlantis"
  value       = module.atlantis.atlantis_url
}

output "atlantis_url_events" {
  description = "Webhook events URL of Atlantis"
  value       = module.atlantis.atlantis_url_events
}

#output "atlantis_allowed_repo_names" {
#  description = "Git repositories where webhook should be created"
#  value       = module.atlantis.atlantis_allowed_repo_names
#}

output "task_role_arn" {
  description = "The Atlantis ECS task role arn"
  value       = module.atlantis.task_role_arn
}

output "vpc_id" {
  description = "ID of the VPC that was created or passed in"
  value       = module.atlantis.vpc_id
}

output "webhook_secret" {
  description = "Webhook secret"
  value       = module.atlantis.webhook_secret
  sensitive = true
}

output "alb_dns_name" {
  description = "Dns name of alb"
  value       = module.atlantis.alb_dns_name
}

output "alb_zone_id" {
  description = "Zone ID of alb"
  value       = module.atlantis.alb_zone_id
}

output "ecs_task_definition" {
  description = "Task definition for ECS service (used for external triggers)"
  value       = module.atlantis.ecs_task_definition
}

output "ecs_security_group" {
  description = "Security group assigned to ECS Service in network configuration"
  value       = module.atlantis.ecs_security_group
}