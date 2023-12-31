resource "aws_secretsmanager_secret" "this" {
  name_prefix = "database/${var.name}/master-"
  description = "Master account password on ${var.name}"
}

resource "aws_secretsmanager_secret_version" "this" {
  secret_id     = aws_secretsmanager_secret.this.id
  secret_string = var.random_password
}
