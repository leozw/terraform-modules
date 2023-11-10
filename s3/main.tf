data "aws_canonical_user_id" "current" {}

locals {
  grants = concat([{
    type       = "CanonicalUser"
    permission = "FULL_CONTROL"
    id         = data.aws_canonical_user_id.current.id
    }],
  var.grant)
}

resource "aws_s3_bucket" "this" {
  bucket        = format("%s", var.name_bucket)
  force_destroy = var.force_destroy

  tags = merge(
    {
      "Name"     = format("%s-%s", var.name_bucket, var.environment)
      "Platform" = "Storage"
      "Type"     = "S3"
    },
    var.tags,
  )
}

resource "aws_s3_bucket_policy" "allow_access_from_another_account" {
  count = var.create_policy ? 1 : 0

  bucket = aws_s3_bucket.this.id
  policy = var.policy_bucket
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket = aws_s3_bucket.this.id

  block_public_acls       = var.block_public_acls
  block_public_policy     = var.block_public_policy
  ignore_public_acls      = var.ignore_public_acls
  restrict_public_buckets = var.restrict_public_buckets
}


resource "aws_s3_object" "object" {
  count = var.create_object ? 1 : 0

  bucket  = aws_s3_bucket.this.id
  key     = var.key_object
  content = var.source_object

}

resource "aws_s3_bucket_lifecycle_configuration" "this" {
  count = var.create_lifecycle ? 1 : 0

  bucket = aws_s3_bucket.this.id

  rule {
    id = var.rule_id

    dynamic "abort_incomplete_multipart_upload" {
      for_each = var.abort_incomplete_multipart_upload

      content {
        days_after_initiation = lookup(abort_incomplete_multipart_upload.value, "days_after_initiation", null)
      }
    }

    dynamic "expiration" {
      for_each = var.expiration
      content {
        days = lookup(expiration.value, "days", null)
        date = lookup(expiration.value, "date", null)
      }

    }
    dynamic "filter" {
      for_each = var.filter
      content {
        prefix                   = lookup(filter.value, "prefix", null)
        object_size_greater_than = lookup(filter.value, "object_size_greater_than", null)
        object_size_less_than    = lookup(filter.value, "object_size_less_than", null)
      }

    }

    dynamic "noncurrent_version_expiration" {
      for_each = var.noncurrent_version_expiration

      content {
        noncurrent_days = lookup(noncurrent_version_expiration.value, "noncurrent_days", null)
      }
    }

    status = var.status_lifecycle
  }
}

resource "aws_s3_bucket_website_configuration" "this" {
  count = var.create_website_configuration ? 1 : 0

  bucket = aws_s3_bucket.this.id

  index_document {
    suffix = var.suffix
  }

  error_document {
    key = var.key_error
  }

}

resource "aws_s3_bucket_ownership_controls" "this" {
  count = var.create_bucket_ownership_controls ? 1 : 0

  bucket = aws_s3_bucket.this.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "this" {
  count = var.create_bucket_ownership_controls ? 1 : 0

  depends_on = [
    aws_s3_bucket_ownership_controls.this[0],
    aws_s3_bucket_public_access_block.this,
  ]

  bucket = aws_s3_bucket.this.id

  dynamic "access_control_policy" {
    for_each = length(local.grants) > 0 ? [true] : []

    content {
      dynamic "grant" {
        for_each = local.grants
        content {
          grantee {
            type = grant.value.type
            id   = try(grant.value.id, null)
            uri  = try(grant.value.uri, null)
          }
          permission = grant.value.permission

        }
      }
      owner {
        id = data.aws_canonical_user_id.current.id
      }
    }
  }
}

resource "aws_s3_bucket_versioning" "this" {
  count = var.create_bucket_versioning ? 1 : 0

  bucket = aws_s3_bucket.this.id
  versioning_configuration {
    status = var.status_version
  }
}
