output "api" {
  description = "The API endpoint created by the CloudFormation stack"
  value       = aws_cloudformation_stack.dlt_test.outputs.DLTApiEndpointD98B09AC
}

output "console" {
  description = "The console created by the CloudFormation stack"
  value       = aws_cloudformation_stack.dlt_test.outputs.Console
}

output "solution_uuid" {
  description = "The solution UUID created by the CloudFormation stack"
  value       = aws_cloudformation_stack.dlt_test.outputs.SolutionUUID
}

output "cognito_user_pool_id" {
  description = "The Cognito User Pool ID created by the CloudFormation stack"
  value       = aws_cloudformation_stack.dlt_test.outputs.UserPoolId
}

output "cognito_client_id" {
  description = "The Cognito Client ID created by the CloudFormation stack"
  value       = aws_cloudformation_stack.dlt_test.outputs.ClientId
}

output "cognito_identity_pool_id" {
  description = "The Cognito Identity Pool ID created by the CloudFormation stack"
  value       = aws_cloudformation_stack.dlt_test.outputs.IdentityPoolId
}

output "dlt_fqdn" {
  description = "The fully qualified domain name (FQDN) created for DLT WEB UI"
  value       = aws_route53_record.record.fqdn
}
