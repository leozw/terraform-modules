locals {

  public_subnets_tags = {
    "kubernetes.io/cluster/${var.cluster_name}-${var.environment}" = "shared",
    "kubernetes.io/role/elb"                                       = 1
  }

  private_subnets_tags = {
    "kubernetes.io/cluster/${var.cluster_name}-${var.environment}" = "shared",
    "kubernetes.io/role/internal-elb"                              = 1
  }

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
      "cidr_blocks" = var.data == false ? ["${module.vpc.vpc_cidr}"] : ["${data.terraform_remote_state.this[0].outputs.cidr_block[0]}"]
    },
  }

}
