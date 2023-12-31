locals {
  environment = "staging"
  tags = {
    Environment = "staging"
  }
}

module "vpc" {
  source = "../"

  name                 = var.name
  cidr_block           = var.cidr_block
  instance_tenancy     = var.instance_tenancy
  enable_dns_support   = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames

  tags        = local.tags
  environment = local.environment

  private_subnets         = var.private_subnets
  public_subnets          = var.public_subnets
  map_public_ip_on_launch = var.map_public_ip_on_launch

  igwname = var.igwname
  natname = var.natname
  rtname  = var.rtname

  route_table_routes_private = {
    "nat" = {
      "cidr_block"     = "0.0.0.0/0"
      "nat_gateway_id" = "${module.vpc.nat}"
    }
    ## add block to create route in subnet-public
    "peer" = {
      "cidr_block"                = "10.10.0.0/16"
      "vpc_peering_connection_id" = "pcx-xxxxxxxxxxxxx"
    }
  }
  route_table_routes_public = {
    "igw" = {
      "cidr_block" = "0.0.0.0/0"
      "gateway_id" = "${module.vpc.igw}"
    }
    ## add block to create route in subnet-private
    "peer" = {
      "cidr_block"                = "10.10.0.0/16"
      "vpc_peering_connection_id" = "pxc-xxxxxxxxxxxxxxx"
    }

  }
}
