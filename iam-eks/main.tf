data "aws_iam_policy_document" "this" {
  for_each = var.iam_roles

  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace("${each.value.openid_url}", "https://", "")}:sub"
      values   = ["system:serviceaccount:kube-system:${each.value.serviceaccount}"]
    }

    condition {
      test     = "StringEquals"
      variable = "${replace("${each.value.openid_url}", "https://", "")}:aud"
      values   = ["sts.amazonaws.com"]
    }

    principals {
      identifiers = [each.value.openid_connect]
      type        = "Federated"
    }
  }
}

resource "aws_iam_role" "this" {
  for_each = var.iam_roles

  assume_role_policy = data.aws_iam_policy_document.this[each.key].json
  name               = each.key
}

resource "aws_iam_role_policy" "this" {
  for_each = var.iam_roles

  name = each.key
  role = aws_iam_role.this[each.key].id

  policy = each.value.policy

}

resource "kubernetes_service_account" "service-account" {
  for_each = var.iam_roles

  metadata {
    name      = each.key
    namespace = "kube-system"
    labels = {
      "app.kubernetes.io/name"      = each.key
      "app.kubernetes.io/component" = "controller"
    }
    annotations = {
      "eks.amazonaws.com/role-arn"               = "${aws_iam_role.this[each.key].arn}"
      "eks.amazonaws.com/sts-regional-endpoints" = "true"
    }
  }

}