#======================= The template directory module for ci/cd ===========================#
resource "template_dir" "ci_cd" {
  destination_dir = "${var.root_directory}/accelerator/accounts/${var.aws_account_id}/regions/${var.region}/applications/${var.repo_name}"
  source_dir      = "${var.root_directory}/../modules/core/template_module/templates/ci-cd-dirrectory"
  vars = {
    repo_name = var.repo_name
  }
}
