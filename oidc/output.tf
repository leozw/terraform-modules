output "arn" {
  description = "Output oidc arn"
  value       = [ for v in aws_iam_openid_connect_provider.this : v.arn ]
}