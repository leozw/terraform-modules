## variable logs
variable "lognames" {
  description = "Name to be used the resources as identifier"
  type        = string
  default     = "my-log-group"
}

variable "skip_destroy" {
  description = "Set to true if you do not wish the log group (and any logs it may contain) to be deleted at destroy time, and instead just remove the log group from the Terraform state."
  type        = bool
  default     = false
}

variable "retention_in_days" {
  description = "Specifies the number of days you want to retain log events in the specified log group. Possible values are: 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1096, 1827, 2192, 2557, 2922, 3288, 3653, and 0. If you select 0, the events in the log group are always retained and never expire"
  type        = number
  default     = 0
}

variable "tags" {
  description = "A mapping of tags to assign to the resource"
  type        = map(string)
  default = {
    Environment = "Development"
  }
}

variable "environment" {
  description = "Env ambient"
  type        = string
  default     = null

}