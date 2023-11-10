output "attributes" {
  value = aws_subnet.custom
}

output "public" {
  value = [for subnet in aws_subnet.custom : {
    id         = subnet.id
    cidr_block = subnet.cidr_block
  } if subnet.map_public_ip_on_launch ]
}

output "private" {
  value = [for subnet in aws_subnet.custom : {
    id         = subnet.id
    cidr_block = subnet.cidr_block
  } if !subnet.map_public_ip_on_launch ]
}
