resource "aws_eip" "custom" {
  for_each = { for i, ntg in var.settings: i => ntg if ntg.create_eip }
  vpc = true
  
  tags = merge({ 
    Name = format("nat-eip-%s-%02d", each.value.vpc_name, each.key + 1)
    Vpc_ID = each.value.vpc_id
    Vpc_Name = each.value.vpc_name
    }, 
    each.value.tags)

}

resource "aws_nat_gateway" "custom" {
  for_each = {for i, ntg in var.settings: i => ntg }  
  allocation_id = each.value.create_eip ? aws_eip.custom[each.key].id : null
  subnet_id     = each.value.subnet_id
  connectivity_type = each.value.connectivity_type
  
  tags = merge({ 
    Name = format("nat-%s-%02d", each.value.vpc_name, each.key + 1)
    Vpc_ID = each.value.vpc_id
    Vpc_Name = each.value.vpc_name
    Subnet_ID = each.value.subnet_id
    }, 
    each.value.tags)
}
