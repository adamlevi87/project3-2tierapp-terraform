# Explanation:  The Load Balancer's Security group  allows traffic from the     internet.
#               The Client's Security group         allows traffic from the     Load Balancer's Security group.
#               The DB Security Group               allows traffic from the     Client's security group.
#               The Jump Server;s Security Group    allows traffic from the     internet on port 22(ssh).


# Create a Security group for the Application Load Balancer
resource "aws_security_group" "alb_sg" {
    name = "alb_sg"
    description = "a security group for the application load balancer"
    vpc_id = var.vpc_id

    tags = {
        Name = "alb_sg"
        Project = var.project_name
    }
}

# Create an Ingress Rule for alb_sg to allow tcp port 80 (to be used for http)
resource "aws_vpc_security_group_ingress_rule" "ingress_rule_80_alb" {
    security_group_id = aws_security_group.alb_sg.id
    description = "allow traffic on tcp port 80 to alb_sg"
    from_port = 80
    to_port = 80
    ip_protocol = "tcp"
    cidr_ipv4 = "0.0.0.0/0"
    
    tags = {
        Name = "ingress_rule_80_alb"
        Project = var.project_name
    }
}

# Create an Ingress Rule for alb_sg to allow tcp port 443 (to be used for https)
resource "aws_vpc_security_group_ingress_rule" "ingress_rule_443_alb" {
    security_group_id = aws_security_group.alb_sg.id
    description = "allow traffic on tcp port 443 to alb_sg"
    from_port = 443
    to_port = 443
    ip_protocol = "tcp"
    cidr_ipv4 = "0.0.0.0/0"
    
    tags = {
        Name = "ingress_rule_443_alb"
        Project = var.project_name
    }
}

# Create an Egress Rule for alb_sg [has to be mentioned when using terraform]
resource "aws_vpc_security_group_egress_rule" "egress_rule_alb" {
    security_group_id = aws_security_group.alb_sg.id
    description = "allows all traffic on all ports out from alb_sg"
    ip_protocol = -1
    cidr_ipv4 = "0.0.0.0/0"
    
    tags = {
        Name = "egress_rule_all_alb"
        Project = var.project_name
    }
}

# Create a Security group for the Webservers [EC2 Instances ]
resource "aws_security_group" "websrv_sg" {
    name = "websrv_sg"
    description = "a security group for Web Servers"
    vpc_id = var.vpc_id

    tags = {
        Name = "websrv_sg"
        Project = var.project_name
    }
}

# Create an Ingress Rule for websrv_sg to allow tcp port 80 (to be used for http) from alb_sg
resource "aws_vpc_security_group_ingress_rule" "ingress_rule_80_websrv" {
    security_group_id = aws_security_group.websrv_sg.id
    description = "allow traffic on tcp port 80 from alb_sg to websrv_sg"
    from_port = 80
    to_port = 80
    ip_protocol = "tcp"
    referenced_security_group_id = aws_security_group.alb_sg.id
    
    tags = {
        Name = "ingress_rule_80_websrv"
        Project = var.project_name
    }
}

# Create an Ingress Rule for websrv_sg to allow tcp port 443 (to be used for https?) from alb_sg
# resource "aws_vpc_security_group_ingress_rule" "ingress_rule_443_websrv" {
#     security_group_id = aws_security_group.websrv_sg.id
#     description = "allow traffic on tcp port 443 from alb_sg to websrv_sg"
#     from_port = 443
#     to_port = 443
#     ip_protocol = "tcp"
#     referenced_security_group_id = aws_security_group.alb_sg.id
    
#     tags = {
#         Name = "ingress_rule_443_websrv"
#         Project = var.project_name
#     }
# }

# Create an Egress Rule for websrv_sg [has to be mentioned when using terraform]
resource "aws_vpc_security_group_egress_rule" "egress_rule_websrv" {
    security_group_id = aws_security_group.websrv_sg.id
    description = "allows all traffic on all ports out from websrv_sg"
    ip_protocol = -1
    cidr_ipv4 = "0.0.0.0/0"
    
    tags = {
        Name = "egress_rule_all_websrv"
        Project = var.project_name
    }
}

# Create a Security group for the Databases
resource "aws_security_group" "db_sg" {
    name = "db_sg"
    description = "a security group for the Databases"
    vpc_id = var.vpc_id

    tags = {
        Name = "db_sg"
        Project = var.project_name
    }
}

# Create an Ingress Rule for db_sg to allow tcp port 3306 (to be used by mysql) from websrv_sg 
resource "aws_vpc_security_group_ingress_rule" "ingress_rule_3306_db" {
    security_group_id = aws_security_group.db_sg.id
    description = "allow traffic on tcp port 3306 from websrv_sg to db_sg. This will be used for mysql communication"
    from_port = 3306
    to_port = 3306
    ip_protocol = "tcp"
    referenced_security_group_id = aws_security_group.websrv_sg.id
    
    tags = {
        Name = "ingress_rule_3306_db"
        Project = var.project_name
    }
}

# Create an Egress Rule for db_sg [has to be mentioned when using terraform]
resource "aws_vpc_security_group_egress_rule" "egress_rule_db" {
    security_group_id = aws_security_group.db_sg.id
    description = "allows all traffic on all ports out from db_sg"
    ip_protocol = -1
    cidr_ipv4 = "0.0.0.0/0"
    
    tags = {
        Name = "egress_rule_all_db"
        Project = var.project_name
    }
}

# Create -another- Security group (for the the single EC2 Instance [created in module server/ec2]) to be used to ssh
resource "aws_security_group" "jump_servers_sg" {
    name = "jump_servers_sg"
    description = "a security group for SSHing to the single EC2 instance"
    vpc_id = var.vpc_id

    tags = {
        Name = "jump_servers_sg"
        Project = var.project_name
    }
}

# Create an Ingress Rule for jump_servers to allow tcp port 22 (to be used to ssh) from all sources
resource "aws_vpc_security_group_ingress_rule" "ingress_rule_22_jump_servers" {
    security_group_id = aws_security_group.jump_servers_sg.id
    description = "allow traffic on tcp port 22 from all sources to jump_servers_sg"
    from_port = 22
    to_port = 22
    ip_protocol = "tcp"
    cidr_ipv4 = "0.0.0.0/0"
    
    tags = {
        Name = "ingress_rule_22_jump_servers"
        Project = var.project_name
    }
}

# Create an Egress Rule for jump_servers_sg [has to be mentioned when using terraform]
resource "aws_vpc_security_group_egress_rule" "egress_rule_ssh_jump_servers" {
    security_group_id = aws_security_group.jump_servers_sg.id
    description = "allows all traffic on all ports out from jump_servers_sg"
    ip_protocol = -1
    cidr_ipv4 = "0.0.0.0/0"
    
    tags = {
        Name = "egress_rule_all_jump_servers"
        Project = var.project_name
    }
}


