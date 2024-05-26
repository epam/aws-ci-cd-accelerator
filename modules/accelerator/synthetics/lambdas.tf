#======================= The Lambda functions for Canary =======================#
resource "aws_sqs_queue" "dlq_1" {
  name = "start_canary_${var.repo_name}-dlq"
}
resource "aws_sqs_queue" "dlq_2" {
  name = "check_canary_status_${var.repo_name}-dlq"
}
resource "aws_sqs_queue" "dlq_3" {
  name = "get_canary_results_${var.repo_name}-dlq"
}

module "start_canary_lambda" {
  source                 = "terraform-aws-modules/lambda/aws"
  version                = "6.0.0"
  description            = "Start canary lambda function"
  function_name          = "start_canary_${var.repo_name}"
  handler                = "start_canary.lambda_handler"
  runtime                = "python3.11"
  create_role            = false
  lambda_role            = aws_iam_role.lambda_role.arn
  source_path            = "${path.module}/functions/start_canary.py"
  build_in_docker        = true
  create_function        = true
  publish                = true
  dead_letter_target_arn = aws_sqs_queue.dlq_1.arn
  environment_variables = {
    CANARY_NAME = aws_synthetics_canary.this.name
  }
  tracing_mode           = "Active"
  vpc_subnet_ids         = var.subnet_ids
  vpc_security_group_ids = var.security_groups
}

module "check_canary_status_lambda" {
  source                 = "terraform-aws-modules/lambda/aws"
  version                = "6.0.0"
  description            = "Check canary status lambda function"
  function_name          = "check_canary_status_${var.repo_name}"
  handler                = "check_canary_status.lambda_handler"
  runtime                = "python3.11"
  create_role            = false
  lambda_role            = aws_iam_role.lambda_role.arn
  source_path            = "${path.module}/functions/check_canary_status.py"
  build_in_docker        = true
  create_function        = true
  publish                = true
  dead_letter_target_arn = aws_sqs_queue.dlq_2.arn
  environment_variables = {
    CANARY_NAME = aws_synthetics_canary.this.name
  }
  tracing_mode           = "Active"
  vpc_subnet_ids         = var.subnet_ids
  vpc_security_group_ids = var.security_groups
}

module "get_canary_results_lambda" {
  source                 = "terraform-aws-modules/lambda/aws"
  version                = "6.0.0"
  description            = "Get canary results lambda function"
  function_name          = "get_canary_results_${var.repo_name}"
  handler                = "get_canary_results.lambda_handler"
  runtime                = "python3.11"
  create_role            = false
  lambda_role            = aws_iam_role.lambda_role.arn
  source_path            = "${path.module}/functions/get_canary_results.py"
  build_in_docker        = true
  create_function        = true
  publish                = true
  dead_letter_target_arn = aws_sqs_queue.dlq_3.arn
  environment_variables = {
    CANARY_NAME       = aws_synthetics_canary.this.name
    SUCCESS_THRESHOLD = "100"
  }
  tracing_mode           = "Active"
  vpc_subnet_ids         = var.subnet_ids
  vpc_security_group_ids = var.security_groups
}
