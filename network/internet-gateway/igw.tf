resource "aws_internet_gateway" "custom" {
  count = var.settings.igw_count

  vpc_id = var.settings.vpc_id

  tags = merge({ 
    Name = format("igw-%s-%02d", var.settings.vpc_name, count.index + 1)
    Vpc_ID = var.settings.vpc_id
    Vpc_Name = var.settings.vpc_name
    }, 
    var.settings.tags)
}