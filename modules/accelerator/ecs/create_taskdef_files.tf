##============= Task Definitions for every stage for in Codedeploy usage ============================##

data "template_file" "taskdef" {
  count    = length(var.environments)
  template = replace(file("${path.module}/task_definition_for_codedeploy.json"), "\"$${target_port}\"", "$${target_port}")
  vars     = {
    cpu            = var.cpu
    memory         = var.memory
    region_name    = var.region_name
    repo_name      = var.repo_name
    env            = var.environments[count.index]
    execution_role = var.execution_role
    logs_group     = aws_cloudwatch_log_group.logs_group.name
    region         = var.region
    target_port    = var.docker_container_port
    family         = aws_ecs_service.app_ecs_service[count.index].name
    container_name = var.container_name
  }
}

resource "aws_s3_object" "taskdef" {
  count         = length(var.environments)
  bucket        = var.storage_bucket
  key           = "${aws_ecr_repository.ecr-repo.name}/taskdef_${var.environments[count.index]}.json"
  content       = data.template_file.taskdef[count.index].rendered
  etag          = md5(data.template_file.taskdef[count.index].rendered)
  force_destroy = true
}