data "aws_elb_service_account" "main" {}
data "aws_caller_identity" "current" {}

module "s3-access-logs" {
  source = "../.."

  name_bucket   = "access-log-alb-tf"
  create_policy = true
  policy_bucket = local.policy_bucket

  block_public_acls       = false
  ignore_public_acls      = false
  block_public_policy     = true
  restrict_public_buckets = true

  force_destroy = true

  ## static web
  create_website_configuration = true
  suffix                       = "index.html"

  ## lifecycle
  create_lifecycle = true

  rule_id = "jobs/cachePath"
  filter = {
    "prefix" = {
      "prefix" = ""
    }
  }
  expiration = {
    "days" = {
      "days" = 1
    }
  }

  abort_incomplete_multipart_upload = {
    "days_after_initiation" = {
      "days_after_initiation" = 1
    }
  }

  noncurrent_version_expiration = {
    "noncurrent_days" = {
      "noncurrent_days" = 1
    }
  }

  status_lifecycle = "Enabled"

  ##bucket_versioning

  create_bucket_versioning = true

  ## Access control list
  create_bucket_ownership_controls = true
  grant = [{
    type       = "Group"
    permission = "READ"
    uri        = "http://acs.amazonaws.com/groups/global/AllUsers"
    },
    {
      type       = "Group"
      permission = "READ_ACP"
      uri        = "http://acs.amazonaws.com/groups/global/AllUsers"
    },
  ]

  tags        = var.tags
  environment = var.environment

}
