resource "aws_lb" "app" {
  name                             = "${var.project}-${var.repo_name}"
  internal                         = false
  load_balancer_type               = "application"
  drop_invalid_header_fields       = true
  enable_cross_zone_load_balancing = true
  subnets                          = var.public_subnet_ids
  security_groups                  = var.security_groups

  tags = {
    Application = var.repo_name
    Project     = var.project
  }
}


resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.app.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.app.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS-1-2-2017-01"
  certificate_arn   = var.aws_acm_certificate_arn
  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      status_code  = "404"
    }
  }
}

resource "aws_lb_target_group" "group" {
  count       = var.target_type == "instance" ? length(var.environments) : 0
  name        = "${var.repo_name}-${var.environments[count.index]}"
  port        = var.target_port
  protocol    = "HTTP"
  target_type = var.target_type
  vpc_id      = var.vpc_id

  deregistration_delay = 5

  health_check {
    path                = var.health_path
    protocol            = "HTTP"
    matcher             = "200"
    interval            = "10"
    timeout             = "5"
    unhealthy_threshold = "3"
    healthy_threshold   = "3"
  }
  lifecycle {
    ignore_changes = all
  }
}
resource "aws_lb_listener_rule" "ec2_rule" {
  count        = var.target_type == "instance" ? length(var.environments) : 0
  listener_arn = aws_lb_listener.https.arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.group[count.index].arn
  }
  condition {
    host_header {
      values = [aws_route53_record.record[count.index].fqdn]
    }
  }
  lifecycle {
    ignore_changes = [action.0.target_group_arn]
  }
}

##=========================== ECS ===============================================##
resource "aws_lb_target_group" "blue_group" {
  count       = var.target_type == "ip" ? length(var.environments) : 0
  name        = "${var.repo_name}-${var.environments[count.index]}-1"
  port        = var.target_port
  protocol    = "HTTP"
  target_type = var.target_type
  vpc_id      = var.vpc_id

  deregistration_delay = 5

  health_check {
    path                = var.health_path
    protocol            = "HTTP"
    matcher             = "200"
    interval            = "10"
    timeout             = "5"
    unhealthy_threshold = "3"
    healthy_threshold   = "3"
  }
  lifecycle {
    ignore_changes = all
  }
}
resource "aws_lb_target_group" "green_group" {
  count       = var.target_type == "ip" ? length(var.environments) : 0
  name        = "${var.repo_name}-${var.environments[count.index]}-2"
  port        = var.target_port
  protocol    = "HTTP"
  target_type = var.target_type
  vpc_id      = var.vpc_id

  deregistration_delay = 5

  health_check {
    path                = var.health_path
    protocol            = "HTTP"
    matcher             = "200"
    interval            = "10"
    timeout             = "5"
    unhealthy_threshold = "3"
    healthy_threshold   = "3"
  }
  lifecycle {
    ignore_changes = all
  }
}
resource "aws_lb_listener_rule" "ecs_rule" {
  count        = var.target_type == "ip" ? length(var.environments) : 0
  listener_arn = aws_lb_listener.https.arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.blue_group[count.index].arn
  }
  condition {
    host_header {
      values = [aws_route53_record.record[count.index].fqdn]
    }
  }
  lifecycle {
    ignore_changes = [action.0.target_group_arn]
  }
}