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
  default = {

    function_name       = "lambda-buteco"
    runtime             = "nodejs20.x"
    handler             = "index.handler"
    architectures       = ["x86_64"]
    tracing_config      = "Active"
    memory_size         = 256
    timeout             = 10
    additional_policies = []
    s3_bucket           = "lambda-zw-prd"
    s3_key              = "node-app-x-ray.zip"
    variables           = { EXAMPLE_VAR = "example" }
    vpc_config          = { security_groups = ["sg-06651f16640f5263c"], subnets = ["subnet-08ea38bbf8eae5bfb"] }
  }
}
