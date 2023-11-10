resource "aws_iam_role" "this" {
  count = var.create_role ? 1 : 0

  name = var.rolename

  tags = merge(
    {
      "Name"     = format("%s", var.rolename)
      "Platform" = "IAM"
      "Type"     = "role"
    },
    var.tags,
  )

  assume_role_policy = var.assume_role_policy

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_iam_role_policy" "this" {
  count = var.create_role ? 1 : 0

  name = var.policyname
  role = aws_iam_role.this[0].id

  policy = var.policy

}

resource "aws_iam_policy" "policy" {
  count = var.create_policy ? 1 : 0

  name        = var.policy_name_iam
  description = "Policy custom"
  policy      = var.policy_iam
}

resource "aws_iam_policy_attachment" "this" {
  count = var.create_policy ? 1 : 0

  name       = var.name_iam_attach
  users      = try(var.users_policy, [])
  roles      = try(var.roles_policy, [])
  groups     = try(var.groups, [])
  policy_arn = aws_iam_policy.policy[0].arn
}
