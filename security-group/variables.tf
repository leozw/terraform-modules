variable "settings" {
  description = "list of values to assign to Security Group"
  type = object({
    sg_name              = string
    vpc_id               = string
    vpc_name             = string
    tags                 = optional(map(string))
    ingress              = list(object({
      protocol           = optional(string, "tcp")
      from_port          = string
      to_port            = string
      list_of_cidrs      = optional(list(string), ["0.0.0.0/0"])
      security_groups    = optional(list(string))
    }))
  })
}