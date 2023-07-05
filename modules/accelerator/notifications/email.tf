resource "aws_sns_topic" "notif" {
  name = "${var.repo_name}-${var.region_name}-pipeline-notification"
  display_name  = var.display_name
  kms_master_key_id = var.aws_kms_key
}

resource "aws_sns_topic_subscription" "email" {
  count = length(var.email_addresses)
  topic_arn = aws_sns_topic.notif.arn
  protocol  = "email"
  endpoint  = var.email_addresses[count.index]
}

resource "aws_sns_topic_subscription" "msTeams_lambda" {
  endpoint  = aws_lambda_function.this.arn
  protocol  = "lambda"
  topic_arn = aws_sns_topic.notif.arn
}