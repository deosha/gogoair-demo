resource "aws_security_group" "alb-sg" {
  name = "tf-alb-demo-sg-${var.env}"
  vpc_id = "${var.vpc_id}"

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "demo-alb-sg-${var.env}"
    Environment = "${var.env}"
    Created_By = "Terraform"
  }
}

resource "aws_security_group" "asg-sg" {
  name        = "tf-ecs-asg-sg-${var.env}"
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    security_groups = ["${aws_security_group.alb-sg.id}"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  tags {
    Name = "asg-sg-${var.env}"
    Environment = "${var.env}"
    Created_By = "Terraform"
  }
}

resource "aws_iam_role" "ecs-asg-role" {
  name = "demo-ecs-asg-role-${var.env}"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "ecs-asg-profile" {
  name = "demo-ecs-asg-profile-${var.env}"
  role = "${aws_iam_role.ecs-asg-role.name}"
}

resource "aws_iam_role_policy_attachment" "ecs_ec2_role" {
  role       = "${aws_iam_role.ecs-asg-role.id}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_role_policy_attachment" "ecs_ec2_cloudwatch_role" {
  role       = "${aws_iam_role.ecs-asg-role.id}"
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
}

resource "aws_iam_role_policy_attachment" "ecs_ec2_s3readonly_role" {
  role       = "${aws_iam_role.ecs-asg-role.id}"
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}




