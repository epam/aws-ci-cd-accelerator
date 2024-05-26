#======================= The Lambda function for AI handler for GitLab =======================#
module "ai_lambda_gitlab" {
  count           = var.vcs == "gitlab" ? length(var.repo_names) : 0
  source          = "terraform-aws-modules/lambda/aws"
  version         = "6.0.0"
  description     = "AI Handler to process Terraform Errors"
  function_name   = "AI-Handler-Error-${var.repo_names[count.index]}-${var.region_name}"
  handler         = "gitlab_lambda_function.lambda_handler"
  runtime         = "python3.11"
  timeout         = 10
  create_role     = false
  lambda_role     = aws_iam_role.lambda_exec_role[count.index].arn
  source_path     = "${path.module}/functions/${var.vcs}_lambda_function.py"
  layers          = [aws_lambda_layer_version.request.arn]
  build_in_docker = true
  create_function = true
  publish         = true
  #  dead_letter_target_arn = aws_sqs_queue.dlq_1.arn
  environment_variables = {
    BUCKET_NAME    = local.storage_bucket
    OBJECT_KEY     = "${var.repo_names[count.index]}/error.log"
    REPO_NAME      = var.repo_names[count.index]
    REPO_OWNER     = var.git_owner
    PROJECT_ID     = var.project_ids[count.index]
    GIT_TOKEN_NAME = var.git_token_name
    GIT_HOSTNAME   = var.git_hostname
    CODEBUILD_NAME = aws_codebuild_project.ai_handler_gitlab[count.index].name
  }
  tracing_mode           = "Active"
  vpc_subnet_ids         = var.private_subnet_ids
  vpc_security_group_ids = var.security_groups
  #  attach_network_policy  = true
}

module "process_comment_lambda_gitlab" {
  count           = var.vcs == "gitlab" ? length(var.repo_names) : 0
  source          = "terraform-aws-modules/lambda/aws"
  version         = "6.0.0"
  description     = "AI Handler to process Git PR Comments"
  function_name   = "AI-Handler-Comment-${var.repo_names[count.index]}-${var.region_name}"
  handler         = "gitlab_comment_lambda_function.lambda_handler"
  runtime         = "python3.11"
  timeout         = 10
  create_role     = false
  lambda_role     = aws_iam_role.lambda_exec_role[count.index].arn
  source_path     = "${path.module}/functions/${var.vcs}_comment_lambda_function.py"
  layers          = [aws_lambda_layer_version.request.arn]
  build_in_docker = true
  create_function = true
  publish         = true
  #  dead_letter_target_arn = aws_sqs_queue.dlq_1.arn
  environment_variables = {
    REPO_OWNER     = var.git_owner
    PROJECT_ID     = var.project_ids[count.index]
    GIT_TOKEN_NAME = var.git_token_name
    GIT_HOSTNAME   = var.git_hostname
    CODEBUILD_NAME = aws_codebuild_project.comment_handler_gitlab[count.index].name
  }
  tracing_mode           = "Active"
  vpc_subnet_ids         = var.private_subnet_ids
  vpc_security_group_ids = var.security_groups
  #  attach_network_policy  = true
}
