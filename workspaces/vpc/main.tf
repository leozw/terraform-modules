resource "aws_vpc" "this" {
  count = var.create_vpc ? 1 : 0

  cidr_block           = var.cidr_block
  instance_tenancy     = var.instance_tenancy
  enable_dns_support   = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames

  tags = merge(
    {
      "Name"     = format("%s-%s", var.name, var.environment)
      "Platform" = "network"
      "Type"     = "vpc"
    },
    var.tags,
  )
}

## FLOW_LOGS

resource "aws_flow_log" "this" {
  count = var.create_aws_flow_log ? 1 : 0

  iam_role_arn    = try(var.iam_role_arn, null)
  log_destination = try(var.log_destination_arn, null)
  traffic_type    = "ALL"
  vpc_id          = aws_vpc.this[0].id

}
