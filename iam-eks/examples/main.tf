locals {
  environment = "hmg"
}

module "iam" {
  source = "../"

  iam_roles = {
    "aws-load-balancer-controller-${local.environment}" = {
      "openid_connect" = "arn:aws:iam::261140574810:oidc-provider/oidc.eks.eu-central-1.amazonaws.com/id/D03DEB9092D02FDCCDD404B461DB7DB3"
      "openid_url"     = "https://oidc.eks.eu-central-1.amazonaws.com/id/D03DEB9092D02FDCCDD404B461DB7DB3"
      "serviceaccount" = "aws-load-balancer-controller-${local.environment}"
      "policy"         = file("${path.module}/templates/policy-alb.json")
    }
  }
}