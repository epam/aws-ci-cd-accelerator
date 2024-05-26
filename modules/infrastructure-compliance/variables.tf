variable "project_name" {
  description = "The name of the project"
  type        = string
}

variable "email_addresses" {
  description = "Email addresses to send notifications to."
  type        = list(string)
}

# CloudTrail
variable "multi_region_trail" {
  description = "Set to true to enable CloudTrail for all regions, false - to enable it only for 1 region."
  type        = bool
}
variable "region" {
  description = "The AWS region where the infrastructure will be deployed"
  type        = string
}

variable "force_destroy" {
  description = "Delete bucket when destroy"
  type        = bool
}
variable "versioning" {
  description = "Switch on/off bucket versioning"
  type        = string
  default     = "Enabled"
}
