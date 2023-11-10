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
      Environment = "stg"
    }
    taints = {
      dedicated = {
        key    = "environment"
        value  = "stg"
        effect = "NO_SCHEDULE"
      }
    }
  }
}

rtname       = "rt"
cluster_name = "k8s"
k8s_version  = "1.23"
create_eip   = false
create_igw   = false
create_nat   = false
create_vpc   = false
data         = true

sgnode         = "sgnode"
sgcluster      = "sgcluster"
subnet-private = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
subnet-public  = ["10.0.104.0/24", "10.0.105.0/24", "10.0.106.0/24"]

environment = "stg"
