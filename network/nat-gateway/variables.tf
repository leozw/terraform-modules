variable "settings" {
  description = "list of values to assign to nat gateways"
  type = list(object({
    vpc_id               = string
    vpc_name             = string
    subnet_id            = string
    create_eip           = optional(bool, true)
    connectivity_type    = optional(string)
    tags                 = optional(map(string))
  }))
}


