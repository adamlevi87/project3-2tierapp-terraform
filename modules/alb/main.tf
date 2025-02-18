# Create a Public Application Load Balancer in the 2 public subnets under the alb_sg
resource "aws_lb" "application_load_balancer" {
    name = "${var.project_name}-alb"
    internal = false
    load_balancer_type = "application"
    security_groups = [ var.alb_sg_id ]
    subnets = [ var.public_sub_1_az1_id, var.public_sub_2_az2_id ]
    enable_deletion_protection = false

    tags = {
      Name = "${var.project_name}-alb"
      Project = var.project_name
    }
}

# Create a Load Balancer target group (EC2, HTTP/port80)
resource "aws_lb_target_group" "alb_http_target_group" {
    name = "${var.project_name}-http-tg"
    target_type = "instance"
    port = 80
    protocol = "HTTP"
    vpc_id = var.vpc_id

    health_check {
        enabled = true
        interval = 300 # seconds
        path = "/"
        timeout = 60 # seconds
        matcher = 200 # return code for http 200 = OK
        healthy_threshold = 5 # Number of checks to be marked Healthy
        unhealthy_threshold = 5 # Number of checks to be marked unHealthy
    }

    lifecycle {
        # Protection - if changes will require a recreation -
        # a new object will be created before the destruction of the old one
        create_before_destroy = true
    }

    tags = {
      Name = "${var.project_name}-http-tg"
      Project = var.project_name
    }
}

# Create alb listener - Listen and Route [forward] Traffic
resource "aws_lb_listener" "alb_http_listener" {
    load_balancer_arn = aws_lb.application_load_balancer.arn
    port = 80
    protocol = "HTTP"

    default_action {
        type = "forward"
        target_group_arn = aws_lb_target_group.alb_http_target_group.arn
    }

    tags = {
        Name = "${var.project_name}-alb-http-listener"
        Project = var.project_name
    }
}