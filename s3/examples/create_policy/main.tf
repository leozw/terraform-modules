data "aws_elb_service_account" "main" {}
data "aws_caller_identity" "current" {}

module "s3-access-logs" {
  source = "../.."

  name_bucket   = "access-log-alb-tf"
  create_policy = true
  policy_bucket = local.policy_bucket

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  force_destroy = true


  tags        = var.tags
  environment = var.environment

}
