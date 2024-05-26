variable "secrets_manager" {
  description = "List of additional AWS Parameter Store configurations"
  type = list(object({
    secret_name          = string
    secret_description   = string
    secret_recovery_days = string
    secret_value         = string
  }))
}
