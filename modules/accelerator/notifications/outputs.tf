output "approve_sns_arn" {
  description = "The ARN of the SNS Topic"
  value       = aws_sns_topic.notif.arn
}
