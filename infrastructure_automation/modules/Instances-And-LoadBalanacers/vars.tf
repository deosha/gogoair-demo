variable "env" {
  description = "The name of the environment"
}

variable "instance_group" {
  default     = "app"
  description = "The name of the instances that you consider as a group"
}

variable "vpc_id" {
  description = "The VPC id"
}

variable "instance_type" {
  #default     = "c4.xlarge"
  description = "AWS instance type to use"
}

variable "cloudwatch_prefix" {
  default     = ""
  description = "If you want to avoid cloudwatch collision or you don't want to merge all logs to one log group specify a prefix"
}

variable "ecs_config" {
  default     = "echo '' > /etc/ecs/ecs.config"
  description = "Specify ecs configuration or get it from S3. Example: aws s3 cp s3://some-bucket/ecs.config /etc/ecs/ecs.config"
}

variable "ecs_logging" {
  default     = "[\"json-file\",\"awslogs\"]"
  description = "Adding logging option to ECS that the Docker containers can use. It is possible to add fluentd as well"
}

variable "cluster" {
  description = "The name of the cluster"
}

variable "max_size" {
  default     = 1
  description = "Maximum size of the nodes in the cluster"
}

variable "min_size" {
  default     = 1
  description = "Minimum size of the nodes in the cluster"
}

#For more explenation see http://docs.aws.amazon.com/autoscaling/latest/userguide/WhatIsAutoScaling.html
variable "desired_capacity" {
  default     = 1
  description = "The desired capacity of the cluster"
}



variable "private_subnet_ids" {
  type        = "list"
  description = "The list of private subnets to place the instances in"
}

variable "public_subnet_ids" {
  type        = "list"
  description = "The list of public subnets to place the instances in"
}


variable "key_name" {
  description = "SSH key name to be used"
}

variable "security_group" {
  description = "asg security groups"
}

variable "custom_userdata" {
  default     = ""
  description = "Inject extra command in the instance template to be run on boot"
}

variable "nat_gateway1_id" {
}

variable "nat_gateway2_id" {
}

variable "public_subnet_id" {
  description = "public subnet id to place the bastion host in"
}

variable "iam_instance_profile" {
  description = "instance profile of ecs instance"
}


