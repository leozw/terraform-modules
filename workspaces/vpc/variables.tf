variable "iam_role_arn" {
  description = "IAM role flow logs"
  type        = string
  default     = null
}

variable "create_vpc" {
  description = "Create vpc flow log"
  type        = bool
  default     = false
}

variable "create_aws_flow_log" {
  description = "Create vpc flow log"
  type        = bool
  default     = false
}

variable "log_destination_arn" {
  description = "ARN log_destination_arn"
  type        = string
  default     = null
}

variable "instance_tenancy" {
  description = "A tenancy option for instances launched into the VPC. Default is default"
  type        = string
  default     = "default"
}

variable "name" {
  description = "Name to be used on all the resources as identifier"
  type        = string
}

variable "cidr_block" {
  description = " The IPv4 CIDR block for the VPC."
  type        = string
}

variable "environment" {
  description = "Env tags"
  type        = string
  default     = null
}

variable "tags" {
  description = "A mapping of tags to assign to the resource"
  type        = map(any)
  default     = {}
}

variable "enable_dns_hostnames" {
  description = "Enable dns hostnames"
  type        = bool
  default     = true
}

variable "enable_dns_support" {
  description = "Enable dns support"
  type        = bool
  default     = true
}