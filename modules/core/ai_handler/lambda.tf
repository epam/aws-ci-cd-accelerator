#======================= The Lambda function for AI handler for GitHub & Bitbucket =======================#
# create zip file from requirements.txt. Triggers only when the file is updated
resource "null_resource" "lambda_layer" {
  triggers = {
    requirements = filesha1("${local.layer_path}/requirements.txt")
  }
  # the command to install python and dependencies to the machine and zips
  provisioner "local-exec" {
    command = <<EOT
      docker run -v ${local.layer_path}:/var/task "public.ecr.aws/sam/build-python3.11" /bin/sh -c "pip install -r requirements.txt -t python/lib/python3.11/site-packages/"
      cd ${local.layer_path}
      zip -r python.zip python
    EOT
  }
}

resource "aws_s3_object" "layer" {
  bucket = local.storage_bucket
  key    = "ai_handler/lambda_layers/python.zip"
  source = "${local.layer_path}/python.zip"
  #  etag          = filemd5("${local.layer_path}/python.zip")
  force_destroy = true
  depends_on    = [null_resource.lambda_layer]
}

resource "aws_lambda_layer_version" "request" {
  #  filename   = "${path.module}/functions/python.zip"
  s3_bucket  = local.storage_bucket
  s3_key     = "ai_handler/lambda_layers/python.zip"
  layer_name = "request"
  depends_on = [null_resource.lambda_layer, aws_s3_object.layer]
}

resource "aws_s3_bucket_notification" "bucket_notification" {
  count  = length(var.repo_names)
  bucket = local.storage_bucket

  lambda_function {
    lambda_function_arn = var.vcs == "gitlab" ? module.ai_lambda_gitlab[count.index].lambda_function_arn : module.ai_lambda[count.index].lambda_function_arn
    events              = ["s3:ObjectCreated:*"]
    filter_prefix       = var.repo_names[count.index]
    filter_suffix       = "error.log"
  }

  depends_on = [
    aws_lambda_permission.allow_bucket,
  ]
}

resource "aws_lambda_function_url" "webhook_url" {
  count              = length(var.repo_names)
  function_name      = var.vcs == "gitlab" ? module.process_comment_lambda_gitlab[count.index].lambda_function_arn : module.process_comment_lambda[count.index].lambda_function_name
  authorization_type = "NONE"
}

resource "aws_lambda_permission" "allow_bucket" {
  count         = length(var.repo_names)
  statement_id  = "AllowS3BucketToInvoke"
  action        = "lambda:InvokeFunction"
  function_name = var.vcs == "gitlab" ? module.ai_lambda_gitlab[count.index].lambda_function_arn : module.ai_lambda[count.index].lambda_function_arn
  principal     = "s3.amazonaws.com"
  source_arn    = "arn:aws:s3:::${local.storage_bucket}"
}

module "ai_lambda" {
  count           = var.vcs == "bitbucket" || var.vcs == "github" ? length(var.repo_names) : 0
  source          = "terraform-aws-modules/lambda/aws"
  version         = "6.0.0"
  description     = "AI Handler to process Terraform Errors"
  function_name   = "AI-Handler-TF-Error-${var.repo_names[count.index]}-${var.region_name}"
  handler         = "github_lambda_function.lambda_handler"
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
    GIT_USER       = var.git_user
    GIT_TOKEN_NAME = var.git_token_name
    GIT_HOSTNAME   = var.git_hostname
    CODEBUILD_NAME = aws_codebuild_project.ai_handler[count.index].name
  }
  tracing_mode           = "Active"
  vpc_subnet_ids         = var.private_subnet_ids
  vpc_security_group_ids = var.security_groups
  #  attach_network_policy  = true
}

module "process_comment_lambda" {
  count           = var.vcs == "bitbucket" || var.vcs == "github" ? length(var.repo_names) : 0
  source          = "terraform-aws-modules/lambda/aws"
  version         = "6.0.0"
  description     = "AI Handler to process Git PR Comments"
  function_name   = "AI-Handler-Comment-${var.repo_names[count.index]}-${var.region_name}"
  handler         = "github_comment_lambda_function.lambda_handler"
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
    REPO_NAME      = var.repo_names[count.index]
    REPO_OWNER     = var.git_owner
    GIT_USER       = var.git_user
    GIT_TOKEN_NAME = var.git_token_name
    GIT_HOSTNAME   = var.git_hostname
    CODEBUILD_NAME = aws_codebuild_project.comment_handler[count.index].name
  }
  tracing_mode           = "Active"
  vpc_subnet_ids         = var.private_subnet_ids
  vpc_security_group_ids = var.security_groups
  #  attach_network_policy  = true
}
