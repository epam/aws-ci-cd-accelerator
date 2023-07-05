data "archive_file" "this" {
  type        = "zip"
  source_file = "${path.module}/${var.lambda_file}"
  output_path = "${path.module}/${var.lambda_zip_file}"
}


resource "aws_lambda_function" "this" {
  filename      = "${path.module}/${var.lambda_zip_file}"
  function_name = "${var.repo_name}-${var.region_name}-lambda_msTeams"
  role          = aws_iam_role.lambda.arn
  handler       = "notification_lambda.lambda_handler"

  #  source_code_hash = filebase64sha256("${path.module}/${var.lambda_zip_file}")

  runtime = "python3.8"

  environment {
    variables = {
      DEBUG          = "false"
      TEAMS_HOOK_URL = var.teams_web_hook
      SLACK_HOOK_URL = var.slack_web_hook
    }
  }
  vpc_config {
    security_group_ids = var.security_groups
    subnet_ids         = var.private_subnet_ids
  }
  depends_on = [
    data.archive_file.this
  ]
}
resource "aws_lambda_permission" "with_sns" {
  statement_id  = "AllowExecutionFromSNS"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.this.arn
  principal     = "sns.amazonaws.com"
  source_arn    = aws_sns_topic.notif.arn
}