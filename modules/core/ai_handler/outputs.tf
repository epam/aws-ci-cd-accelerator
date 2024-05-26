output "function_url" {
  description = "Lambda function to be triggered if PR Comment is updated"
  value       = aws_lambda_function_url.webhook_url[*].function_url
}
