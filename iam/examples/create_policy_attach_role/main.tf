module "iam" {
  source = "../../"

  create_policy   = true
  policy_name_iam = "my-policy"
  name_iam_attach = "my-policy-custom"
  policy_iam      = local.policy
  roles_policy    = [aws_iam_role.this[0].name]

  tags = var.tags
}
