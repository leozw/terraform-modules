locals {

  tags = {
    environment = "${terraform.workspace}"
  }

  env_prd = "prd"
}

module "vpc" {
  source = "../../vpc"

  name                 = var.name_vpc
  create_vpc           = var.create_vpc
  cidr_block           = var.vpc_cidr
  instance_tenancy     = var.instance_tenancy
  enable_dns_support   = true
  enable_dns_hostnames = true
  environment          = var.environment

  tags = local.tags
}

module "subnet-prd" {
  source = "../../subnet"

  private_subnets         = var.subnet-private
  public_subnets          = var.subnet-public
  map_public_ip_on_launch = true

  igwname = var.igwname
  natname = var.natname
  rtname  = var.rtname

  public_subnets_tags  = local.public_subnets_tags
  private_subnets_tags = local.private_subnets_tags

  route_table_routes_private = {
    "nat" = {
      "nat_gateway_id" = var.data == false ? "${module.subnet-prd.nat}" : "${data.terraform_remote_state.this[0].outputs.nat}"
    }
  }
  route_table_routes_public = {
    "igw" = {
      "gateway_id" = var.data == false ? "${module.subnet-prd.igw}" : "${data.terraform_remote_state.this[0].outputs.igw}"
    }
  }
  vpc_id      = var.data == false ? module.vpc.vpc_id : data.terraform_remote_state.this[0].outputs.vpc_id[0]
  environment = var.environment
  create_nat  = var.create_nat
  create_igw  = var.create_igw
  create_eip  = var.create_eip

  tags = local.tags
}

# ### EKS

module "iam-eks" {
  source = "../../eks/iam-eks"

  cluster_name = var.cluster_name
  environment  = var.environment
}

###SG_EKS

module "sg-cluster" {
  source = "../../sg"

  sgname                             = var.sgcluster
  environment                        = var.environment
  vpc_id                             = var.data == false ? module.vpc.vpc_id : data.terraform_remote_state.this[0].outputs.vpc_id[0]
  source_security_group_id           = module.sg-node.sg_id
  ingress_with_source_security_group = local.ingress_cluster
  ingress_with_cidr_blocks           = local.ingress_cluster_api
  tags                               = local.tags
}

module "sg-node" {
  source = "../../sg"

  sgname                             = var.sgnode
  environment                        = var.environment
  vpc_id                             = var.data == false ? module.vpc.vpc_id : data.terraform_remote_state.this[0].outputs.vpc_id[0]
  source_security_group_id           = module.sg-cluster.sg_id
  ingress_with_source_security_group = local.ingress_node
  tags                               = local.tags
}

module "eks-master" {
  source = "../../eks/master"

  cluster_name            = var.cluster_name
  master-role             = module.iam-eks.master-iam-arn
  kubernetes_version      = var.k8s_version
  subnet_ids              = concat(tolist(module.subnet-prd.private_ids), tolist(module.subnet-prd.public_ids))
  security_group_ids      = [module.sg-cluster.sg_id]
  environment             = var.environment
  endpoint_private_access = true
  endpoint_public_access  = true
}

module "eks-node" {
  source = "../../eks/nodes"

  for_each = var.nodes

  cluster_name    = module.eks-master.cluster_name
  cluster_version = try(module.eks-master.cluster_version, null)
  node-role       = try(module.iam-eks.node-iam-arn, null)
  private_subnet  = module.subnet-prd.private_ids
  node_name       = try(each.value.node_name, null)
  desired_size    = try(each.value.desired_size, null)
  max_size        = try(each.value.max_size, null)
  min_size        = try(each.value.min_size, null)
  environment     = var.environment
  instance_types  = try(each.value.instance_types, [])
  disk_size       = try(each.value.disk_size, null)
  capacity_type   = try(each.value.capacity_type, "ON_DEMAND")
  create_node     = try(each.value.create_node, false)

  labels = try(each.value.labels, {})
  taints = try(each.value.taints, {})

  launch_create         = try(each.value.launch_create, false)
  name                  = try(each.value.name_lt, null)
  instance_types_launch = try(each.value.instance_types_launch, "")
  volume-size           = try(each.value.volume-size, null)
  volume-type           = try(each.value.volume-type, null)
  security-group-node   = try([module.sg-node.sg_id], null)
  endpoint              = try(module.eks-master.cluster_endpoint, "")
  certificate_authority = try(module.eks-master.cluster_cert, "")

  create_fargate       = try(each.value.create_fargate, false)
  fargate_profile_name = try(each.value.fargate_profile_name, null)
  selectors            = try(each.value.selectors, [])

  tags = local.tags
}
