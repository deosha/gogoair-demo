output "id" {
  value = "${aws_vpc.vpc.id}"
}

output "cidr_block" {
  value = "${aws_vpc.vpc.cidr_block}"
}

output "igw" {
  value = "${aws_internet_gateway.igw.id}"
}

output "private_subnet_id1" {
  value = "${aws_subnet.private-subnet1.id}"
}

output "private_subnet_id2" {
  value = "${aws_subnet.private-subnet2.id}"
}

output "public_subnet_id1" {
  value = "${aws_subnet.public-subnet1.id}"
}

output "public_subnet_id2" {
  value = "${aws_subnet.public-subnet2.id}"
}

output "nat_gateway1_id" {
  value = "${aws_nat_gateway.ngw1.id}"
}

output "nat_gateway2_id" {
  value = "${aws_nat_gateway.ngw2.id}"
}

