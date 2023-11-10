variable "environment" {
  description = "Env tags"
  type        = string
  default     = null
}

variable "cluster_name" {
  default = ""
}

variable "domain" {
  description = "Domain used helm External dns"
  type        = string
  default     = ""
}

variable "custom_helm" {
  description = "Custom a Release is an instance of a chart running in a Kubernetes cluster."
  type        = map(any)
  default     = {}
}

variable "custom_values_alb" {
  description = "Custom controler alb a Release is an instance of a chart running in a Kubernetes cluster"
  type        = any
  default     = {}
}

variable "custom_values_ebs" {
  description = "Custom controller ebs a Release is an instance of a chart running in a Kubernetes cluster"
  type        = any
  default     = {}
}

variable "custom_values_asg" {
  description = "Custom controller asg a Release is an instance of a chart running in a Kubernetes cluster"
  type        = any
  default     = {}
}

variable "custom_values_external-dns" {
  description = "Custom external-dns a Release is an instance of a chart running in a Kubernetes cluster"
  type        = any
  default     = {}
}

variable "custom_values_metrics-server" {
  description = "Custom metrics-server a Release is an instance of a chart running in a Kubernetes cluster"
  type        = any
  default     = {}
}

variable "aws-ebs-csi-driver" {
  description = "Install release helm controller ebs"
  type        = bool
  default     = false
}

variable "aws-load-balancer-controller" {
  description = "Install release helm controller alb"
  type        = bool
  default     = false
}

variable "external-dns" {
  description = "Install release helm external"
  type        = bool
  default     = false
}

variable "metrics-server" {
  description = "Install release helm metrics-server"
  type        = bool
  default     = false
}

variable "aws-autoscaler-controller" {
  description = "Install release helm controller asg"
  type        = bool
  default     = false
}

variable "velero" {
  description = "Install release helm velero "
  type        = bool
  default     = false
}

variable "custom_values_velero" {
  description = "Custom velero a Release is an instance of a chart running in a Kubernetes cluster"
  type        = any
  default     = {}
}

variable "tags" {
  description = "A mapping of tags to assign to the resource"
  type        = map(string)
  default     = {}
}

variable "force_destroy" {
  description = "Boolean that indicates all objects (including any locked objects) should be deleted from the bucket when the bucket is destroyed so that the bucket can be destroyed without error"
  type        = bool
  default     = false
}

variable "ingress-nginx" {
  description = "Install release helm controller ingress-nginx"
  type        = bool
  default     = false
}

variable "cert-manager" {
  description = "Install release helm controller cert-manager"
  type        = bool
  default     = false
}