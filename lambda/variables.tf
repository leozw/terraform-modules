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
    additional_policies = optional(list(string), [])
    role                = optional(string)
    variables           = optional(map(string), {})
    vpc_config          = optional(map(any))
    filename            = optional(string)
    image_uri           = optional(string)
    s3_object_version   = optional(string)
    layers              = optional(list(string), [])
  }))
}
