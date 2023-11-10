provider "aws" {
  profile = ""
  region  = ""
}

module "helm" {
  source = "../"

  environment  = "hmg"

  cluster_name = "k8s"
  ## Metric Server
  metrics-server = false

  ## Controller EBS Helm
  aws-ebs-csi-driver = false

  ## Configuration custom values
  #custom_values_ebs = {
  #  values = [templatefile("${path.module}/values-ebs.yaml", {
  #    aws_region   = "us-east-1"
  #    cluster_name = "${local.cluster_name}"
  #    name         = "aws-ebs-csi-driver-${var.environment}"
  #  })]
  #}
  
  ## Ingress-nginx controller
  ingress-nginx = false

  ## Cert-manager
  cert-manager = true

  ## Velero
  velero = false

  ## External DNS 
  external-dns = false

  ## Controller ASG
  aws-autoscaler-controller = false

  ## Controller ALB
  aws-load-balancer-controller = false
  custom_values_alb = {
    set = [
      {
        name  = "nodeSelector.Environment"
        value = "prd"
      },
      {
        name  = "vpcId" ## Variable obrigatory for controller alb
        value = "vpc-abcabcaba"
      }
    ]
  }

  ## CUSTOM_HELM

  # custom_helm = {
  #   aws-secrets-manager = {
  #     "name"             = "aws-secrets-manager"
  #     "namespace"        = "kube-system"
  #     "repository"       = "https://aws.github.io/secrets-store-csi-driver-provider-aws"
  #     "chart"            = "secrets-store-csi-driver-provider-aws"
  #     "version"          = "" ## When empty, the latest version will be installed
  #     "create_namespace" = false

  #     "values" = [] ## When empty, default values will be used
  #   }
  # }
}
