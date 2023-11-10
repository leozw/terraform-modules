module "s3" {
  source = "../s3"

  name_bucket = "env-api-${local.environment}"

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  force_destroy = true

  create_object = true
  key_object    = "api.env"
  source_object = file("api.env")

  tags        = local.tags
  environment = local.environment

}