variable "ssm_parameter" {
  description = "additional parameters modifyed in parameter group"
  type        = map(any)
  default     = {}
}

variable "tags" {
  description = "A mapping of tags to assign to the resource"
  type        = map(string)
  default     = {}
}

variable "environment" {
  description = "Env tags"
  type        = string
}