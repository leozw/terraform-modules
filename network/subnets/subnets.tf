resource "aws_subnet" "custom" {
  for_each = {for c in local.configs : c.unique_key => c }

  vpc_id = each.value.vpc_id
  availability_zone = each.value.availability_zone
  cidr_block = each.value.cidr_block
  
  map_public_ip_on_launch = each.value.map_public_ip_on_launch
  
  tags = merge({ 
    Name = format("%s-%s", each.key, each.value.availability_zone)
    Vpc_ID = var.settings.vpc_id
    Vpc_Name = var.settings.vpc_name
    Availability_Zone = each.value.availability_zone
    }, 
    var.settings.tags)
}