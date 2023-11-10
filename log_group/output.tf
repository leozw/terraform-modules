output "log_arn" {
  description = "Output log arn"
  value       = aws_cloudwatch_log_group.this.arn
}
