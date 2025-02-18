# Create an EC2 key pair - will be used for SSH'ing to EC2/Auto Scaled Instances
resource "aws_key_pair" "ssh_key_to_ec2_websrv" {
    key_name = "ssh_key_to_ec2_websrv"
    public_key = file("../main/z_client_key.pub")

    tags = {
        Name = "ssh_key_to_ec2_websrv"
        Project = var.project_name
    }
}