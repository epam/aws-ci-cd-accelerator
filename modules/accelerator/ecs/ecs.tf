resource "aws_ecs_cluster" "ecs_cluster" {
  name               = "${var.repo_name}-${var.region_name}-ecs"
  setting {
    name  = "containerInsights"
    value = "enabled"
  }
  configuration {
    execute_command_configuration {
      kms_key_id = var.aws_kms_key
      logging = "OVERRIDE"

      log_configuration {
        cloud_watch_encryption_enabled = true
        cloud_watch_log_group_name     = aws_cloudwatch_log_group.logs_group.name
      }
    }
  }
}
resource "aws_ecs_cluster_capacity_providers" "example" {
  cluster_name = aws_ecs_cluster.ecs_cluster.name

  capacity_providers = ["FARGATE"]
}
resource "aws_cloudwatch_log_group" "logs_group" {
  name              = "${var.repo_name}-${var.region_name}-ecs"
  retention_in_days = 7
  kms_key_id        = var.aws_kms_key_arn
}
resource "aws_ecs_service" "app_ecs_service" {
  count           = length(var.environments)
  name            = "${var.repo_name}-${var.region_name}-ecs-${var.environments[count.index]}"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.ecs-task-definition[count.index].arn
  desired_count   = var.desired_capacity[count.index]
  launch_type     = "FARGATE"
  deployment_controller {
    type = "CODE_DEPLOY"
  }
  network_configuration {
    security_groups  = var.security_groups
    subnets          = var.private_subnet_ids
    assign_public_ip = false
  }
  load_balancer {
    container_name   = var.container_name
    container_port   = var.docker_container_port
    target_group_arn = var.target_group_blue_arn[count.index]
  }
  lifecycle {
    ignore_changes = [
      load_balancer,
      desired_count,
      task_definition
    ]
  }
}
# Task Definition for application to create initial infrastructure
data "template_file" "ecs_task_definition_template" {
  count    = length(var.environments)
  template = replace(file("${path.module}/task_definition_default.json"), "\"$${target_port}\"", "$${target_port}")
  vars     = {
    container_name       = var.container_name
    task_definition_name = "${var.repo_name}-${var.region_name}-ecs"
    region               = var.region
    logs_group           = aws_cloudwatch_log_group.logs_group.id
    env                  = var.environments[count.index]
    target_port          = var.docker_container_port
    image                = "${var.aws_account_id}.dkr.ecr.${var.region}.amazonaws.com/${aws_ecr_repository.ecr-repo.name}:latest"
  }
}

resource "aws_ecs_task_definition" "ecs-task-definition" {
  count                    = length(var.environments)
  container_definitions    = data.template_file.ecs_task_definition_template[count.index].rendered
  family                   = "${var.repo_name}-${var.region_name}-ecs-${var.environments[count.index]}"
  cpu                      = var.cpu
  memory                   = var.memory
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  execution_role_arn       = var.execution_role
  task_role_arn            = var.task_role
}