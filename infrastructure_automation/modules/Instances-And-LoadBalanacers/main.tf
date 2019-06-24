data "aws_ami" "ecs_instance_ami" {
  most_recent = true
  owners = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn-ami-2018.03.a-amazon-ecs-optimized"]
  }
}

data "aws_ami" "ephemeral_instance_ami" {
  most_recent = true
  owners = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn-ami-hvm*-x86_64-gp2"]
  }
}

resource "aws_launch_configuration" "lc" {
  name_prefix          = "demo-lc-${var.env}-${var.instance_group}"
  image_id             = "${data.aws_ami.ecs_instance_ami.id}"
  instance_type        = "${var.instance_type}"
  security_groups      = ["${var.security_group}"]
  associate_public_ip_address = true
  iam_instance_profile = "${var.iam_instance_profile}"
  user_data            = "${data.template_file.user_data.rendered}"
  key_name             = "${var.key_name}"
  root_block_device {
    volume_size = 8
    volume_type = "gp2"
    delete_on_termination = false
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "asg" {
  name                 = "demo-asg-${var.env}"
  max_size             = "${var.max_size}"
  min_size             = "${var.min_size}"
  desired_capacity     = "${var.desired_capacity}"
  force_delete         = true
  launch_configuration = "${aws_launch_configuration.lc.id}"
  vpc_zone_identifier  = ["${var.public_subnet_ids}"]

  tag {
    key                 = "Name"
    value               = "app-${var.env}"
    propagate_at_launch = "true"
  }

  tag {
    key                 = "Environment"
    value               = "${var.env}"
    propagate_at_launch = "true"
  }

  tag {
    key                 = "InstanceGroup"
    value               = "${var.instance_group}"
    propagate_at_launch = "true"
  }

}

data "template_file" "user_data" {
  template = "${file("${path.module}/templates/user_data.sh")}"

  vars {
    ecs_config        = "${var.ecs_config}"
    ecs_logging       = "${var.ecs_logging}"
    cluster_name      = "${var.cluster}"
    env_name          = "${var.env}"
    custom_userdata   = "${var.custom_userdata}"
    cloudwatch_prefix = "${var.cloudwatch_prefix}"
  }
}

resource "aws_alb_target_group" "alb-tg" {
  name                 = "demo-alb-frontend-tg-${var.env}"
  port                 = 80
  protocol             = "HTTP"
  vpc_id               = "${var.vpc_id}"
  deregistration_delay = "${var.deregistration_delay}"

  health_check {
    path     = "${var.health_check_path}"
    protocol = "HTTP"
  }

  tags {
    Name = "demo-alb-tg-${var.env}"
    Environment = "${var.env}"
    Created_By = "Terraform"
  }
  depends_on = ["aws_alb.alb"]
}

resource "aws_alb" "alb" {
  name            = "demo-alb-${var.env}"
  subnets         = ["${var.public_subnet_ids}"]
  security_groups = ["${var.alb_security_group}"]
  idle_timeout    = "300"

  tags {
    Name        = "demo-alb-${var.env}"
    Environment = "${var.env}"
    Created_By = "Terraform"
  }
}

resource "aws_alb_listener" "alb-listener" {
  load_balancer_arn = "${aws_alb.alb.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_alb_target_group.alb-tg.id}"
    type             = "redirect"
    redirect {
      port        = "80"
      protocol    = "HTTP"
      status_code = "HTTP_301"
    }
  }
}


