#======================= KMS for encryption =======================#
data "aws_caller_identity" "current" {}

module "kms" {
  source                  = "terraform-aws-modules/kms/aws"
  version                 = "2.1.0"
  description             = "Primery key for ${var.repo_name}"
  deletion_window_in_days = 7
  enable_key_rotation     = true
  is_enabled              = true
  key_usage               = "ENCRYPT_DECRYPT"
  multi_region            = true

  # Policy
  enable_default_policy = true

  key_service_users = var.key_service_users
  key_statements = [
    {
      sid = "EventBridge"
      actions = [
        "kms:Decrypt*",
        "kms:GenerateDataKey*"
      ]
      resources = ["*"]

      principals = [
        {
          type        = "Service"
          identifiers = ["events.amazonaws.com"]
        }
      ]
    },
    {
      sid = "CloudWatchLogs"
      actions = [
        "kms:Encrypt*",
        "kms:Decrypt*",
        "kms:ReEncrypt*",
        "kms:GenerateDataKey*",
        "kms:Describe*"
      ]
      resources = ["*"]

      principals = [
        {
          type        = "Service"
          identifiers = ["logs.${var.region}.amazonaws.com"]
        }
      ]

      conditions = [
        {
          test     = "ArnLike"
          variable = "kms:EncryptionContext:aws:logs:arn"
          values = [
            "arn:aws:logs:*:*:log-group:*",
          ]
        }
      ]
    },
    {
      sid = "PipelineRoles"
      actions = [
        "kms:Encrypt*",
        "kms:Decrypt*",
        "kms:ReEncrypt*",
        "kms:GenerateDataKey*",
        "kms:Describe*"
      ]
      resources = ["*"]

      principals = [
        {
          type        = "AWS"
          identifiers = ["arn:aws:iam::${var.aws_account_id}:root"]
        }
      ]

      conditions = [
        {
          test = "StringLike"
          values = [
            "arn:aws:iam::${var.aws_account_id}:role/Codebuild-${var.repo_name}*",
            "arn:aws:iam::${var.aws_account_id}:role/Codepipeline-${var.repo_name}*"
          ]
          variable = "aws:PrincipalArn"
        }
      ]
    },
    {
      sid = "DeployRoles"
      actions = [
        "kms:Encrypt*",
        "kms:Decrypt*",
        "kms:ReEncrypt*",
        "kms:GenerateDataKey*",
        "kms:Describe*"
      ]
      resources = ["*"]

      principals = [
        {
          type        = "AWS"
          identifiers = [for k in var.account_identifiers : "arn:aws:iam::${k}:root"]
        }
      ]

      conditions = [
        {
          test     = "StringLike"
          values   = var.kms_identifiers
          variable = "aws:PrincipalArn"
        }
      ]
    }
  ]

  # Aliases
  aliases = ["${var.repo_name}-${var.region}-key"] # accepts static strings only
}
