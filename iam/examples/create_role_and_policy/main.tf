module "iam" {
  source = "../../"

  create_role        = true
  rolename           = "my-role"
  policyname         = "my-policy"
  assume_role_policy = local.assume_role_policy
  policy             = local.policy

  tags = var.tags
}
