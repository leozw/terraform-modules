#### SUBNETS
data "aws_availability_zones" "azs" {}

resource "aws_subnet" "private" {
  count      = length(var.private_subnets)
  vpc_id     = var.vpc_id
  cidr_block = element(var.private_subnets, count.index)
  availability_zone = element(data.aws_availability_zones.azs.names,
    count.index % length(data.aws_availability_zones.azs.names),
  )

  tags = merge(
    {
      "Name"     = format("private-${var.environment}-%s", element(data.aws_availability_zones.azs.names, count.index)),
      "Type"     = "subnet"
      "Platform" = "network"
      "Network"  = "Private"
    },
    var.private_subnets_tags,
  )
}


resource "aws_subnet" "public" {
  count      = length(var.public_subnets)
  vpc_id     = var.vpc_id
  cidr_block = element(var.public_subnets, count.index)
  availability_zone = element(data.aws_availability_zones.azs.names,
    count.index % length(data.aws_availability_zones.azs.names),
  )
  map_public_ip_on_launch = var.map_public_ip_on_launch

  tags = merge(
    {
      "Name"     = format("public-${var.environment}-%s", element(data.aws_availability_zones.azs.names, count.index)),
      "Type"     = "subnet"
      "Platform" = "network"
      "Network"  = "Public"
    },
    var.public_subnets_tags,
  )
}

## IGW
resource "aws_internet_gateway" "this" {
  count = var.create_igw ? 1 : 0

  vpc_id = var.vpc_id

  tags = merge(
    {
      "Name"     = format("%s-%s", var.igwname, var.environment)
      "Platform" = "network"
      "Type"     = "IGW"
    },
    var.tags,

  )
}

### NAT

resource "aws_eip" "this" {
  count = var.create_eip ? 1 : 0

  vpc = true

  tags = merge(
    {
      "Name"     = format("%s-elastic-ip-%s", var.natname, var.environment)
      "Platform" = "network"
      "Type"     = "nat"
    },
    var.tags,
  )

}

resource "aws_nat_gateway" "this" {
  count = var.create_nat ? 1 : 0

  allocation_id     = aws_eip.this[0].id
  subnet_id         = aws_subnet.public[0].id
  connectivity_type = "public"

  tags = merge(
    {
      "Name"     = format("%s-%s", var.natname, var.environment)
      "Platform" = "network"
      "Type"     = "nat"
    },
    var.tags,
  )

  depends_on = [aws_internet_gateway.this[0]]
}


## ROUTES

resource "aws_route_table" "public" {
  vpc_id = var.vpc_id

  dynamic "route" {
    for_each = var.route_table_routes_public
    content {
      cidr_block = try(route.value.cidr_block, "0.0.0.0/0")

      egress_only_gateway_id    = try(route.value.egress_only_gateway_id, "")
      gateway_id                = try(route.value.gateway_id, "")
      nat_gateway_id            = try(route.value.nat_gateway_id, "")
      network_interface_id      = try(route.value.network_interface_id, "")
      transit_gateway_id        = try(route.value.transit_gateway_id, "")
      vpc_endpoint_id           = try(route.value.vpc_endpoint_id, "")
      vpc_peering_connection_id = try(route.value.vpc_peering_connection_id, "")
    }
  }

  tags = merge(
    {
      "Name"     = format("public-%s-%s", var.rtname, var.environment)
      "Platform" = "network"
      "Type"     = "route-table"
      "Network"  = "Public"
    },
    var.tags,

  )
}


resource "aws_route_table" "private" {
  vpc_id = var.vpc_id

  dynamic "route" {
    for_each = var.route_table_routes_private
    content {
      cidr_block = try(route.value.cidr_block, "0.0.0.0/0")

      egress_only_gateway_id    = try(route.value.egress_only_gateway_id, "")
      gateway_id                = try(route.value.gateway_id, "")
      nat_gateway_id            = try(route.value.nat_gateway_id, "")
      network_interface_id      = try(route.value.network_interface_id, "")
      transit_gateway_id        = try(route.value.transit_gateway_id, "")
      vpc_endpoint_id           = try(route.value.vpc_endpoint_id, "")
      vpc_peering_connection_id = try(route.value.vpc_peering_connection_id, "")
    }
  }

  tags = merge(
    {
      "Name"     = format("private-%s-%s", var.rtname, var.environment)
      "Platform" = "network"
      "Type"     = "route-table"
      "Network"  = "Private"
    },
    var.tags,

  )
}

resource "aws_route_table_association" "private" {
  count          = length(var.private_subnets)
  subnet_id      = element(aws_subnet.private[*].id, count.index)
  route_table_id = element(aws_route_table.private[*].id, count.index)
}

resource "aws_route_table_association" "public" {
  count          = length(var.public_subnets)
  subnet_id      = element(aws_subnet.public[*].id, count.index)
  route_table_id = element(aws_route_table.public[*].id, count.index)
}
