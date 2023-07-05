output "api" {
  value = aws_cloudformation_stack.dlt_test.outputs.DLTApiEndpointD98B09AC
}

output "console" {
  value = aws_cloudformation_stack.dlt_test.outputs.Console
}

output "solution_uuid" {
  value = aws_cloudformation_stack.dlt_test.outputs.SolutionUUID
}
output "cognito_user_pool_id" {
  value = aws_cloudformation_stack.dlt_test.outputs.UserPoolId
}
output "cognito_client_id" {
  value = aws_cloudformation_stack.dlt_test.outputs.ClientId
}
output "cognito_identity_pool_id" {
  value = aws_cloudformation_stack.dlt_test.outputs.IdentityPoolId
}