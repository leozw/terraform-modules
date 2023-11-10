variable "settings" {
  description = "list of values to assign to router table association"
  type = list(object({
    route_table_id       = string
    subnets_ids          = list(string)
  }))
}


