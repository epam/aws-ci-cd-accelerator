variable "accelerator_account_id" {
  description = "The AWS account ID for the accelerator"
  type        = string
}

variable "allowed_users" {
  description = "A list of allowed user ARNs permitted to assume the role"
  type        = list(string)
  default     = []
}
