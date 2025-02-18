variable project_name {
    description = "a Variable for Naming your Project"
}

variable region {
    description = "AWS region"
}

variable "vpc_cidr" {
    description = "your VPC cidr range"
}

variable "public_sub_1_az1_cidr" {
    description = "cidr range for Subnet: public_sub_1_az1"
}

variable "public_sub_2_az2_cidr" {
    description = "cidr range for Subnet: public_sub_2_az2"
}

variable "private_sub_1_az1_cidr" {
    description = "cidr range for Subnet: private_sub_1_az1"
}

variable "private_sub_2_az2_cidr" {
    description = "cidr range for Subnet: private_sub_2_az2"
}

variable "private_sub_3_az1_cidr" {
    description = "cidr range for Subnet: private_sub_3_az1"
}

variable "private_sub_4_az2_cidr" {
    description = "cidr range for Subnet: private_sub_4_az2"
}

variable "server_ami" {
    description = "image to be used as the source of all the ec2 servers"
}

variable "server_cpu" {
    description = "ec2 instance size to be used for all ec2s"
}

variable "asg_server_ami" {
    description = "image to be used as the source of the Auto Scaling Group"
}

variable "asg_server_cpu" {
    description = "Auto Scaling Group - Instance size [cpu]"
}

variable "asg_health_check_type" {
    description = "Auto Scale Group Health Check type"
}

variable "asg_desired_capacity" {
    description = "Auto Scale Group - the Number of Instances Scale in/out rules will try to keep"
}

variable "asg_min_capacity" {
    description = "Auto Scale Group - Minimum Size"
}

variable "asg_max_capacity" {
    description = "Auto Scale Group - Maximum Size"
}

variable "rds_username" {
    description = "an Admin Username for Accessing the RDS-MySQL Database"
}

variable "rds_password" {
    description = "an Admin password for Accessing the RDS-MySQL Database"
}

variable "rds_db_name" {
    description = "The Database name of RDS-MySQL Database"
}

variable "rds_running_status" {
    description = "The RDS run status- Options are Start/Stop, created to decrease cost while writing the TF code"
}

variable "hosted_zone_domain" {
    description = "The domain to add to the Hosted Zone management"
}

variable "domain_name" {
    description = "The Domain that will be used to browse to your web servers"
}

variable "alternative_domain_names" {
    description = "The Additional Domains that will be used to browse to your web servers"
}