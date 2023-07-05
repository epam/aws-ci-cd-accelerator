output "ecr-repo-name" {
  value = aws_ecr_repository.ecr-repo.name
}

output "service_name" {
  value = aws_ecs_service.app_ecs_service.*.name
}
output "cluster_name" {
  value = aws_ecs_cluster.ecs_cluster.name
}