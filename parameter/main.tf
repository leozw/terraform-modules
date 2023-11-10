resource "aws_ssm_parameter" "secret" {
  for_each = var.ssm_parameter

  name        = each.value.name
  description = "The parameter description"
  type        = each.value.type
  value       = each.value.value

  tags = merge(
    {
      "Name"     = format("%s-%s", each.key, var.environment)
      "Platform" = "SSM"
      "Type"     = "Parameters"
    },
    var.tags,
  )

  lifecycle {
    ignore_changes = [
      value,
    ]
  }

}