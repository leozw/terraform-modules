output "arn" {
  description = "Output arn parameter"
  value       = [for v in aws_ssm_parameter.secret : v.arn]
}