#======================= KMS for encryption =======================#
module "kms" {
  source                  = "terraform-aws-modules/kms/aws"
  version                 = "2.1.0"
  description             = "KMS Key for ${var.repo_name} ECS log group"
  deletion_window_in_days = 7
  enable_key_rotation     = true
  is_enabled              = true
  key_usage               = "ENCRYPT_DECRYPT"
  multi_region            = false

  # Policy
  enable_default_policy = true
  #  key_owners                             = ["arn:aws:iam::012345678901:role/owner"]
  #  key_administrators                     = ["arn:aws:iam::012345678901:role/admin"]
  key_users         = var.key_users
  key_service_users = var.key_service_users
  key_statements = [
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
    }
  ]

  # Aliases
  aliases = ["${var.repo_name}-${var.region}-logs-key"] # accepts static strings only

}
