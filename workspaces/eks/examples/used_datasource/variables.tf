## Variables EKS

variable "launch" {
  description = "Name launch template"
  type        = string
  default     = "lt-eks"
}

variable "cluster_name" {
  description = "Name cluster"
  type        = string
  default     = "develop"
}

variable "kubernetes_version" {
  description = "Version cluster"
  type        = string
  default     = "1.23"
}

variable "endpoint_public_access" {
  description = "Endpoint access public"
  type        = bool
  default     = true
}

variable "endpoint_private_access" {
  description = "Endpoint access private"
  type        = bool
  default     = true
}

variable "instance_types" {
  description = "Type instances"
  type        = list(string)
  default     = ["t3a.micro"]
}
