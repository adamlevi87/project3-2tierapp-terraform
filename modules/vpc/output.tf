output "public_sub_1_az1_id" {
  value = aws_subnet.public_sub_1_az1.id
}

output "public_sub_2_az2_id" {
  value = aws_subnet.public_sub_2_az2.id
}

output "igw_id" {
  value = aws_internet_gateway.internet_gateway.id
}

output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "private_sub_1_az1_id" {
  value = aws_subnet.private_sub_1_az1.id
}

output "private_sub_2_az2_id" {
  value = aws_subnet.private_sub_2_az2.id
}

output "private_sub_3_az1_id" {
  value = aws_subnet.private_sub_3_az1.id
}

output "private_sub_4_az2_id" {
  value = aws_subnet.private_sub_4_az2.id
}
