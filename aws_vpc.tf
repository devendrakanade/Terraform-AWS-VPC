resource "aws_vpc" "main-vpc" {
    cidr_block = "10.0.0.0/16"
    instance_tenancy = "default"
    enable_dns_support = "true"
    enable_dns_hostnames = "true"
    enable_classiclink = "false" 
    tags = {
        Name = "Test-${var.Env}-vpc"
    }
}

# public subnet
resource "aws_subnet" "public-subnet" {
    count= length(var.cidr_block_public)
    vpc_id = "${aws_vpc.main-vpc.id}"
    cidr_block = element(var.cidr_block_public,count.index)
    map_public_ip_on_launch = "true" # instance should not be assigned a public IP address # Bydefault false
    availability_zone = element(var.avail_zone,count.index)

    tags = {
        Name = "Test-${var.Env}-public${count.index +1}"
    }
}

# private subnet
resource "aws_subnet" "private-subnet" {
    count= length(var.cidr_block_private)
    vpc_id = "${aws_vpc.main-vpc.id}"
    cidr_block = element(var.cidr_block_private,count.index)
    map_public_ip_on_launch = "false" # instance should not be assigned a public IP address # Bydefault false
    availability_zone = element(var.avail_zone,count.index)

    tags = {
        Name = "Test-${var.Env}-private${count.index +1}"
    }
}

# internet gateway for internet connectivity in public subnet
resource "aws_internet_gateway" "main-gw" {
    vpc_id = "${aws_vpc.main-vpc.id}"

    tags = {
        Name = "Test-${var.Env}-GW"
    }
}

# route table
resource "aws_route_table" "main-public" {
    vpc_id = "${aws_vpc.main-vpc.id}"
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.main-gw.id}"
    }

    tags = {
        Name = "Test-${var.Env}-vpc"
    }
}
# route_table_association with public subnet
resource "aws_route_table_association" "main-public-route" {
    count= length(var.cidr_block_public)
    subnet_id = "${aws_subnet.public-subnet[count.index].id}" # or element( aws_subnet.public-subnet.*.id , count.index)
    route_table_id = "${aws_route_table.main-public.id}"
}
