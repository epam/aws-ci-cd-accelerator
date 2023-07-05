##=========================== EC2 ========================
output "target_group_name" {
  value = var.target_type == "instance" ? aws_lb_target_group.group.*.name : null
}
output "target_group_arn" {
  value = var.target_type == "instance" ? aws_lb_target_group.group.*.arn : null
}
##================== ECS ===================================
output "target_group_blue_name" {
  value = var.target_type == "ip" ? aws_lb_target_group.blue_group.*.name : null
}
output "target_group_green_name" {
  value = var.target_type == "ip" ? aws_lb_target_group.green_group.*.name : null
}
output "target_group_blue_arn" {
  value = var.target_type == "ip" ? aws_lb_target_group.blue_group.*.arn : null
}
output "target_group_green_arn" {
  value = var.target_type == "ip" ? aws_lb_target_group.green_group.*.arn : null
}
output "app_fqdn" {
  value = aws_route53_record.record.*.fqdn
}

output "alb_id" {
  value = aws_lb.app.id
}
output "alb_name" {
  value = aws_lb.app.name
}
output "main_listener" {
  value = aws_lb_listener.https.arn
}