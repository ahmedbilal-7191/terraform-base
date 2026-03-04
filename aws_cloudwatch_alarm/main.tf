provider "aws" {
  region = "us-west-2"
}

resource "aws_instance" "ec2" {
  ami = "ami-05ee755be0cd7555c"
  instance_type = "t2.micro"
  tags = {
    Name = "cloudwatch-cpu-lab"
  }
}

resource "aws_cloudwatch_metric_alarm" "cpu_alarm" {
  metric_name = "CPUUtilization"
  namespace = "AWS/EC2"
  comparison_operator = "GreaterThanThreshold"
  threshold = 70
  evaluation_periods = 2
  period = 300
  statistic = "Average"
  alarm_name = "high-cpu-utilization-alarm"
  dimensions = {
    InstanceId = aws_instance.ec2.id
  }
  alarm_description = "Alarm when server CPU exceeds 70%"
  actions_enabled = false
}
