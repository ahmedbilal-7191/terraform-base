output "Instance_id" {
  value = aws_instance.ec2.id
}
output "cloudwatch_alarm_name" {
  value = aws_cloudwatch_metric_alarm.cpu_alarm.alarm_name
}
