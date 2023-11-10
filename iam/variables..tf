variable "rolename" {
  description = "Name to be used the resources as identifier"
  type        = string
  default     = null
}

variable "policyname" {
  description = "Name to be used the resources as identifier"
  type        = string
  default     = null
}

variable "policy" {
  description = "The inline policy document. This is a JSON formatted string."
  type        = string
  default     = null
}

variable "assume_role_policy" {
  description = "Policy that grants an entity permission to assume the role."
  type        = string
  default     = null
}

variable "tags" {
  description = "A mapping of tags to assign to the resource"
  type        = map(string)
  default     = {}
}

variable "create_role" {
  description = "Create role"
  type        = bool
  default     = false
}

variable "create_policy" {
  description = "Create policy"
  type        = bool
  default     = false
}

variable "policy_name_iam" {
  description = "The name of the policy. If omitted, Terraform will assign a random, unique name."
  default     = null
}

variable "policy_iam" {
  description = "This is a JSON formatted string."
  default     = null
}

variable "name_iam_attach" {
  description = "The name of the attachment. This cannot be an empty string."
  default     = null
}

variable "users_policy" {
  description = "The user(s) the policy should be applied to"
  default     = []
}

variable "roles_policy" {
  description = "The role(s) the policy should be applied to"
  default     = []
}

variable "groups" {
  description = "The group(s) the policy should be applied to"
  default     = []
}

variable "environment" {
  description = "Env tags"
  type        = string
  default     = null
}