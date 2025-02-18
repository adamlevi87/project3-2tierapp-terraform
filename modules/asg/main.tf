# Create a launch template to be used by the Auto Scaling Group
# It is Similar to the creation of the jump server
resource "aws_launch_template" "launch_template" {
    name = "${var.project_name}-launch-template"
    image_id = var.ami
    instance_type = var.cpu
    key_name = var.key_name
    user_data = filebase64("../modules/asg/config.sh")
    vpc_security_group_ids = [ var.asg_sg_id ]

    tags = {
      Name = "${var.project_name}-launch-template"
      Project = var.project_name
    } 
}

# Create a Auto Scaling Group
resource "aws_autoscaling_group" "auto_scale_group" {
    name = "${var.project_name}-asg"
    launch_template {
      id = aws_launch_template.launch_template.id
      version = "$Latest"
    }
    vpc_zone_identifier = [ var.private_sub_1_az1_id, var.private_sub_2_az2_id ]
    target_group_arns = [var.target_group_http_arn ]
    health_check_grace_period = 300 # Seconds
    health_check_type = "ELB"
    desired_capacity = var.desired_capacity
    min_size = var.min_size
    max_size = var.max_size
    
    enabled_metrics = [
      "GroupMinSize",
      "GroupMaxSize",
      "GroupDesiredCapacity",
      "GroupInServiceInstances",
      "GroupTotalInstances"
    ]
    metrics_granularity = "1Minute"

    tag {
      key = "Project"
      value = var.project_name
      propagate_at_launch = true
    }
}

# Create a Scale Up policy for the Auto Scaling Group
resource "aws_autoscaling_policy" "asg_scale_up" {
    name                   = "${var.project_name}-asg-scale-up"
    autoscaling_group_name = aws_autoscaling_group.auto_scale_group.name
    adjustment_type        = "ChangeInCapacity"
    scaling_adjustment     = "1" # Increase ASG Instance count by 1 
    cooldown               = "300"
    policy_type            = "SimpleScaling"
}

# Create a Scale Up Alarm
# The Alarm will trigger the ASG policy (scale up) based on the metric (CPUUtilization), comparison_operator, threshold
resource "aws_cloudwatch_metric_alarm" "asg_scale_up_alarm" {
    alarm_name          = "${var.project_name}-asg-scale-up-alarm"
    alarm_description   = "asg-scale-up-cpu-alarm"
    comparison_operator = "GreaterThanOrEqualToThreshold"
    evaluation_periods  = "2"
    metric_name         = "CPUUtilization"
    namespace           = "AWS/EC2"
    period              = "120"
    statistic           = "Average"
    threshold           = "30" # New instance will be created once CPU utilization is higher than 30 %
    dimensions = {
      "AutoScalingGroupName" = aws_autoscaling_group.auto_scale_group.name
    }
    actions_enabled = true
    alarm_actions   = [ aws_autoscaling_policy.asg_scale_up.arn ]

    tags = {
      Name = "${var.project_name}-asg-scale-up-alarm"
      Project = var.project_name
    }
}

# Create a Scale Down policy for the Auto Scaling Group
resource "aws_autoscaling_policy" "asg_scale_down" {
    name                   = "${var.project_name}-asg-scale-down"
    autoscaling_group_name = aws_autoscaling_group.auto_scale_group.name
    adjustment_type        = "ChangeInCapacity"
    scaling_adjustment     = "-1" # Decrease ASG Instance count by 1 
    cooldown               = "300"
    policy_type            = "SimpleScaling"
}

# Create a Scale Down Alarm
# The Alarm will trigger the ASG policy (scale down) based on the metric (CPUUtilization), comparison_operator, threshold
resource "aws_cloudwatch_metric_alarm" "asg_scale_down_alarm" {
    alarm_name          = "${var.project_name}-asg-scale-down-alarm"
    alarm_description   = "asg-scale-down-cpu-alarm"
    comparison_operator = "LessThanOrEqualToThreshold"
    evaluation_periods  = "2"
    metric_name         = "CPUUtilization"
    namespace           = "AWS/EC2"
    period              = "120"
    statistic           = "Average"
    threshold           = "5" # an Instance will scale down when CPU utilization is lower than 5 %
    dimensions = {
      "AutoScalingGroupName" = aws_autoscaling_group.auto_scale_group.name
    }
    actions_enabled = true
    alarm_actions   = [ aws_autoscaling_policy.asg_scale_down.arn ]

    tags = {
      Name = "${var.project_name}-asg-scale-down-alarm"
      Project = var.project_name
    }
}