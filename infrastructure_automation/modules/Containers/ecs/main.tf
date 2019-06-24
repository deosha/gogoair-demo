resource "aws_ecs_cluster" "ecs-cluster" {
  name = "demo-${var.env}"
}

resource "aws_cloudwatch_log_group" "demo_log_group" {
  name = "demo-${var.env}"
  retention_in_days = 30
  tags {
    Environment = "${var.env}"
    Application = "demo-${var.env}"
  }
}

data "template_file" "demo_task" {
  template = "${file("modules/Containers/ecs/task-definitions/demo.json")}"

  vars {
    region = "${var.region}"
    env = "${var.env}"
    tag = "${var.tag}"
  }
}

data aws_ecs_task_definition "demo" {
  task_definition = "${aws_ecs_task_definition.demo.family}"
}


resource "aws_ecs_task_definition" "demo" {
  family = "demo-task-definition-${var.env}"
  container_definitions = "${data.template_file.demo_task.rendered}"
  network_mode = "bridge"
  requires_compatibilities = [
    "EC2"]
}

resource "aws_ecs_service" "demo" {
  name = "demo-service-${var.env}"
  cluster = "${aws_ecs_cluster.ecs-cluster.id}"
  task_definition = "${aws_ecs_task_definition.demo.family}:${max("${aws_ecs_task_definition.demo.revision}","${data.aws_ecs_task_definition.demo.revision}")}"
  desired_count = 1
  launch_type = "EC2"
  scheduling_strategy = "REPLICA"
  deployment_maximum_percent = "100"
  deployment_minimum_healthy_percent = "50"


  ordered_placement_strategy {
    type = "binpack"
    field = "cpu"
  }

  placement_constraints {
    type = "distinctInstance"
  }

  provisioner "local-exec" {
    command = "sleep 120"
  }
}
