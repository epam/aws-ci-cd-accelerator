#======================= Lambda function for notifications =======================#
data "archive_file" "this" {
  type        = "zip"
  source_file = "${path.module}/${var.lambda_file}"
  output_path = "${path.module}/${var.lambda_zip_file}"
}
resource "aws_sqs_queue" "dlq" {
  name = "${var.repo_name}-lambda_msTeams-dlq"
}

resource "aws_lambda_function" "this" {
  filename      = "${path.module}/${var.lambda_zip_file}"
  function_name = "${var.repo_name}-lambda_msTeams"
  role          = aws_iam_role.lambda.arn
  handler       = "notification_lambda.lambda_handler"
  dead_letter_config {
    target_arn = aws_sqs_queue.dlq.arn
  }
  source_code_hash = data.archive_file.this.output_base64sha256

  runtime = "python3.11"

  environment {
    variables = {
      DEBUG     = "false"
      REPO_NAME = var.repo_name
    }
  }
  tracing_config {
    mode = "Active"
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
