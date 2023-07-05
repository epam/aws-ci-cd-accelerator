variable "parameter_store" {
  type = list(object({
    parameter_name  = string
    parameter_value = string
    tier            = string
    overwrite       = bool
    description     = string
  }))
}