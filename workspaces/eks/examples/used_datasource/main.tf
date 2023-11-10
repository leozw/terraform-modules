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
  vpc_id                   = data.aws_vpc.this.id
  source_security_group_id = module.sg-node.sg_id

  ingress_with_source_security_group = local.ingress_cluster
  ingress_with_cidr_blocks           = local.ingress_cluster_api

  tags = local.tags
}

module "sg-node" {
  source = "git@github.com:elvenworks-ps/professional-services.git//terraform-modules//sg"

  sgname                   = "sgnode"
  environment              = local.environment
  vpc_id                   = data.aws_vpc.this.id
  source_security_group_id = module.sg-cluster.sg_id

  ingress_with_source_security_group = local.ingress_node

  tags = local.tags
}

module "eks-master" {
  source = "git@github.com:elvenworks-ps/professional-services.git//terraform-modules//eks//master"

  cluster_name              = var.cluster_name
  master-role               = module.iam-eks.master-iam-arn
  kubernetes_version        = var.kubernetes_version
  subnet_ids                = concat(["${data.aws_subnets.private.ids[0]}", "${data.aws_subnets.private.ids[1]}", "${data.aws_subnets.private.ids[2]}"], ["${data.aws_subnets.public.ids[0]}", "${data.aws_subnets.public.ids[1]}", "${data.aws_subnets.public.ids[2]}"])
  security_group_ids        = [module.sg-cluster.sg_id]
  enabled_cluster_log_types = ["api", "audit", "authenticator"]
  environment               = local.environment
  endpoint_private_access   = var.endpoint_private_access
  endpoint_public_access    = var.endpoint_public_access
  #addons = local.addons

}

module "eks-node" {
  source = "git@github.com:elvenworks-ps/professional-services.git//terraform-modules//eks//nodes"

  cluster_name    = module.eks-master.cluster_name
  cluster_version = module.eks-master.cluster_version
  node_name       = "node-tools"
  node-role       = module.iam-eks.node-iam-arn
  private_subnet  = ["${data.aws_subnets.private.ids[0]}", "${data.aws_subnets.private.ids[1]}", "${data.aws_subnets.private.ids[2]}"]
  desired_size    = 1
  max_size        = 2
  min_size        = 1
  environment     = local.environment
  disk_size       = 60
  create_node     = true
  capacity_type   = "SPOT"
  max-pods        = 17
  use-max-pods    = false

  ## Labels
  #labels = {
  #  Environment = "tools"
  #}

  ## Taints
  #taints = {
  #  dedicated = {
  #    key    = "environment"
  #    value  = "tools"
  #    effect = "NO_SCHEDULE"
  #  }
  #}

  launch_create         = true
  name                  = var.launch
  security-group-node   = [module.sg-node.sg_id]
  endpoint              = module.eks-master.cluster_endpoint
  certificate_authority = module.eks-master.cluster_cert
  instance_types_launch = "t3.micro"

  tags = local.tags
}
