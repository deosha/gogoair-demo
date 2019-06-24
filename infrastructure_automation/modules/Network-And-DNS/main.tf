resource "aws_vpc" "vpc" {
  cidr_block       = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true

  tags {
    Name = "demo-vpc-${var.env}"
    Environment = "${var.env}"
    Created_By = "Terraform"
  }
}

data "aws_availability_zones" "available" {}

resource "aws_subnet" "public-subnet1" {
  availability_zone = "${data.aws_availability_zones.available.names[0]}"
  vpc_id     = "${aws_vpc.vpc.id}"
  cidr_block = "10.0.1.0/24"
  tags {
    Name = "demo-public-subnet1-${var.env}"
    Environment = "${var.env}"
    Created_By = "Terraform"
  }
}

resource "aws_subnet" "public-subnet2" {
  availability_zone = "${data.aws_availability_zones.available.names[1]}"
  vpc_id     = "${aws_vpc.vpc.id}"
  cidr_block = "10.0.2.0/24"

  tags {
    Name = "demo-public-subnet2-${var.env}"
    Environment = "${var.env}"
    Created_By = "Terraform"
  }
}

resource "aws_subnet" "private-subnet1" {
  availability_zone = "${data.aws_availability_zones.available.names[0]}"
  vpc_id     = "${aws_vpc.vpc.id}"
  cidr_block = "10.0.3.0/24"

  tags {
    Name = "demo-private-subnet1-${var.env}"
    Environment = "${var.env}"
    Created_By = "Terraform"
  }
}

resource "aws_subnet" "private-subnet2" {
  availability_zone = "${data.aws_availability_zones.available.names[1]}"
  vpc_id     = "${aws_vpc.vpc.id}"
  cidr_block = "10.0.4.0/24"

  tags {
    Name = "demo-private-subnet2-${var.env}"
    Environment = "${var.env}"
    Created_By = "Terraform"
  }
}


resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags {
    Name = "demo-internet-gateway-${var.env}"
    Environment = "${var.env}"
    Created_By = "Terraform"
  }
}

resource "aws_nat_gateway" "ngw1" {
  allocation_id = "${aws_eip.eip-ngw1.id}"
  subnet_id     = "${aws_subnet.public-subnet1.id}"

  tags {
    Name = "demo-nat-gateway1-${var.env}"
    Environment = "${var.env}"
    Created_By = "Terraform"
  }

  depends_on = ["aws_internet_gateway.igw"]
}

resource "aws_nat_gateway" "ngw2" {
  allocation_id = "${aws_eip.eip-ngw2.id}"
  subnet_id     = "${aws_subnet.public-subnet2.id}"

  tags {
    Name = "demo-nat-gateway2-${var.env}"
    Environment = "${var.env}"
    Created_By = "Terraform"
  }

  depends_on = ["aws_internet_gateway.igw"]
}

resource "aws_eip" "eip-ngw1" {
  vpc      = true

  tags {
    Name = "demo-eip-nat-gateway1-${var.env}"
    Environment = "${var.env}"
    Created_By = "Terraform"
  }
}

resource "aws_eip" "eip-ngw2" {
  vpc      = true

  tags {
    Name = "demo-eip-nat-gateway2-${var.env}"
    Environment = "${var.env}"
    Created_By = "Terraform"
  }
}

resource "aws_route_table" "rt_igw1" {
  vpc_id = "${aws_vpc.vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.igw.id}"
  }

  tags {
    Name = "demo-route-table1-igw-${var.env}"
    Environment = "${var.env}"
    Created_By = "Terraform"
  }
}

resource "aws_route_table" "rt_igw2" {
  vpc_id = "${aws_vpc.vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.igw.id}"
  }

  tags {
    Name = "demo-route-table2-igw-${var.env}"
    Environment = "${var.env}"
    Created_By = "Terraform"
  }
}

resource "aws_route_table" "rt_ngw1" {
  vpc_id = "${aws_vpc.vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_nat_gateway.ngw1.id}"
  }

  tags {
    Name = "demo-route-table-ngw1-${var.env}"
    Environment = "${var.env}"
    Created_By = "Terraform"
  }
}

resource "aws_route_table" "rt_ngw2" {
  vpc_id = "${aws_vpc.vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_nat_gateway.ngw2.id}"
  }

  tags {
    Name = "demo-route-table-ngw2-${var.env}"
    Environment = "${var.env}"
    Created_By = "Terraform"
  }
}

resource "aws_route_table_association" "rta1-public-subnet1" {
  subnet_id      = "${aws_subnet.public-subnet1.id}"
  route_table_id = "${aws_route_table.rt_igw1.id}"
}

resource "aws_route_table_association" "rta1-public-subnet2" {
  subnet_id      = "${aws_subnet.public-subnet2.id}"
  route_table_id = "${aws_route_table.rt_igw2.id}"
}

resource "aws_route_table_association" "rta1-private-subnet1" {
  subnet_id      = "${aws_subnet.private-subnet1.id}"
  route_table_id = "${aws_route_table.rt_ngw1.id}"
}

resource "aws_route_table_association" "rta1-private-subnet2" {
  subnet_id      = "${aws_subnet.private-subnet2.id}"
  route_table_id = "${aws_route_table.rt_ngw2.id}"
}








