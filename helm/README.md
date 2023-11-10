## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.2.9 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.72 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | >= 2.10.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 3.72 |


Some of the addon/controller policies that are currently supported include:

- [EBS-CSI-DRIVER](https://github.com/kubernetes-sigs/aws-ebs-csi-driver)
- [EFS-CSI-DRIVER](https://github.com/kubernetes-sigs/aws-efs-csi-driver)
- [Cluster Autoscaler](https://github.com/kubernetes/autoscaler/tree/master/charts/cluster-autoscaler)
- [External DNS](https://github.com/kubernetes-sigs/external-dns/tree/master/charts/external-dns)
- [Load Balancer Controller](https://github.com/kubernetes-sigs/aws-load-balancer-controller/blob/main/helm/aws-load-balancer-controller/README.md)
- [Metrics-Server](https://github.com/helm/charts/tree/master/stable/metrics-server)
- [Ingress-nginx](https://github.com/kubernetes/ingress-nginx/tree/main/charts/ingress-nginx)
- [cert-manager](https://github.com/cert-manager/cert-manager/tree/master/deploy/charts/cert-manager)
- [velero](https://github.com/vmware-tanzu/helm-charts/tree/main/charts/velero)

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_alb"></a> [alb](#module\_alb) | ./modules/helm | n/a |
| <a name="module_asg"></a> [asg](#module\_asg) | ./modules/helm | n/a |
| <a name="module_custom"></a> [custom](#module\_custom) | ./modules/helm | n/a |
| <a name="module_ebs-helm"></a> [ebs-helm](#module\_ebs-helm) | ./modules/helm | n/a |
| <a name="module_external-dns"></a> [external-dns](#module\_external-dns) | ./modules/helm | n/a |
| <a name="module_iam-alb"></a> [iam-alb](#module\_iam-alb) | ./modules/iam | n/a |
| <a name="module_iam-asg"></a> [iam-asg](#module\_iam-asg) | ./modules/iam | n/a |
| <a name="module_iam-ebs"></a> [iam-ebs](#module\_iam-ebs) | ./modules/iam | n/a |
| <a name="module_metrics-server"></a> [metrics-server](#module\_metrics-server) | ./modules/helm | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_eks_cluster.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster) | data source |
| [aws_eks_cluster_auth.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster_auth) | data source |
| [aws_iam_openid_connect_provider.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_openid_connect_provider) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws-autoscaler-controller"></a> [aws-autoscaler-controller](#input\_aws-autoscaler-controller) | Install release helm controller asg | `bool` | `false` | no |
| <a name="input_aws-ebs-csi-driver"></a> [aws-ebs-csi-driver](#input\_aws-ebs-csi-driver) | Install release helm controller ebs | `bool` | `false` | no |
| <a name="input_aws-load-balancer-controller"></a> [aws-load-balancer-controller](#input\_aws-load-balancer-controller) | Install release helm controller alb | `bool` | `false` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | n/a | `string` | `""` | no |
| <a name="input_custom_helm"></a> [custom\_helm](#input\_custom\_helm) | Custom a Release is an instance of a chart running in a Kubernetes cluster. | `map(any)` | `{}` | no |
| <a name="input_custom_values_alb"></a> [custom\_values\_alb](#input\_custom\_values\_alb) | Custom controler alb a Release is an instance of a chart running in a Kubernetes cluster | `any` | `{}` | no |
| <a name="input_custom_values_asg"></a> [custom\_values\_asg](#input\_custom\_values\_asg) | Custom controller asg a Release is an instance of a chart running in a Kubernetes cluster | `any` | `{}` | no |
| <a name="input_custom_values_ebs"></a> [custom\_values\_ebs](#input\_custom\_values\_ebs) | Custom controller ebs a Release is an instance of a chart running in a Kubernetes cluster | `any` | `{}` | no |
| <a name="input_custom_values_external-dns"></a> [custom\_values\_external-dns](#input\_custom\_values\_external-dns) | Custom external-dns a Release is an instance of a chart running in a Kubernetes cluster | `any` | `{}` | no |
| <a name="input_custom_values_metrics-server"></a> [custom\_values\_metrics-server](#input\_custom\_values\_metrics-server) | Custom metrics-server a Release is an instance of a chart running in a Kubernetes cluster | `any` | `{}` | no |
| <a name="input_domain"></a> [domain](#input\_domain) | Domain used helm External dns | `string` | `""` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Env tags | `string` | `null` | no |
| <a name="input_external-dns"></a> [external-dns](#input\_external-dns) | Install release helm external | `bool` | `false` | no |
| <a name="input_metrics-server"></a> [metrics-server](#input\_metrics-server) | Install release helm metrics-server | `bool` | `false` | no |

## Outputs

No outputs.
