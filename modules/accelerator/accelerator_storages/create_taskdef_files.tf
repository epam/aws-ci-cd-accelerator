#======================= Task Definitions for all stages for Codedeploy =======================#

locals {
  stage_env_region_pairs = flatten([
    for env, stage_data in var.stages : [
      for region in stage_data.regions : {
        environment = env
        region      = region
        account     = stage_data.account
      }
    ]
  ])

}


data "template_file" "taskdef" {
  for_each = {
    for pair in local.stage_env_region_pairs : "${pair.environment}-${pair.region}" => pair if var.target_type == "ip"
  }
  template = replace(file("${path.module}/storage_bucket_files/task_definition_for_codedeploy.json"), "\"$${TARGET_PORT}\"", "$${TARGET_PORT}")

  vars = {
    ACCOUNT_ID         = each.value.account
    CPU                = var.cpu
    MEMORY             = var.memory
    ENV                = each.value.environment
    EXECUTION_ROLE_ARN = "arn:aws:iam::${each.value.account}:role/Ecs-Execution-${var.repo_name}-${each.value.region}"
    TASK_ROLE_ARN      = "arn:aws:iam::${each.value.account}:role/Ecs-Task-${var.repo_name}-${each.value.region}"
    LOGS_GROUP         = "${var.repo_name}-ecs-${each.value.environment}"
    REGION             = each.value.region
    TARGET_PORT        = var.application_port
    FAMILY             = "${var.repo_name}-ecs-${each.value.environment}"
    CONTAINER_NAME     = var.container_name
    ENV_VARS           = jsonencode(try(var.env_vars[each.value.environment], []))
    SECRETS            = jsonencode(try(var.secrets[each.value.environment], []))
  }
}
resource "aws_s3_object" "taskdef" {
  for_each = {
    for pair in local.stage_env_region_pairs : "${pair.environment}-${pair.region}" => pair if var.target_type == "ip"
  }

  bucket                 = module.s3_bucket_service[0].s3_bucket_id
  key                    = "${var.repo_name}/taskdef_${each.value.environment}-${each.value.region}.json"
  content                = data.template_file.taskdef[each.key].rendered
  kms_key_id             = module.kms.key_arn
  server_side_encryption = "aws:kms"
  force_destroy          = true
}
