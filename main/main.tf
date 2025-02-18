# Create a Virtual Private Cloud:
#   VPC with an Internet Gateway, 2 Public Subnets with Routes to that Gateway & 4 Private Subnets
module "VPC" {
    source = "../modules/vpc"
    project_name = var.project_name
    region = var.region
    vpc_cidr = var.vpc_cidr
    public_sub_1_az1_cidr = var.public_sub_1_az1_cidr
    public_sub_2_az2_cidr = var.public_sub_2_az2_cidr
    private_sub_1_az1_cidr = var.private_sub_1_az1_cidr
    private_sub_2_az2_cidr = var.private_sub_2_az2_cidr
    private_sub_3_az1_cidr = var.private_sub_3_az1_cidr
    private_sub_4_az2_cidr = var.private_sub_4_az2_cidr
}

# Create a Network Address Translation Gateway:
#   2 External IPs for 2 NAT Gateway in the 2 Public Subnets.
#   The private subnets that were created in the VPC module are routed through the NAT.
module "NAT-GW" {
    source = "../modules/nat-gateway"
    project_name = var.project_name
    public_sub_1_az1_id = module.VPC.public_sub_1_az1_id
    public_sub_2_az2_id = module.VPC.public_sub_2_az2_id
    igw_id = module.VPC.igw_id
    vpc_id = module.VPC.vpc_id
    private_sub_1_az1_id = module.VPC.private_sub_1_az1_id
    private_sub_2_az2_id = module.VPC.private_sub_2_az2_id
    private_sub_3_az1_id = module.VPC.private_sub_3_az1_id
    private_sub_4_az2_id = module.VPC.private_sub_4_az2_id
}

# Create Security Groups to be used by the different components
module "SG" {
    source = "../modules/SG"
    project_name = var.project_name
    vpc_id = module.VPC.vpc_id
}

# Create a Key to ssh into the instance
module "KEY" {
    source = "../modules/key"
    project_name = var.project_name
}

# Create the first EC2 instance [in subnet: private_sub_1_az1_id, sg: ssh_websrv_sg_id , ssh_key: key_name]
module "SERVER" {
    source = "../modules/ec2"
    project_name = var.project_name
    ami = var.server_ami
    cpu = var.server_cpu
    public_sub_1_az1_id = module.VPC.public_sub_1_az1_id
    jump_srv_key_certificate = module.KEY.key_name
    jump_srv_sg_id = module.SG.jump_servers_sg_id
}

# Create an Application Load Balancer
module "ALB" {
    source = "../modules/alb"
    project_name = var.project_name
    alb_sg_id = module.SG.alb_sg_id
    public_sub_1_az1_id = module.VPC.public_sub_1_az1_id
    public_sub_2_az2_id = module.VPC.public_sub_2_az2_id
    vpc_id = module.VPC.vpc_id
}

# Create an Auto Scaling Group
module "ASG" {
    source = "../modules/asg"
    project_name = var.project_name
    ami = var.asg_server_ami
    cpu = var.asg_server_cpu
    key_name = module.KEY.key_name
    asg_sg_id = module.SG.websrv_sg_id
    private_sub_1_az1_id = module.VPC.private_sub_1_az1_id
    private_sub_2_az2_id = module.VPC.private_sub_2_az2_id
    target_group_http_arn = module.ALB.target_group_http_arn
    asg_health_check_type = var.asg_health_check_type
    desired_capacity = var.asg_desired_capacity
    min_size = var.asg_min_capacity
    max_size = var.asg_max_capacity
}

# Create an RDS (Relational Database Service)
module "RDS" {
    source = "../modules/rds"
    project_name = var.project_name
    private_sub_3_az1_id = module.VPC.private_sub_3_az1_id
    private_sub_4_az2_id = module.VPC.private_sub_4_az2_id
    db_username = var.rds_username
    db_password = var.rds_password
    db_sg_id = module.SG.db_sg_id
    db_name = var.rds_db_name
    rds_running_status = var.rds_running_status
}

# Create a Certificate for our service running on the webservers
module "CERTIFICATE" {
    source = "../modules/certificate"
    project_name = var.project_name
    hosted_zone_domain = var.hosted_zone_domain
    domain_name = var.domain_name
    alternative_domain_names = var.alternative_domain_names
}

# Create a CloudFront Distribution
module "CLOUDFRONT" {
    source = "../modules/cloudfront"
    project_name = var.project_name
    domain_name = var.domain_name
    alternative_domain_names = var.alternative_domain_names
    alb_domain_name = module.ALB.alb_domain_name
    hosted_zone_domain = var.hosted_zone_domain
    depends_on = [ module.CERTIFICATE.certificates_validation ] # Cloudfront should be created only when the certificates are valid
}

# Add record in route 53 hosted zone
module "ROUTE53" {
  source = "../modules/route53"
  cloudfront_domain_name = module.CLOUDFRONT.cloudfront_domain_name
  hosted_zone_domain = var.hosted_zone_domain
  domain_name = var.domain_name
  alternative_domain_names = var.alternative_domain_names
  record_names = [ var.domain_name, var.alternative_domain_names ]
  cloudfront_hosted_zone_id = module.CLOUDFRONT.cloudfront_hosted_zone_id
}
