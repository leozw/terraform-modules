output "attributes" {
    value = aws_nat_gateway.custom
}

output "ids" {
  value = [for ntg in aws_nat_gateway.custom : ntg.id]
}