terraform {
  backend "s3" {}
}

provider "aws" {
  region = "${var.region}"
}

data "terraform_remote_state" "infra_state" {
  backend = "s3"
  config {
    bucket = "state-files-gogoair"
    key = "${var.env}/infra.tfstate"
    region = "${var.region}"
  }
}

module "Network-And-DNS" {
  source = "./modules/Network-And-DNS"
  env = "${var.env}"
  security_group = "${module.Security-And-Authentications.asg-sg-id}"
}

module "Security-And-Authentications" {
  source = "./modules/Security-And-Authentications"
  env = "${var.env}"
  vpc_id = "${module.Network-And-DNS.id}"
}

module "Instances-And-LoadBalancers" {
  source = "./modules/Instances-And-LoadBalanacers"
  private_subnet_ids = ["${module.Network-And-DNS.private_subnet_id1}","${module.Network-And-DNS.private_subnet_id2}"]
  public_subnet_ids = ["${module.Network-And-DNS.public_subnet_id1}","${module.Network-And-DNS.public_subnet_id2}"]
  public_subnet_id = "${module.Network-And-DNS.public_subnet_id1}"
  vpc_id = "${module.Network-And-DNS.id}"
  cluster = "${module.Containers.cluster_name}"
  env = "${var.env}"
  security_group = "${module.Security-And-Authentications.asg-sg-id}"
  key_name = "${var.key_pair_name}"
  nat_gateway1_id = "${module.Network-And-DNS.nat_gateway1_id}"
  nat_gateway2_id = "${module.Network-And-DNS.nat_gateway2_id}"
  instance_type = "${var.instance_type}"
  iam_instance_profile = "${module.Security-And-Authentications.ecs-asg-iam-instance-profile-name}"
  alb_security_group = "${module.Security-And-Authentications.alb-sg-id}"
  deregistration_delay = "${var.deregistration_delay}"
  health_check_path = "${var.health_check_path}"
}

module "Containers" {
  source = "./modules/Containers/ecs"
  env = "${var.env}"
  region = "${var.region}"
  tag = "${var.tag}"
}



