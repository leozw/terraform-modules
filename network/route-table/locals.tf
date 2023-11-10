locals {
  type_definition = {
    for i ,rtb in var.settings: i => {
        result = rtb.internet_gateway_id != null ? "public" : "private"
    }
  }
}
