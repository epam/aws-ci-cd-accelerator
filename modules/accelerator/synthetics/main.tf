#======================= AWS Synthetics Canary =======================#
data "archive_file" "canary" {
  type        = "zip"
  source_dir  = "${path.module}/functions/canary/"
  output_path = "${path.module}/functions/${var.repo_name}.zip"
}

resource "aws_synthetics_canary" "this" {
  name                 = "${var.repo_name}-test"
  artifact_s3_location = "s3://${module.s3_bucket.s3_bucket_id}/"
  execution_role_arn   = aws_iam_role.canary_role.arn
  handler              = "index.handler"
  zip_file             = data.archive_file.canary.output_path
  runtime_version      = "syn-nodejs-puppeteer-5.1"

  schedule {
    expression = "rate(0 minute)" # Can be adjusted to the desired schedule
  }
  start_canary  = false
  delete_lambda = true
  vpc_config {
    subnet_ids         = var.subnet_ids
    security_group_ids = var.security_groups
  }
  run_config {
    timeout_in_seconds = 120
  }

  failure_retention_period = 7
  success_retention_period = 7
}
