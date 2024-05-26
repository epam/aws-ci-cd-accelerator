output "account_role_arn" {
  description = "The ARN of the account IAM role"
  value       = aws_iam_role.admin.arn
}
