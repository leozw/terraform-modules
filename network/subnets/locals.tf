locals {
  configs = flatten([
    for type, count in var.counts : [
      for index in range(count) : {
        unique_key              = format("%s-%02d", type, index + 1)
        cidr_block              = type != "public" ? cidrsubnet(var.settings.vpc_cidr, 
        var.settings.newbits, index) : cidrsubnet(var.settings.vpc_cidr, 
        var.settings.newbits, index + var.counts["private"])
        type                    = type
        availability_zone       = element(
          data.aws_availability_zones.available.names,
          index % length(data.aws_availability_zones.available.names),
        )
        map_public_ip_on_launch = type != "public" ? false : true
        vpc_cidr                = var.settings.vpc_cidr
        vpc_id                  = var.settings.vpc_id
      }
    ]
  ])
}
