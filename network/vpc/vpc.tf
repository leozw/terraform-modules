resource "aws_vpc" "vpc" {
  cidr_block           = var.settings.cidr
  enable_dns_support   = var.settings.enable_dns_support
  enable_dns_hostnames = var.settings.enable_dns_hostnames

  tags = merge({ 
    Name = var.settings.name
    }, 
    var.settings.tags)

  lifecycle {
    create_before_destroy = false
  }
}                           
