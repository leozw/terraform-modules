data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

resource "aws_opensearch_domain" "this" {
  domain_name    = var.domain
  engine_version = "OpenSearch_${var.cluster_version}"

  cluster_config {
    instance_type            = var.instance_type
    instance_count           = var.instance_count
    dedicated_master_enabled = var.dedicated_master
    zone_awareness_enabled   = var.zone_awareness_enabled

    zone_awareness_config {
      availability_zone_count = var.availability_zone_count
    }
  }

  tags = merge(
    {
      "Name"     = format("%s-%s", var.domain, var.environment)
      "Platform" = "Opensearch"
      "Type"     = "Logs"
    },
    var.tags,
  )


  dynamic "vpc_options" {
    for_each = var.vpc_enabled ? [1] : []
    content {
      subnet_ids         = var.subnet_ids
      security_group_ids = var.security_group_ids
    }
  }

  advanced_security_options {
    enabled                        = var.security_advanced
    anonymous_auth_enabled         = var.anonymous_auth
    internal_user_database_enabled = var.internal_user
    master_user_options {
      master_user_name     = var.user
      master_user_password = var.password
    }
  }

  encrypt_at_rest {
    enabled = var.encrypt_at
  }

  domain_endpoint_options {
    custom_endpoint_enabled = var.endpoint
    custom_endpoint         = var.custom_endpoint
    enforce_https           = var.enforce_https
    tls_security_policy     = var.tls_security_policy
  }

  node_to_node_encryption {
    enabled = var.node_encryption
  }

  ebs_options {
    ebs_enabled = var.ebs
    volume_type = var.type
    volume_size = var.size
  }

  log_publishing_options {
    cloudwatch_log_group_arn = aws_cloudwatch_log_group.this.arn
    log_type                 = "INDEX_SLOW_LOGS"
  }

  log_publishing_options {
    cloudwatch_log_group_arn = aws_cloudwatch_log_group.this.arn
    log_type                 = "SEARCH_SLOW_LOGS"
  }

  log_publishing_options {
    cloudwatch_log_group_arn = aws_cloudwatch_log_group.this.arn
    log_type                 = "ES_APPLICATION_LOGS"
  }

  log_publishing_options {
    cloudwatch_log_group_arn = aws_cloudwatch_log_group.this.arn
    log_type                 = "AUDIT_LOGS"
  }

}

resource "aws_cloudwatch_log_group" "this" {
  name = var.domain
}

resource "aws_cloudwatch_log_resource_policy" "this" {
  policy_name = var.domain

  policy_document = <<CONFIG
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "es.amazonaws.com"
      },
      "Action": [
        "logs:PutLogEvents",
        "logs:PutLogEventsBatch",
        "logs:CreateLogStream"
      ],
      "Resource": "arn:aws:logs:*"
    }
  ]
}
CONFIG
}

resource "aws_opensearch_domain_policy" "public" {
  count = var.public_enabled ? 1 : 0

  domain_name     = aws_opensearch_domain.this.domain_name
  access_policies = var.cidrs
}

resource "aws_opensearch_domain_policy" "vpc" {
  count = var.vpc_enabled ? 1 : 0

  domain_name     = aws_opensearch_domain.this.domain_name
  access_policies = <<CONFIG
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "es:*",
            "Principal": "*",
            "Effect": "Allow",
            "Resource": "arn:aws:es:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:domain/${var.domain}/*"
        }
    ]
}
CONFIG
}