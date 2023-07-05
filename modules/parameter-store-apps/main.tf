#========== Parameter Store Variables for Applications ==============================#

resource "aws_ssm_parameter" "any" {
  count       = length(var.parameter_store)
  name        = var.parameter_store[count.index].parameter_name
  description = var.parameter_store[count.index].description
  type        = "SecureString"
  value       = var.parameter_store[count.index].parameter_value
  overwrite   = var.parameter_store[count.index].overwrite
  tier        = var.parameter_store[count.index].tier
}



