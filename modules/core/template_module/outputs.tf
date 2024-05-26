output "ci_cd_directory" {
  value       = template_dir.ci_cd.destination_dir
  description = "The path to the ci/cd directory"
}
