#======================= SecretsManager Secrets for Applications ===========================#

resource "aws_secretsmanager_secret" "any" {
  count                          = length(var.secrets_manager)
  name                           = var.secrets_manager[count.index]["secret_name"]
  description                    = var.secrets_manager[count.index]["secret_description"]
  recovery_window_in_days        = var.secrets_manager[count.index]["secret_recovery_days"]
  force_overwrite_replica_secret = "true"
}

resource "aws_secretsmanager_secret_version" "any" {
  count         = length(var.secrets_manager)
  secret_id     = aws_secretsmanager_secret.any[count.index].id
  secret_string = var.secrets_manager[count.index]["secret_value"]
}
