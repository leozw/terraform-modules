nodes = {
  infra = {
    create_node    = true
    node_name      = "infra"
    desired_size   = 1
    max_size       = 2
    min_size       = 1
    instance_types = ["t3.medium"]
    disk_size      = 20
    labels = {
      Environment = "prd"
    }
    taints = {
      dedicated = {
        key    = "environment"
        value  = "prd"
        effect = "NO_SCHEDULE"
      }
    }
  }
  infra-lt = {
    create_node           = true
    launch_create         = true
    node_name             = "infra-lt"
    name_lt               = "lt"
    node_name             = "infra-lt"
    desired_size          = 1
    max_size              = 2
    min_size              = 1
    instance_types_launch = "t3.medium"
    volume-size           = 20
    volume-type           = "gp3"


    labels = {
      Environment = "prd"
    }
    taints = {
      dedicated = {
        key    = "environment"
        value  = "prd"
        effect = "NO_SCHEDULE"
      }
    }
  }
  infra-fargate = {
    create_node          = false
    create_fargate       = true
    fargate_profile_name = "infra-fargate"
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
  }
}

rtname       = "rt"
natname      = "nat"
igwname      = "igw"
name_vpc     = "vpc"
create_vpc   = true
cluster_name = "k8s"
k8s_version  = "1.23"
create_eip   = true
create_igw   = true
create_nat   = true
data = false

sgnode         = "sgnode"
sgcluster      = "sgcluster"
subnet-private = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
subnet-public  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

vpc_cidr         = "10.0.0.0/16"
environment      = "prd"
instance_tenancy = "default"

