variable "counts" {
  description = "number of subnets need to be created"
  type = object({
    public   = optional(number, 0)
    private  = optional(number, 0)
  })
}

variable "settings" {
  description = "list of values to assign to subnets"
  type = object({
    vpc_cidr             = string
    vpc_id               = string
    vpc_name             = string
    newbits              = optional(number, 8)
    tags                 = optional(map(string))
  })
}
