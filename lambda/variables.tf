variable "lambdas" {
  description = "Map of Lambda function configurations"
  type = map(object({
    function_name       = string
    runtime             = string
    handler             = string
    architectures       = list(string)
    tracing_config      = string
    memory_size         = number
    timeout             = number
    s3_bucket           = string
    s3_key              = string
    additional_policies = list(string)
    variables           = map(string)
    vpc_config          = map(any)
  }))
}
