#======================= Template directory module for CI/CD ===========================#
locals {

  unique_accounts = distinct([for stage in values(var.stages) : stage.account])

  stages_grouped_by_account = {
    for account in local.unique_accounts : account =>
    { for stage, data in var.stages : stage => data if data.account == account }
  }

  environments  = keys(var.stages)
  stage_regions = [for stage in local.environments : var.stages[stage].regions]
  accounts_to_environments = {
    for stage, data in var.stages : stage => data.account
  }

  stage_env_region_pairs = flatten([
    for stage, stage_data in var.stages : [
      for idx, region in stage_data.regions : {
        environment = stage
        region      = region
        account     = stage_data.account
        region_name = stage_data.region_names[idx]
      }
    ]
  ])

  unique_keys       = toset([for pair in local.stage_env_region_pairs : "${pair.environment}-${pair.region}"])
  pair_lookup_table = { for pair in local.stage_env_region_pairs : "${pair.environment}-${pair.region}" => pair... }
}

resource "template_dir" "application_infra" {
  for_each        = var.target_type == "ip" || var.target_type == "instance" ? local.unique_keys : []
  destination_dir = "${var.root_directory}/application-infrastructure/${var.repo_name}/accounts/${local.pair_lookup_table[each.key][0].environment}/regions/${local.pair_lookup_table[each.key][0].region}"
  source_dir      = "${var.root_directory}/../modules/core/template_module/templates/application-infra-dirrectory/example"
  vars = {
    region       = local.pair_lookup_table[each.key][0].region
    region_name  = local.pair_lookup_table[each.key][0].region_name
    repo_name    = var.repo_name
    environments = local.pair_lookup_table[each.key][0].environment
  }
  lifecycle {
    ignore_changes = all
  }
}

data "template_file" "account" {
  for_each = toset(local.environments)
  template = templatefile("${path.module}/templates/account.hcl.tmpl", {
    account_name           = each.key
    aws_account_id         = local.accounts_to_environments[each.key]
    accelerator_account_id = var.aws_account_id
  })
}

resource "local_file" "account" {
  for_each = var.target_type == "ip" || var.target_type == "instance" ? {
    for environment in local.environments : environment =>
    local.stages_grouped_by_account[var.stages[environment].account]
  } : {}
  filename   = "${var.root_directory}/application-infrastructure/${var.repo_name}/accounts/${each.key}/account.hcl"
  content    = data.template_file.account[each.key].rendered
  depends_on = [template_dir.application_infra]
}
