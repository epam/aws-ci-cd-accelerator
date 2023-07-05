resource "aws_codedeploy_app" "application" {
  count            = var.target_type == "instance" || var.target_type == "ip"? 1 : 0
  name             = "${var.repo_name}-${var.region_name}"
  compute_platform = var.target_type == "instance" ? "Server" : "ECS"
}

resource "aws_codedeploy_deployment_group" "ec2" {
  count                  = var.target_type == "instance" ? length(var.environments) : 0
  app_name               = aws_codedeploy_app.application[0].name
  deployment_group_name  = "${var.repo_name}-${var.region_name}-${var.environments[count.index]}"
  service_role_arn       = var.codedeploy_role
  autoscaling_groups     = [var.asg_name[count.index]]
  deployment_config_name = var.desired_capacity[count.index] > "1" ? var.conf_one_at_time : var.conf_all_at_once
}

# Deploy to ECS
resource "aws_codedeploy_deployment_group" "ecs" {
  count                  = var.target_type == "ip" ? length(var.environments) : 0
  app_name               = aws_codedeploy_app.application[0].name
  deployment_group_name  = "${var.repo_name}-${var.region_name}-${var.environments[count.index]}"
  service_role_arn       = var.codedeploy_role
  deployment_config_name = var.desired_capacity[count.index] > "1" ? "CodeDeployDefault.ECSCanary10Percent5Minutes" : "CodeDeployDefault.ECSAllAtOnce"
  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }
  ecs_service {
    cluster_name = var.ecs_cluster_name
    service_name = var.ecs_service_name[count.index]
  }
  blue_green_deployment_config {
    deployment_ready_option {
      action_on_timeout = "CONTINUE_DEPLOYMENT"
    }
    terminate_blue_instances_on_deployment_success {
      action                           = "TERMINATE"
      termination_wait_time_in_minutes = var.termination_wait_time_in_minutes
    }
  }
  deployment_style {
    deployment_option = "WITH_TRAFFIC_CONTROL"
    deployment_type   = "BLUE_GREEN"
  }
  load_balancer_info {
    target_group_pair_info {
      prod_traffic_route {
        listener_arns = [var.main_listener]
      }
      target_group {
        name = var.target_group_blue_name[count.index]
      }
      target_group {
        name = var.target_group_green_name[count.index]
      }
    }
  }
  lifecycle {
    ignore_changes = all
  }
}