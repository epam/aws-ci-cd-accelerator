#======================= Deployment of ECS infrastructure =======================#
resource "aws_ecs_cluster" "ecs_cluster" {
  name = "${var.repo_name}-ecs"
  setting {
    name  = "containerInsights"
    value = "enabled"
  }

}
resource "aws_ecs_cluster_capacity_providers" "example" {
  cluster_name = aws_ecs_cluster.ecs_cluster.name

  capacity_providers = ["FARGATE"]
}
resource "aws_cloudwatch_log_group" "logs_group" {
  count             = length(var.environments)
  name              = "${var.repo_name}-ecs-${var.environments[count.index]}"
  retention_in_days = 7
  kms_key_id        = var.kms_key_arn
}
resource "aws_ecs_service" "app_ecs_service" {
  count           = length(var.environments)
  name            = "${var.repo_name}-ecs-${var.environments[count.index]}"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.ecs_task_definition[count.index].arn
  desired_count   = var.desired_capacity[count.index]
  launch_type     = "FARGATE"
  #  enable_execute_command = true
  deployment_controller {
    type = "CODE_DEPLOY"
  }
  network_configuration {
    security_groups  = var.ecs_security_groups
    subnets          = var.private_subnet_ids
    assign_public_ip = false
  }
  load_balancer {
    container_name   = var.container_name
    container_port   = var.application_port
    target_group_arn = var.target_group_blue_arns[count.index]
  }
  lifecycle {
    ignore_changes = [
      load_balancer,
      task_definition,
      network_configuration
    ]
  }
}
# Task Definition for application to create initial infrastructure
data "template_file" "ecs_task_definition_template" {
  count    = length(var.environments)
  template = replace(file("${path.module}/task_definition_default.json"), "\"$${target_port}\"", "$${target_port}")
  vars = {
    container_name       = var.container_name
    env                  = var.environments[count.index]
    task_definition_name = "${var.repo_name}-ecs"
    region               = var.region
    logs_group           = aws_cloudwatch_log_group.logs_group[count.index].id
    target_port          = var.application_port
    image                = "${var.accelerator_account_id}.dkr.ecr.${var.accelerator_region}.amazonaws.com/${var.ecr_repo_name}:latest"
  }
}

resource "aws_ecs_task_definition" "ecs_task_definition" {
  count                    = length(var.environments)
  container_definitions    = data.template_file.ecs_task_definition_template[count.index].rendered
  family                   = "${var.repo_name}-ecs-${var.environments[count.index]}"
  cpu                      = var.cpu
  memory                   = var.memory
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  execution_role_arn       = aws_iam_role.ecs_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn
}
