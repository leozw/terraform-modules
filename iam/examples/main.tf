module "iam" {
  source = "../"

  rolename           = "my-role"
  policyname         = "my-policy"
  assume_role_policy = local.assume_role_policy
  policy             = local.policy

  tags = var.tags
}
