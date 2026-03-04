provider "aws" {
  region = "us-west-2"
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "public" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

resource "aws_launch_template" "app_lt" {
  name_prefix   = "app-launch-template"
  image_id      = var.ami_id # Example: Amazon Linux 2023 AMI in us-west-2
  instance_type = "t2.micro"

  # User Data - Encoded as base64
  user_data = filebase64("${path.module}/user_data.sh")

  # EC2 Configurations

  network_interfaces {
    associate_public_ip_address = true
    # If not specified, it uses the default SG of the VPC
    security_groups = [] 
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "asg-instance"
    }
  }
}

# 4. Create Auto Scaling Group
resource "aws_autoscaling_group" "app_asg" {
  desired_capacity    = 1
  max_size            = 2
  min_size            = 1
  vpc_zone_identifier = data.aws_subnets.public.ids # Using fetched default subnets

  launch_template {
    id      = aws_launch_template.app_lt.id
    version = "$Latest" # Use the latest version of the launch template
  }

  tag {
    key                 = "Name"
    value               = "asg-instance"
    propagate_at_launch = true
  }
}
