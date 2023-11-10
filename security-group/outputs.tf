output "security_group_id" {
    value = join(",", aws_security_group.custom.*.id)
}
output "attributes" {
  value = aws_security_group.custom
}