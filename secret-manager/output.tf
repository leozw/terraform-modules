output "arn" {
  description = "Result password"
  value       = aws_secretsmanager_secret_version.this.arn
}