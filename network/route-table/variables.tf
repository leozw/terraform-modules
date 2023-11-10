variable "settings" {
  description = "list of values to assign to routers"
  type = list(object({
    cidr_block           = optional(string, "0.0.0.0/0")
    internet_gateway_id  = optional(string)
    vpc_id               = string
    vpc_name             = string
    nat_gateway_id       = optional(string)
    tags                 = optional(map(string))
  }))
}