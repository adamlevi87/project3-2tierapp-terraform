########### Variables that must change - cost protection
asg_desired_capacity = 3 #3
asg_min_capacity = 2 #2
asg_max_capacity = 6 #6
rds_running_status = "start" # Options: start , stop
###########

#### 
    ## Both domain variables can only be subdomains of the hosted_zone_domain
    domain_name = "mysite"
    alternative_domain_names = [ "www.mysite" ] # List of Strings
    ###
hosted_zone_domain = "projects-devops.cfd"
#####

region              = "us-east-1"
project_name        = "2tierapp"
vpc_cidr            = "10.0.0.0/16"
public_sub_1_az1_cidr = "10.0.1.0/24"
public_sub_2_az2_cidr = "10.0.2.0/24"
private_sub_1_az1_cidr = "10.0.3.0/24"
private_sub_2_az2_cidr = "10.0.4.0/24"
private_sub_3_az1_cidr = "10.0.5.0/24"
private_sub_4_az2_cidr = "10.0.6.0/24"
asg_health_check_type = "ELB"

server_ami = "ami-053b0d53c279acc90"
asg_server_ami = "ami-053b0d53c279acc90"
# AMI:
# https://console.aws.amazon.com/ec2/home?#ImageDetails:imageId=ami-053b0d53c279acc90
# amazon's ubuntu 22

server_cpu = "t2.micro"
asg_server_cpu = "t2.micro"

rds_username = "admin"
rds_password = "pasSwort73!%%%"
rds_db_name = "test"