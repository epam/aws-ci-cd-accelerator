#=======================  The Lambda function for AI handler =======================#
data "archive_file" "this" {
  type        = "zip"
  source_file = "${path.module}/lambda_function.py"
  output_path = "${path.module}/lambda_function.zip"
}

resource "aws_iam_role" "lambda_role" {
  name = "ai-handler-lambda-${var.repo_name}-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy" "ssm_parameter_policy" {
  name        = "SSMParameterReadPolicy-${var.repo_name}-${var.region_name}"
  description = "Policy for reading parameters from SSM Parameter Store"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "ssm:GetParameters",
          "ssm:GetParameter",
          "ssm:GetParametersByPath",
          "ssm:DescribeParameters"
        ],
        Effect   = "Allow",
        Resource = "arn:aws:ssm:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:parameter/*",
      },
    ],
  })
}

resource "aws_iam_role_policy_attachment" "ssm_parameter_policy_attachment" {
  policy_arn = aws_iam_policy.ssm_parameter_policy.arn
  role       = aws_iam_role.lambda_role.name
}

resource "aws_iam_role_policy_attachment" "basic_lambda_policy" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role       = aws_iam_role.lambda_role.name
  depends_on = [aws_iam_role.lambda_role]
}

resource "aws_iam_role_policy_attachment" "codebuild_lambda_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeBuildAdminAccess"
  role       = aws_iam_role.lambda_role.name
}

resource "aws_lambda_function" "this" {
  filename      = data.archive_file.this.output_path
  function_name = "lambda_ai_handler_${var.repo_name}_codebuild_trigger"
  layers        = [aws_lambda_layer_version.request.arn]
  role          = aws_iam_role.lambda_role.arn
  handler       = "lambda_function.lambda_handler"
  timeout       = 60

  runtime = "python3.11"

  environment {
    variables = {
      DEBUG             = "false"
      GITHUB_TOKEN_NAME = var.git_token_name
      CODEBUILD         = aws_codebuild_project.ai_handler.name
    }
  }

  depends_on = [data.archive_file.this, aws_iam_role.lambda_role]
}

resource "aws_lambda_layer_version" "request" {
  filename   = "${path.module}/python.zip"
  layer_name = "request"
}

resource "aws_lambda_function_url" "webhook_url" {
  function_name      = aws_lambda_function.this.function_name
  authorization_type = "NONE"
}
