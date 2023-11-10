resource "aws_cloudwatch_log_group" "this" {
  name = var.lognames

  skip_destroy      = var.skip_destroy
  retention_in_days = var.retention_in_days


  tags = merge(
    {
      "Name"     = format("%s-%s", var.lognames, var.environment)
      "Platform" = "logs"
      "Type"     = "log_group"
    },
    var.tags,
  )

  lifecycle {
    create_before_destroy = true
  }
}
