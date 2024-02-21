variable "function_name" {
  description = "Unique name for your Lambda Function."
  type        = string
}

variable "runtime" {
  description = "Runtime environment for the Lambda function. Valid values include various versions of nodejs, java, python, dotnet, go, ruby, and custom runtimes."
  type        = string
  default     = ""
}

variable "role" {
  description = "Amazon Resource Name (ARN) of the function's execution role. The role provides the function's identity and access to AWS services and resources."
  type        = string
  default     = ""
}

variable "architectures" {
  description = "Instruction set architecture for your Lambda function. Valid values are ['x86_64', 'arm64']. Default is ['x86_64']."
  type        = list(string)
  default     = ["x86_64"]
}

variable "memory_size" {
  description = "Amount of memory in MB your Lambda Function can use at runtime. Defaults to 128."
  type        = number
  default     = 128
  validation {
    condition     = var.memory_size > 0 && var.memory_size <= 10240
    error_message = "The memory size must be between 1 MB and 10,240 MB."
  }
}

variable "timeout" {
  description = "Amount of time your Lambda Function has to run in seconds. Defaults to 3. The limit is 900 seconds (15 minutes)."
  type        = number
  default     = 3
  validation {
    condition     = var.timeout > 0 && var.timeout <= 900
    error_message = "The timeout must be between 1 second and 900 seconds."
  }
}

variable "additional_policies" {
  description = "List of additional IAM policy documents in JSON format to attach to the Lambda execution role."
  type        = list(string)
  default     = []
}


variable "policy_xray" {
  type = string
  default = ""
}

variable "tracing_config" {
  description = "Whether to sample and trace a subset of incoming requests with AWS X-Ray. Valid values are PassThrough and Active. If PassThrough, Lambda will only trace the request from an upstream service if it contains a tracing header with 'sampled=1'. If Active, Lambda will respect any tracing header it receives from an upstream service. If no tracing header is received, Lambda will call X-Ray for a tracing decision."
  type        = string
  default     = ""
}

variable "handler" {
  description = "Function entrypoint in your code."
  type        = string
  default     = ""
}

variable "filename" {
  description = "Path to the function's deployment package within the local filesystem."
  type        = string
  default     = ""
}

variable "image_uri" {
  description = "ECR image URI containing the function's deployment package."
  type        = string
  default     = ""
}

variable "s3_bucket" {
  description = "S3 bucket location containing the function's deployment package. This bucket must reside in the same AWS region where you are creating the Lambda function."
  type        = string
  default     = ""
}

variable "s3_key" {
  description = "S3 key of an object containing the function's deployment package."
  type        = string
  default     = ""
}

variable "s3_object_version" {
  description = "Object version containing the function's deployment package."
  type        = string
  default     = ""
}

variable "vpc_config" {
  description = "Specify a list of security groups and subnets in the VPC for network connectivity to AWS resources. When you connect a function to a VPC, it can only access resources and the internet through that VPC."
  type = object({
    security_groups = list(string)
    subnets         = list(string)
  })
  default = null
}

variable "layers" {
  description = "List of Lambda Layer Version ARNs (maximum of 5) to attach to your Lambda Function."
  type        = list(string)
  default     = []
}


variable "variables" {
  description = "Map of environment variables that are accessible from the function code during execution. If provided at least one key must be present."
  type        = map(string)
  default     = {}
}
