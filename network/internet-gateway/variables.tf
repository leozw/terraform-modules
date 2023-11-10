variable "settings" {
  type = object({
    vpc_id                 = string
    vpc_name               = string
    igw_count              = optional(number, 1)
    tags                   = optional(map(string))
  })
}
