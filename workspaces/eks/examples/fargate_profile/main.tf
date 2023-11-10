locals {
  environment = "develop"
  tags = {
    Environment = "develop"
  }
}

#### VPC
module "vpc" {
  source = "git@github.com:elvenworks-ps/professional-services.git//terraform-modules//vpc"

  name                 = var.name_vpc
  cidr_block           = var.cidr_block
  instance_tenancy     = var.instance_tenancy
  enable_dns_support   = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames

  tags = local.tags

  public_subnets_tags  = local.public_subnets_tags
  private_subnets_tags = local.private_subnets_tags

  private_subnets         = var.private_subnets
  public_subnets          = var.public_subnets
  map_public_ip_on_launch = var.map_public_ip_on_launch
  environment             = local.environment

  igwname = var.igwname
  natname = var.natname
  rtname  = var.rtname

  route_table_routes_private = {
    "nat" = {
      "cidr_block"     = "0.0.0.0/0"
      "nat_gateway_id" = "${module.vpc.nat}"
    }
  }
  route_table_routes_public = {
    "igw" = {
      "cidr_block" = "0.0.0.0/0"
      "gateway_id" = "${module.vpc.igw}"
    }
  }
}

### EKS

module "iam-eks" {
  source = "git@github.com:elvenworks-ps/professional-services.git//terraform-modules//eks//iam-eks"

  cluster_name = var.cluster_name
  environment  = local.environment

}

##SG_EKS
module "sg-cluster" {
  source = "git@github.com:elvenworks-ps/professional-services.git//terraform-modules//sg"

  sgname                   = "sgcluster"
  environment              = local.environment
  vpc_id                   = module.vpc.vpc_id
  source_security_group_id = module.sg-node.sg_id

  ingress_with_source_security_group = local.ingress_cluster
  ingress_with_cidr_blocks           = local.ingress_cluster_api

  tags = local.tags
}

module "sg-node" {
  source = "git@github.com:elvenworks-ps/professional-services.git//terraform-modules//sg"

  sgname                   = "sgnode"
  environment              = local.environment
  vpc_id                   = module.vpc.vpc_id
  source_security_group_id = module.sg-cluster.sg_id

  ingress_with_source_security_group = local.ingress_node

  tags = local.tags
}

module "eks-master" {
  source = "git@github.com:elvenworks-ps/professional-services.git//terraform-modules//eks//master"

  cluster_name              = var.cluster_name
  master-role               = module.iam-eks.master-iam-arn
  kubernetes_version        = var.kubernetes_version
  subnet_ids                = concat(tolist(module.vpc.private_ids), tolist(module.vpc.public_ids))
  security_group_ids        = [module.sg-cluster.sg_id]
  enabled_cluster_log_types = ["api", "audit", "authenticator"]
  environment               = local.environment
  endpoint_private_access   = var.endpoint_private_access
  endpoint_public_access    = var.endpoint_public_access

}

module "fargate-profile" {
  source = "git@github.com:elvenworks-ps/professional-services.git//terraform-modules//eks//nodes"
   
  environment     = local.environment
  create_node     = false
  cluster_name    = module.eks-master.cluster_name

  create_fargate = true
  selectors = [
        {
          namespace = "kube-system"
          labels = {
            k8s-app = "kube-dns"
          }
        },
        {
          namespace = "default"
        }
      ]

  tags = local.tags
}
