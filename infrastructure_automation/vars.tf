variable "env" {
  description = "The name of the environment"
}

variable "region" {
  description = "The name of the region"
}

variable "key_pair_name" {
  description = "The name of the region"
}

variable "instance_type" {
  description = "instance type"
}

variable "tag" {
  description = "Docker tag"
}

variable "deregistration_delay" {
  description = "ALB deregistration delay"
}

variable "health_check_path" {
  description = "ALB healthcheck path"
}

