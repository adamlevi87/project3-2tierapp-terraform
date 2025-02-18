# Create a VPC
resource "aws_vpc" "vpc" {
    cidr_block = var.vpc_cidr
    instance_tenancy = "default"
    enable_dns_support = true
    enable_dns_hostnames = true

    tags = {
        Name = "${var.project_name}-vpc"
        Project = var.project_name
    }
}

# Create an AWS Internet Gateway and attach/associate it with the aws_vpc:vpc
resource "aws_internet_gateway" "internet_gateway" {
    vpc_id = aws_vpc.vpc.id

    tags = {
        Name = "${var.project_name}-igw"
        Project = var.project_name
    }
}

# Use a Data Source to get all Availability Zones in the region which will be used to create subnets [assumes there are 6]
data "aws_availability_zones" "available_zones" {}


# Create public Subnet #1 named public_sub_1_az1
resource "aws_subnet" "public_sub_1_az1" {
    vpc_id = aws_vpc.vpc.id
    cidr_block = var.public_sub_1_az1_cidr
    availability_zone = data.aws_availability_zones.available_zones.names[0]
    map_public_ip_on_launch = true

    tags = {
        Name = "public_sub_1_az1"
        Project = var.project_name
    }
}

# Create public Subnet #2 named public_sub_2_az2
resource "aws_subnet" "public_sub_2_az2" {
    vpc_id = aws_vpc.vpc.id
    cidr_block = var.public_sub_2_az2_cidr
    availability_zone = data.aws_availability_zones.available_zones.names[1]
    map_public_ip_on_launch = true

    tags = {
        Name = "public_sub_2_az2"
        Project = var.project_name
    }
}

# Create private Subnet #1 named private_sub_1_az1
resource "aws_subnet" "private_sub_1_az1" {
    vpc_id                    = aws_vpc.vpc.id
    cidr_block                = var.private_sub_1_az1_cidr
    availability_zone         = data.aws_availability_zones.available_zones.names[0]
    map_public_ip_on_launch   = false

    tags = {
        Name    = "private_sub_1_az1"
        Project = var.project_name
    }
}

# Create private Subnet #2 named private_sub_2_az2
resource "aws_subnet" "private_sub_2_az2" {
    vpc_id                    = aws_vpc.vpc.id
    cidr_block                = var.private_sub_2_az2_cidr
    availability_zone         = data.aws_availability_zones.available_zones.names[1]
    map_public_ip_on_launch   = false

    tags = {
        Name    = "private_sub_2_az2"
        Project = var.project_name
    }
}

# Create private Subnet #3 named private_sub_3_az1
resource "aws_subnet" "private_sub_3_az1" {
    vpc_id                    = aws_vpc.vpc.id
    cidr_block                = var.private_sub_3_az1_cidr
    availability_zone         = data.aws_availability_zones.available_zones.names[0]
    map_public_ip_on_launch   = false

    tags = {
        Name    = "private_sub_3_az1"
        Project = var.project_name
    }
}

# Create private Subnet #4 named private_sub_4_az2
resource "aws_subnet" "private_sub_4_az2" {
    vpc_id                    = aws_vpc.vpc.id
    cidr_block                = var.private_sub_4_az2_cidr
    availability_zone         = data.aws_availability_zones.available_zones.names[1]
    map_public_ip_on_launch   = false

    tags = {
        Name    = "private_sub_4_az2"
        Project = var.project_name
    }
}

# Create a Route Table for those public subnets and Add a Route to all traffic via the Internet Gateway
resource "aws_route_table" "public_route_table" {
    vpc_id = aws_vpc.vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.internet_gateway.id
    }

    tags = {
        Name = "Public-RT"
        Project = var.project_name
    }
}

# Associate Public subnet #1 , public_sub_1_az1, to the Public Route Table: Public-RT
resource "aws_route_table_association" "public_sub_1_az1_route_table_association" {
    subnet_id = aws_subnet.public_sub_1_az1.id
    route_table_id = aws_route_table.public_route_table.id
}

# Associate Public subnet #2 , public_sub_2_az2, to the Public Route Table: Public-RT
resource "aws_route_table_association" "public_sub_2_az2_route_table_association" {
    subnet_id = aws_subnet.public_sub_2_az2.id
    route_table_id = aws_route_table.public_route_table.id
}



