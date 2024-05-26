#======================= Replication for ci/cd directory ===========================#
locals {
  replica_regions = [for region in distinct(flatten(local.stage_regions)) : region if region != var.region]
}

data "template_file" "replica" {
  template = templatefile("${path.module}/templates/replicas.tmpl", {
    dest_regions = local.replica_regions
  })
}

resource "local_file" "replica" {
  count    = length(local.replica_regions) > 0 ? 1 : 0
  filename = "${var.root_directory}/../modules/accelerator/main-module/replicas_${var.repo_name}.tf"
  content  = data.template_file.replica.rendered
}
