output "asg-sg-id" {
  value = "${aws_security_group.asg-sg.id}"
}

output "ecs-asg-iam-instance-profile-name"{
  value = "${aws_iam_instance_profile.ecs-asg-profile.name}"
}



