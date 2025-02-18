# project3-2tierapp-terraform

This is a project I followed using:
https://github.com/AnkitJodhani/3rdWeekofCloudOps

![51814577-04cf-4708-a61d-7c97c444e8f8](https://github.com/user-attachments/assets/873d3c8d-c5ee-425c-a551-f64af86d99f5)


There was a few issues with the original project.
First, the webservers don't even use the databases so in terms of an entire project - this is not a 2 tier application (even though it might appear like it in TF)


a Short explanation of what did work:

Using Terraform & Modules we are creating:
1. a VPC using 2 availability zones. 2 public subnets routed through an **internet gateway**, 4 private subnets (1public, 2 private for each availability zone)
2. 2 x NAT gateway in the 2 public subnets (with 2 public IPs) - one in each of the availability zones, route tables for the private subnets to go through the NAT gateways.
3. a CloudFront Service to expose the load Balancer.
4. Application Load balancer, to be available on both public subnets & communicate with the Auto Scaling Group.
5. Auto Scaling Group, to deploy on the first 2 private subnets, will be used as our Web Servers.
6. an RDS (Relational Database Service) to be deployed on the last 2 private subnets, (master-slave), running mysql 5.7.
7. Single EC2 server in the first public subnet to be used for our Admin connections into all the services. (debug/verify etc)
8. Security groups: loadbalancer group to allow tcp-port80/443 from the internet
                    webserver group to allow port 80 from the loadbalancer group # improve to add port 22 from the jump server group too
                    db group to allow port 3306 from the webserver group
                    jump server group to allow port 22 from the internet # improve this for just specific IPs [admin access]
9. Certificate creation for out domain.
10. Route 53 management - records for the certificate process, records for pointing our domain to the cloudfront etc. # Improve this for Hosted zone creation
