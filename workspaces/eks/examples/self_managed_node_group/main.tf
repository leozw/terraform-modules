locals {
  environment = "develop"
  tags = {
    Environment = "develop"
  }
  # addons = {
  #   "ebs-csi-controller-sa" = {
  #     "name"       = "aws-ebs-csi-driver"
  #     "data"       = "ebs-csi-controller-sa"
  #     "policy_arn" = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
  #     "version"    = "v1.14.1-eksbuild.1"
  #   }
  #}
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
  environment               = local.environment
  endpoint_private_access   = var.endpoint_private_access
  endpoint_public_access    = var.endpoint_public_access
  ##Create aws-auth
  create_aws_auth_configmap = true
  manage_aws_auth_configmap = true
  node-role                 = module.iam-eks.node-iam-arn
  #addons = local.addons

}

module "eks-node-spot" {
  source = "git@github.com:elvenworks-ps/professional-services.git//terraform-modules//eks//nodes"

  cluster_name    = module.eks-master.cluster_name
  cluster_version = module.eks-master.cluster_version
  desired_size    = 1
  max_size        = 2
  min_size        = 1
  environment     = local.environment
  create_node     = false

  ## lt
  launch_create         = true
  name                  = var.launch
  max-pods              = 17
  use-max-pods          = true
  security-group-node   = [module.sg-node.sg_id]
  endpoint              = module.eks-master.cluster_endpoint
  certificate_authority = module.eks-master.cluster_cert
  instance_types_launch = "t3.micro"
  iam_instance_profile  = module.iam-eks.node-iam-name-profile
  volume-size           = 30

  ## ASG
  name_asg                   = "asg"
  vpc_zone_identifier        = [module.vpc.private_ids[2]]
  asg_create                 = true
  capacity_rebalance         = true
  default_cooldown           = 300
  use_mixed_instances_policy = true
  mixed_instances_policy = {
    instances_distribution = {
      on_demand_base_capacity                  = 0
      on_demand_percentage_above_base_capacity = 0
      spot_allocation_strategy                 = "price-capacity-optimized"
      spot_instance_pools                      = 0
    }
    override = [
      {
        instance_type = "t3.medium"
      },
      {
        instance_type = "t3a.medium"
      }
    ]

  }

  termination_policies = ["AllocationStrategy", "OldestLaunchTemplate", "OldestInstance"]
  extra_tags = [
    {
      key                 = "Environment"
      value               = "${local.environment}"
      propagate_at_launch = true
    },
    {
      key                 = "Name"
      value               = "${local.environment}"
      propagate_at_launch = true
    },
    {
      key                 = "kubernetes.io/cluster/${module.eks-master.cluster_name}"
      value               = "owned"
      propagate_at_launch = true
    }
  ]

  tags = local.tags
}
