data "aws_ami" "latest_ubuntu" {
  owners      = ["099720109477"]
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}
resource "aws_autoscaling_group" "asg" {
  count                     = length(var.environments)
  name                      = "${var.repo_name}-${var.environments[count.index]}-ASG"
  vpc_zone_identifier       = var.private_subnet_ids
  desired_capacity          = var.desired_capacity[count.index]
  max_size                  = var.max_size[count.index]
  min_size                  = var.min_size[count.index]
  health_check_grace_period = 60
  default_cooldown          = 90
  health_check_type         = "ELB"
  launch_template {
    id      = aws_launch_template.example.id
    version = "$Latest"
  }
  tag {
    key                 = "Name"
    value               = "${var.repo_name}-${var.environments[count.index]}-ASG"
    propagate_at_launch = true
  }
  tag {
    key                 = "Project"
    propagate_at_launch = true
    value               = var.project
  }

  instance_refresh {
    strategy = "Rolling"
  }
  lifecycle {
    create_before_destroy = true
    ignore_changes        = [load_balancers, target_group_arns, desired_capacity, min_size]
  }
}
resource "aws_launch_template" "example" {
  name                   = "${var.repo_name}-tpl"
  image_id               = data.aws_ami.latest_ubuntu.id
  instance_type          = var.instance_type
  vpc_security_group_ids = var.security_groups
  update_default_version = false
  iam_instance_profile {
    name = aws_iam_instance_profile.profile.name
  }
  user_data              = base64encode(templatefile("${path.module}/user_data.sh.tpl", {
    region = var.region
  }))
  lifecycle {
    ignore_changes = [image_id]
  }
}

# Create a new ALB Target Group attachment
resource "aws_autoscaling_attachment" "asg_attachment_app" {
  count                  = length(var.environments)
  autoscaling_group_name = aws_autoscaling_group.asg[count.index].id
  lb_target_group_arn   = var.elb_target_group_arn[count.index]
}