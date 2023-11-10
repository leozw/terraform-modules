variable "vpc_id" {
  type    = string
  default = ""
}

variable "create_igw" {
  type    = bool
  default = false
}

variable "create_nat" {
  type    = bool
  default = false
}

variable "create_eip" {
  type    = bool
  default = false
}


variable "environment" {
  description = "Env tags"
  type        = string
  default     = null
}

variable "route_table_routes_private" {
  type    = map(any)
  default = {}

}

variable "route_table_routes_public" {
  type    = map(any)
  default = {}

}

variable "public_subnets" {
  description = "A list of public subnets inside the VPC"
  type        = list(string)
  default     = []
}

variable "private_subnets" {
  description = "A list of private subnets inside the VPC"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "A mapping of tags to assign to the resource"
  type        = map(any)
  default     = {}
}

#variables igw

variable "igwname" {
  description = "Name to be used the resources as identifier"
  type        = string
  default     = ""
}

#variables nat
variable "natname" {
  description = "Name to be used the resources as identifier"
  type        = string
  default     = ""

}

## routes
variable "rtname" {
  description = "Name to be used the resources as identifier"
  type        = string
  default     = ""

}

variable "map_public_ip_on_launch" {
  description = "Should be false if you do not want to auto-assign public IP on launch"
  type        = bool
  default     = true
}

variable "public_subnets_tags" {
  description = "A mapping of tags to assign to the resource"
  type        = map(any)
  default     = {}
}

variable "private_subnets_tags" {
  description = "A mapping of tags to assign to the resource"
  type        = map(any)
  default     = {}
}