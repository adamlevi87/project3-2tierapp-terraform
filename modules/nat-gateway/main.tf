# Create a public ip to be used by the nat-gateway for public subnet: public_sub_1_az1/availability zone 1
resource "aws_eip" "eip-nat-az1" {
    domain = "vpc"

    tags = {
      Name = "eip-nat-az1"
      Project = var.project_name
    }
}

# Create a public ip to be used by the nat-gateway for public subnet: public_sub_2_az2/availability zone 2
resource "aws_eip" "eip-nat-az2" {
    domain = "vpc"

    tags = {
      Name = "eip-nat-az2"
      Project = var.project_name
    }
}

# Create a NAT Gateway in Public Subnet: public_sub_1_az1
resource "aws_nat_gateway" "nat-az1" {
    depends_on = [ var.igw_id ]

    allocation_id = aws_eip.eip-nat-az1.id
    subnet_id = var.public_sub_1_az1_id

    tags = {
        Name = "nat-az1"
        Project = var.project_name
    }
}

# Create a NAT Gateway in Public Subnet: public_sub_2_az2
resource "aws_nat_gateway" "nat-az2" {
    depends_on = [ var.igw_id ]

    allocation_id = aws_eip.eip-nat-az2.id
    subnet_id = var.public_sub_2_az2_id

    tags = {
        Name = "nat-az2"
        Project = var.project_name
    }
}

# Create a Private Route Table, private-route-table-az1, which will route to NAT Gateway: nat-az1
# This will be used by the private subnets in Availability-Zone 1 ( private_sub_1_az1 & private_sub_3_az1 )
resource "aws_route_table" "private_route_table_az1" {
    vpc_id = var.vpc_id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_nat_gateway.nat-az1.id
    }

    tags = {
        Name = "private-route-table-az1"
        Project = var.project_name
    }
}

# Create a Private Route Table, private-route-table-az2, which will route to NAT Gateway: nat-az2
# This will be used by the private subnets in Availability-Zone 2 ( private_sub_2_az2 & private_sub_4_az2 )
resource "aws_route_table" "private_route_table_az2" {
    vpc_id = var.vpc_id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_nat_gateway.nat-az2.id
    }

    tags = {
        Name = "private-route-table-az2"
        Project = var.project_name
    }
}

# Associate private subnet private_sub_1_az1 with private route table private-route-table-az1
resource "aws_route_table_association" "associate_private-sub-1-az1_with_private-route-table-az1" {
    subnet_id = var.private_sub_1_az1_id
    route_table_id = aws_route_table.private_route_table_az1.id
}

# Associate private subnet private_sub_3_az1 with private route table private-route-table-az1
resource "aws_route_table_association" "associate_private-sub-3-az1_with_private-route-table-az1" {
    subnet_id = var.private_sub_3_az1_id
    route_table_id = aws_route_table.private_route_table_az1.id
}

# Associate private subnet private_sub_2_az2 with private route table private-route-table-az2
resource "aws_route_table_association" "associate_private-sub-2-az2_with_private-route-table-az2" {
    subnet_id = var.private_sub_2_az2_id
    route_table_id = aws_route_table.private_route_table_az2.id
}

# Associate private subnet private_sub_2_az2 with private route table private-route-table-az2
resource "aws_route_table_association" "associate_private-sub-4-az2_with_private-route-table-az2" {
    subnet_id = var.private_sub_4_az2_id
    route_table_id = aws_route_table.private_route_table_az2.id
}