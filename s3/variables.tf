##variables security-group
variable "name_bucket" {
  description = "Name to be used the resources as identifier"
  type        = string
}

variable "force_destroy" {
  description = "Boolean that indicates all objects (including any locked objects) should be deleted from the bucket when the bucket is destroyed so that the bucket can be destroyed without error"
  type        = bool
  default     = false

}
variable "environment" {
  description = "Env tags"
  type        = string
  default     = null
}

variable "tags" {
  description = "A mapping of tags to assign to the resource"
  type        = map(string)
  default     = {}
}

variable "create_policy" {
  description = "Enable used policy bucket"
  type        = bool
  default     = false
}

variable "block_public_acls" {
  description = "Whether Amazon S3 should block public ACLs for this bucket. Defaults to false"
  type        = bool
  default     = false
}

variable "block_public_policy" {
  description = "Whether Amazon S3 should block public bucket policies for this bucket. Defaults to false"
  type        = bool
  default     = false
}

variable "ignore_public_acls" {
  description = "Whether Amazon S3 should ignore public ACLs for this bucket. Defaults to false"
  type        = bool
  default     = false
}

variable "restrict_public_buckets" {
  description = "Whether Amazon S3 should restrict public bucket policies for this bucket. Defaults to false"
  type        = bool
  default     = false
}

variable "policy_bucket" {
  description = "Text of the policy. Although this is a bucket policy rather than an IAM policy, the aws_iam_policy_document data source may be used, so long as it specifies a principal"
  type        = string
  default     = ""
}

variable "key_object" {
  description = "Name of the object once it is in the bucket."
  default     = null
}

variable "source_object" {
  description = "Conflicts with source and content_base64) Literal string value to use as the object content, which will be uploaded as UTF-8-encoded text."
  default     = null
}

variable "create_object" {
  description = "Create object in bucket"
  default     = false
}

variable "create_lifecycle" {
  description = "Create lifecycle"
  type        = bool
  default     = false
}

variable "create_website_configuration" {
  description = "Create website_configuration"
  type        = bool
  default     = false
}

variable "create_bucket_ownership_controls" {
  description = "Create bucket_ownership_controls"
  type        = bool
  default     = false
}

variable "suffix" {
  description = "Suffix that is appended to a request that is for a directory on the website endpoint."
  type        = string
  default     = ""
}

variable "key_error" {
  description = "Object key name to use when a 4XX class error occurs"
  type        = string
  default     = "error.html"
}

variable "grant" {
  description = "An ACL policy grant. Conflicts with `acl`"
  type        = any
  default     = []
}

variable "create_bucket_versioning" {
  description = "Create Versioning"
  type        = bool
  default     = false
}

variable "status_version" {
  description = "Versioning state of the bucket. Valid values: Enabled, Suspended, or Disabled."
  type        = string
  default     = "Enabled"
}


variable "rule_id" {
  description = "Unique identifier for the rule. The value cannot be longer than 255 characters"
  type        = string
  default     = ""
}

variable "expiration" {
  description = "Configuration block that specifies the expiration for the lifecycle of the object in the form of date, days and, whether the object has a delete marker"
  type        = map(any)
  default     = {}
}

variable "filter" {
  description = "Configuration block used to identify objects that a Lifecycle Rule applies to."
  type        = map(any)
  default     = {}
}

variable "status_lifecycle" {
  description = "Whether the rule is currently being applied. Valid values: Enabled or Disabled"
  type        = string
  default     = "Disabled"
}

variable "abort_incomplete_multipart_upload" {
  description = "Number of days after which Amazon S3 aborts an incomplete multipart upload"
  type        = map(any)
  default     = {}
}

variable "noncurrent_version_expiration" {
  description = "Number of days an object is noncurrent before Amazon S3 can perform the associated action. Must be a positive integer."
  type        = map(any)
  default     = {}
}
