locals {
  
  ingress_cluster = {
    "ingress_rule_1" = {
      "from_port" = "443"
      "to_port"   = "443"
      "protocol"  = "tcp"
    },
  }

  ingress_node = {
    "ingress_rule_1" = {
      "from_port" = "1025"
      "to_port"   = "65535"
      "protocol"  = "tcp"
    },
    "ingress_rule_2" = {
      "from_port" = "0"
      "to_port"   = "65535"
      "protocol"  = "-1"
    },
  }

  ingress_cluster_api = {
    "ingress_rule_1" = {
      "from_port"   = "443"
      "to_port"     = "443"
      "protocol"    = "tcp"
      "cidr_blocks" = ["${data.aws_vpc.this.vpc_cidr}"]
    },
  }
}
