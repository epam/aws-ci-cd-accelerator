output "c7n_role_arn" {
  description = "Read only role for C7n utility run"
  value       = aws_iam_role.read_only_access.arn
}
