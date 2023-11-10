locals {
  configs = flatten([
    for rtba in var.settings : [
      for index in range(length(rtba.subnets_ids)) : {
        subnet_id      = rtba.subnets_ids[index]
        route_table_id = rtba.route_table_id
      }
    ]
  ])
}
