variable "organization_name" {
  type = string
}

variable "email_addresses" {
  description = "Email addresses to send notifications to."
  type = list(string)
}

# CloudTrail
variable "multi_region_trail" {
  description = "Set to true to enable CloudTrail for all regions, false - to enable it only for 1 region."
  type = bool
}
variable "region" {
  type = string
}

variable "force_destroy" {}
variable "versioning" {}