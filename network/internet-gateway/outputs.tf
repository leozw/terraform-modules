output "attributes" {
  value = aws_internet_gateway.custom
}
output "ids" {
  value = [for igw in aws_internet_gateway.custom : igw.id]
}