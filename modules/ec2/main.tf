# Create elastic file system
resource "aws_efs_file_system" "wordpress_EFS" {
  creation_token = "wordpress-EFS"

  tags = {
    Name = "wordpress-EFS"
  }
}

# Mount efs on targets
resource "aws_efs_mount_target" "efs_mount" {
  count          = length(var.private_app_subnets_ids)
  file_system_id = aws_efs_file_system.wordpress_EFS.id
  # subnet_id      = "${element(var.private_app_subnets_ids, count.index)}"
  subnet_id       = element(var.private_app_subnets_ids, count.index)
  security_groups = [var.efs_security_group_id]
}

# ------------------------------------------------

# Launch template for bastion/jump host 
resource "aws_launch_template" "bastionhost_lt" {
  name                   = "bastionhost-LT"
  image_id               = var.ami
  instance_type          = var.instance_type
  key_name               = var.ssh_key_pair
  vpc_security_group_ids = [var.bastionhost_security_group_id]

  lifecycle {
    create_before_destroy = true
  }
}

# Autoscaling group for bastion/jump host
resource "aws_autoscaling_group" "bastionhost_asg" {
  name_prefix         = "bastionhost-ASG"
  min_size            = 1
  max_size            = 2
  desired_capacity    = 1
  vpc_zone_identifier = var.public_subnets_ids
  launch_template {
    id      = aws_launch_template.bastionhost_lt.id
    version = "$Default"
  }

  tag {
    key                 = "Name"
    value               = "bastionhost"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}

# -----------------------------------------------

resource "aws_lb" "wordpress_alb" {
  name               = "wordpress-alb"
  internal           = false
  load_balancer_type = "application"
  ip_address_type    = "ipv4"
  security_groups    = [var.alb_security_group_id]
  subnets            = var.public_subnets_ids
}

resource "aws_lb_target_group" "alb_target_grp" {
  name        = "wordpress-alb-tg"
  port        = 80
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = var.project_vpc_id
  health_check {
    enabled             = true
    healthy_threshold   = 3
    interval            = 15
    matcher             = 200
    path                = "/"
    timeout             = 3
    unhealthy_threshold = 3
  }
}

resource "aws_lb_listener" "alb_listener" {
  load_balancer_arn = aws_lb.wordpress_alb.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_target_grp.arn
  }
}

# -------------------------------------------------

# Launch template for application servers
resource "aws_launch_template" "app_server_lt" {
  name                   = "app-server-LT"
  image_id               = var.ami
  instance_type          = var.instance_type
  key_name               = var.ssh_key_pair
  vpc_security_group_ids = [var.app_server_security_group, var.efs_security_group]
  user_data              = base64encode(var.user_data_rendered)

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [var.wordpress_db_instance, aws_efs_file_system.wordpress_EFS, aws_efs_mount_target.efs_mount]
}

# Autoscaling group for application servers
resource "aws_autoscaling_group" "app_server_asg" {
  name_prefix         = "app-server-ASG"
  min_size            = 2
  max_size            = 4
  desired_capacity    = 2
  vpc_zone_identifier = var.private_app_subnets_ids
  target_group_arns   = [aws_lb_target_group.alb_target_grp.arn]

  launch_template {
    id      = aws_launch_template.app_server_lt.id
    version = "$Default"
  }

  tag {
    key                 = "Name"
    value               = "app-server"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [var.wordpress_db_instance, aws_efs_file_system.wordpress_EFS, aws_efs_mount_target.efs_mount]
}