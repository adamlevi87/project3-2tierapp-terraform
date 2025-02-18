# Create a single EC2 instance in the subnet: private_sub_1_az1
resource "aws_instance" "jump_server" {
  ami = var.ami
  instance_type = var.cpu
  subnet_id = var.public_sub_1_az1_id
  vpc_security_group_ids = [var.jump_srv_sg_id]
  key_name = var.jump_srv_key_certificate

  tags = {
    Name = "jump_server"
    Project = var.project_name
  }
}