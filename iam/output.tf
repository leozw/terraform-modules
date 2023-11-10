output "arn" {
  description = "Output role arn"
  value       = try(aws_iam_role.this[0].arn, "")
}

output "name" {
  description = "Output role name"
  value       = try(aws_iam_role.this[0].name, "")
}