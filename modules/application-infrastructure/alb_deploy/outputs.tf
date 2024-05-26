##========================== EC2  ==========================##
output "target_group_names" {
  description = "The names of the target groups for instances"
  value       = var.target_type == "instance" ? aws_lb_target_group.group[*].name : null
}
output "target_group_arns" {
  description = "The ARNs of the target groups for instances"
  value       = var.target_type == "instance" ? aws_lb_target_group.group[*].arn : null
}
## ========================== ECS  ==========================##
output "target_group_blue_names" {
  description = "The names of the target blue groups for IPs"
  value       = var.target_type == "ip" ? aws_lb_target_group.blue_group[*].name : null
}
output "target_group_green_names" {
  description = "The names of the target green groups for IPs"
  value       = var.target_type == "ip" ? aws_lb_target_group.green_group[*].name : null
}
output "target_group_blue_arns" {
  description = "The ARNs of the target blue groups for IPs"
  value       = var.target_type == "ip" ? aws_lb_target_group.blue_group[*].arn : null
}
output "target_group_green_arns" {
  description = "The ARNs of the target green groups for IPs"
  value       = var.target_type == "ip" ? aws_lb_target_group.green_group[*].arn : null
}
output "app_fqdn" {
  description = "The fully qualified domain name of the app"
  value       = aws_route53_record.main_record[*].fqdn
}

output "alb_id" {
  description = "The id of the application load balancer"
  value       = aws_lb.app.id
}
output "alb_name" {
  description = "The name of the application load balancer"
  value       = aws_lb.app.name
}
output "main_listener" {
  description = "The ARN of the main listener"
  value       = aws_lb_listener.https.arn
}
output "security_group_https" {
  description = "The security group id for HTTPS"
  value       = module.security_group_https.security_group_id
}
output "security_group_http" {
  description = "The security group id for HTTP"
  value       = module.security_group_http.security_group_id
}
output "security_group_self_port" {
  description = "The security group id for self port"
  value       = module.security_group_self_port.security_group_id
}
