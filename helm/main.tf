locals {
  name_alb            = "aws-load-balancer-controller"
  name_asg            = "cluster-autoscaler"
  name_external-dns   = "external-dns"
  name_metrics-server = "metrics-server"
  name_ebs            = "aws-ebs-csi-driver"
  name_velero         = "velero"
  name_ingress_nginx  = "ingress-nginx"
  name_cert_manager   = "cert-manager"
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.this.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.this.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.this.token
}

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.this.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.this.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.this.token

  }
}

data "aws_eks_cluster" "this" {
  name = var.cluster_name
}

data "aws_eks_cluster_auth" "this" {
  name = var.cluster_name
}

data "aws_region" "current" {}

data "aws_caller_identity" "current" {}


## Ingress-nginx

module "ingress-helm" {
  source = "./modules/helm"

  count = var.ingress-nginx ? 1 : 0

  helm_release = {

    name             = try(var.custom_values_nginx["name"], local.name_ingress_nginx)
    namespace        = try(var.custom_values_nginx["namespace"], "ingress-nginx")
    repository       = "https://kubernetes.github.io/ingress-nginx"
    chart            = "ingress-nginx"
    create_namespace = true

    values = try(var.custom_values_nginx["values"], [])

  }

  set = try(var.custom_values_nginx["set"], {})

}

## Certmanager
module "cert-helm" {
  source = "./modules/helm"

  count = var.cert-manager ? 1 : 0

  helm_release = {

    name             = try(var.custom_values_nginx["name"], local.name_cert_manager)
    namespace        = try(var.custom_values_nginx["namespace"], "cert-manager")
    repository       = "https://charts.jetstack.io"
    chart            = "cert-manager"
    create_namespace = true

    values = try(var.custom_values_cert_manager["values"], [file("${path.module}/templates/values-cert.yaml")])

  }

  set = try(var.custom_values_cert_manager["set"], {})

}

## Velero

resource "aws_s3_bucket" "this" {
  count = var.velero ? 1 : 0

  bucket_prefix = "velero-"
  force_destroy = var.force_destroy

  tags = merge(
    {
      "Name"     = format("%s-%s", "velero", var.environment)
      "Platform" = "Storage"
      "Type"     = "S3"
    },
    var.tags,
  )
}

module "iam-velero" {
  source = "./modules/iam"

  count = var.velero ? 1 : 0

  iam_roles = {
    "velero-${var.environment}" = {
      "openid_connect" = "${data.aws_iam_openid_connect_provider.this.arn}"
      "openid_url"     = "${data.aws_iam_openid_connect_provider.this.url}"
      "serviceaccount" = "velero"
      "string"         = "StringEquals"
      "namespace"      = "velero"
      "policy" = templatefile("${path.module}/templates/policy-velero.json", {
        bucket_name = "${aws_s3_bucket.this[0].bucket}"
      })
    }
  }
}

module "velero" {
  source = "./modules/helm"

  count = var.velero ? 1 : 0

  helm_release = {

    name             = try(var.custom_values_velero["name"], local.name_velero)
    namespace        = try(var.custom_values_velero["namespace"], "velero")
    repository       = "https://vmware-tanzu.github.io/helm-charts"
    chart            = "velero"
    create_namespace = true

    values = try(var.custom_values_velero["values"], [templatefile("${path.module}/templates/values-velero.yaml", {
      aws_region     = "${data.aws_region.current.name}"
      bucket_name    = "${aws_s3_bucket.this[0].bucket}"
      aws_arn_velero = module.iam-velero[0].arn[0]
    })])

  }

  set = try(var.custom_values_velero["set"], {})

}

## EBS

module "iam-ebs" {
  source = "./modules/iam"

  count = var.aws-ebs-csi-driver ? 1 : 0

  iam_roles = {
    "aws-ebs-csi-driver-${var.environment}" = {
      "openid_connect" = "${data.aws_iam_openid_connect_provider.this.arn}"
      "openid_url"     = "${data.aws_iam_openid_connect_provider.this.url}"
      "serviceaccount" = "aws-ebs-csi-driver-sa"
      "string"         = "StringEquals"
      "namespace"      = "kube-system"
      "policy"         = file("${path.module}/templates/policy-ebs.json")
    }
  }
}

module "ebs-helm" {
  source = "./modules/helm"

  count = var.aws-ebs-csi-driver ? 1 : 0

  helm_release = {

    name       = try(var.custom_values_ebs["name"], local.name_ebs)
    namespace  = try(var.custom_values_ebs["namespace"], "kube-system")
    repository = "https://kubernetes-sigs.github.io/aws-ebs-csi-driver"
    chart      = "aws-ebs-csi-driver"

    values = try(var.custom_values_ebs["values"], [templatefile("${path.module}/templates/values-ebs.yaml", {
      aws_region   = "${data.aws_region.current.name}"
      cluster_name = "${data.aws_eks_cluster.this.name}"
      aws_arn_ebs  = module.iam-ebs[0].arn[0]
    })])

  }

