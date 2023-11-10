## Variables VPC
variable "sgnode" {}

variable "sgcluster" {}

variable "vpc_cidr" {
  default = ""
}

variable "name_vpc" {
  default = ""
}

variable "igwname" {
  default = ""
}

variable "natname" {
  default = ""
}

variable "rtname" {
  default = ""
}

variable "instance_tenancy" {
  default = ""
}

variable "create_vpc" {}

variable "subnet-private" {}

variable "subnet-public" {}

variable "environment" {}

variable "cluster_name" {}

variable "k8s_version" {}

variable "create_eip" {}

variable "create_igw" {}

variable "create_nat" {}

variable "data" {}

variable "nodes" {
  description = "Map of EKS managed node group definitions to create"
  type        = any
  default     = {}
}
