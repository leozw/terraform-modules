locals {
  environment = "staging"
  tags = {
    Environment = "staging"
  }

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "vpc-flow-logs.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogGroups",
        "logs:DescribeLogStreams"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF

}

module "vpc" {
  source = "../"

  name                 = var.name
  cidr_block           = var.cidr_block
  instance_tenancy     = var.instance_tenancy
  enable_dns_support   = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames

  tags        = local.tags
  environment = local.environment

  private_subnets         = var.private_subnets
  public_subnets          = var.public_subnets
  map_public_ip_on_launch = var.map_public_ip_on_launch

  iam_role_arn        = module.iam.arn
  log_destination_arn = module.log-group.log_arn

  igwname = var.igwname
  natname = var.natname
  rtname  = var.rtname

  create_aws_flow_log = true

  route_table_routes_private = {
    "nat" = {
      "cidr_block"     = "0.0.0.0/0"
      "nat_gateway_id" = "${module.vpc.nat}"
    }
  }
  route_table_routes_public = {
    "igw" = {
      "cidr_block" = "0.0.0.0/0"
      "gateway_id" = "${module.vpc.igw}"
    }
  }

}

module "iam" {
  source = "git@github.com:elvenworks-ps/professional-services.git//terraform-modules//iam"

  create_role = true

  rolename           = "role-logflow-${local.environment}"
  policyname         = "policy-logflow-${local.environment}"
  assume_role_policy = local.assume_role_policy
  policy             = local.policy

  tags = local.tags
}

module "log-group" {
  source = "git@github.com:elvenworks-ps/professional-services.git//terraform-modules//log_group"

  lognames    = "vpc-logflow-group-${local.environment}"
  environment = local.environment

}
