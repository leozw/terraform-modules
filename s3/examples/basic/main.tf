module "s3" {
  source = "../s3"

  name_bucket = "web-cache-tf-teste"

  tags        = var.tags
  environment = var.environment

}