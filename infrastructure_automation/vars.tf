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
  default = "latest"
  description = "Docker tag"
}