  set = try(var.custom_values_ebs["set"], {})

}

## ALB
module "iam-alb" {
  source = "./modules/iam"

  count = var.aws-load-balancer-controller ? 1 : 0

  iam_roles = {
    "aws-load-balancer-controller-${var.environment}" = {
      "openid_connect" = "${data.aws_iam_openid_connect_provider.this.arn}"
      "openid_url"     = "${data.aws_iam_openid_connect_provider.this.url}"
      "serviceaccount" = "aws-load-balancer-controller"
      "string"         = "StringEquals"
      "namespace"      = "kube-system"
      "policy"         = file("${path.module}/templates/policy-alb.json")
    }
  }
}

module "alb" {
  source = "./modules/helm"

  count = var.aws-load-balancer-controller ? 1 : 0

  helm_release = {

    name       = try(var.custom_values_alb["name"], local.name_alb)
    namespace  = try(var.custom_values_alb["namespace"], "kube-system")
    repository = "https://aws.github.io/eks-charts"
    chart      = "aws-load-balancer-controller"

    values = try(var.custom_values_alb["values"], [templatefile("${path.module}/templates/values-alb.yaml", {
      aws_region   = "${data.aws_region.current.name}"
      cluster_name = "${data.aws_eks_cluster.this.name}"
      aws_arn_alb  = module.iam-alb[0].arn[0]
    })])

  }

  set = try(var.custom_values_alb["set"], {})

}


## ASG

module "iam-asg" {
  source = "./modules/iam"

  count = var.aws-autoscaler-controller ? 1 : 0

  iam_roles = {
    "cluster-autoscaler-${var.environment}" = {
      "openid_connect" = "${data.aws_iam_openid_connect_provider.this.arn}"
      "openid_url"     = "${data.aws_iam_openid_connect_provider.this.url}"
      "serviceaccount" = "cluster-autoscaler-aws-cluster-autoscaler"
      "string"         = "StringEquals"
      "namespace"      = "kube-system"
      "policy" = templatefile("${path.module}/templates/policy-asg.json", {
        cluster_name = "${data.aws_eks_cluster.this.name}"
      })
    }
  }
}

module "asg" {
  source = "./modules/helm"

  count = var.aws-autoscaler-controller ? 1 : 0

  helm_release = {

    name       = try(var.custom_values_asg["name"], local.name_asg)
    namespace  = try(var.custom_values_asg["namespace"], "kube-system")
    repository = "https://kubernetes.github.io/autoscaler"
    chart      = "cluster-autoscaler"

    values = try(var.custom_values_asg["values"], [templatefile("${path.module}/templates/values-asg.yaml", {
      aws_region   = "${data.aws_region.current.name}"
      cluster_name = "${data.aws_eks_cluster.this.name}"
      aws_arn_asg  = module.iam-asg[0].arn[0]
      version_k8s  = "${data.aws_eks_cluster.this.version}"
    })])

  }

  set = try(var.custom_values_asg["set"], {})

}


## ExternalDNS

module "external-dns" {
  source = "./modules/helm"

  count = var.external-dns ? 1 : 0

  helm_release = {

    name       = try(var.custom_values_external-dns["name"], local.name_external-dns)
    namespace  = try(var.custom_values_external-dns["namespace"], "kube-system")
    repository = "https://kubernetes-sigs.github.io/external-dns/"
    chart      = "external-dns"

    values = try(var.custom_values_external-dns["values"], [templatefile("${path.module}/templates/values-external.yaml", {
      domain = "${var.domain}"
      }
    )])

  }

  set = try(var.custom_values_external-dns["set"], {})

}

## Metrics Server

module "metrics-server" {
  source = "./modules/helm"

  count = var.metrics-server ? 1 : 0

  helm_release = {

    name       = try(var.custom_values_metrics-server["name"], local.name_metrics-server)
    namespace  = try(var.custom_values_metrics-server["namespace"], "kube-system")
    repository = "https://kubernetes-sigs.github.io/metrics-server/"
    chart      = "metrics-server"

    values = try(var.custom_values_metrics-server["values"], [])

  }

  set = try(var.custom_values_metrics-server["set"], {})

}

## CUSTOM

module "custom" {
  source = "./modules/helm"

  for_each = var.custom_helm

  helm_release = {

    name       = try(each.value.name, "")
    namespace  = try(each.value.namespace, "")
    repository = try(each.value.repository, "")
    version    = try(each.value.version, "")
    chart      = try(each.value.chart, "")

    values = try(each.value.values, [])

  }

  set = try(each.value.set, {})

}
