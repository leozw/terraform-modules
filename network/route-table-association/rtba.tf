resource "aws_route_table_association" "custom" {
  for_each = { for i, c in local.configs: i => c }
  subnet_id      = each.value.subnet_id
  route_table_id = each.value.route_table_id
}