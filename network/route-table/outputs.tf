output "attributes" {
  value = aws_route_table.custom
}
output "public_ids" {
  value = [for rtb in aws_route_table.custom : rtb.id if tolist(rtb.route)[0].gateway_id != ""]
}

output "private_ids" {
  value = [for rtb in aws_route_table.custom : rtb.id  if tolist(rtb.route)[0].nat_gateway_id != "" ]
}