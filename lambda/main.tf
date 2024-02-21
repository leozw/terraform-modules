module "lambda" {
  source = "./module"

  for_each = var.lambdas

  function_name       = each.value.function_name
  runtime             = each.value.runtime
  handler             = each.value.handler
  architectures       = each.value.architectures
  tracing_config      = each.value.tracing_config
  memory_size         = each.value.memory_size
  timeout             = each.value.timeout
  s3_bucket           = each.value.s3_bucket
  s3_key              = each.value.s3_key
  additional_policies = try(each.value.additional_policies, [])
  variables           = each.value.variables
  vpc_config          = each.value.vpc_config

}