variable "settings" {
  type = object({
    name    = string
    cidr    = string
    enable_dns_support   = optional(bool, true)
    enable_dns_hostnames = optional(bool, true)
    tags                 = optional(map(string))
  })
}
