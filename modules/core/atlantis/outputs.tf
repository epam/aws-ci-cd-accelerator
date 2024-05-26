output "atlantis_url" {
  description = "URL of Atlantis"
  value       = module.atlantis.url
}

output "atlantis_url_events" {
  description = "Webhook url for Atlantis"
  value       = "${module.atlantis.url}/events"
}

output "webhook_secret" {
  description = "Webhook secret"
  value       = random_password.webhook_secret.result
  sensitive   = true
}

output "tasks_iam_role_name" {
  description = "IAM role name for tasks"
  value       = module.atlantis.service["tasks_iam_role_arn"]
}

output "atlantis_security_group_http" {
  description = "Security Group for Atlantis-Git Connection HTTP"
  value       = module.security_group_http.security_group_id
}

output "atlantis_security_group_https" {
  description = "Security Group for Atlantis-Git Connection HTTPS"
  value       = module.security_group_https.security_group_id
}
