resource "aws_route_table" "custom" {
  for_each = {for i, rtb in var.settings : i => rtb }

  vpc_id = each.value.vpc_id

  route {
      cidr_block = each.value.cidr_block
      nat_gateway_id = each.value.nat_gateway_id
      gateway_id = each.value.internet_gateway_id
  }
  tags = merge({ 
    Name = format("rtb-%s-%s", each.value.vpc_name, local.type_definition[each.key].result)
    Vpc_ID = each.value.vpc_id
    Vpc_Name = each.value.vpc_name
    Type  = local.type_definition[each.key].result}, 
    each.value.tags)

  lifecycle {
    create_before_destroy = false
    ignore_changes = [route]
  }
}