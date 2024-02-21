data "aws_iam_policy_document" "this" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "this" {
  name               = "iam_for_lambda_${var.function_name}"
  assume_role_policy = data.aws_iam_policy_document.this.json
}

resource "aws_iam_role_policy_attachment" "AWSXRayDaemonWriteAccess" {
  count      = var.tracing_config == "Active" || var.tracing_config == "PassThrough" ? 1 : 0
  policy_arn = "arn:aws:iam::aws:policy/AWSXRayDaemonWriteAccess"
  role       = aws_iam_role.this.id
}

resource "aws_iam_role_policy" "additional" {
  for_each = { for idx, policy_json in var.additional_policies : idx => policy_json }

  name   = "${var.function_name}_additional_policy_${each.key}"
  role   = aws_iam_role.this.id
  policy = each.value
}

resource "aws_lambda_function" "this" {
  function_name = var.function_name
  role          = aws_iam_role.this.arn
  handler       = var.handler
  runtime       = var.runtime
  architectures = var.architectures

  dynamic "tracing_config" {
    for_each = var.tracing_config != "" ? [var.tracing_config] : []
    content {
      mode = tracing_config.value
    }
  }

  layers = var.layers

  environment {
    variables = var.variables
  }

  filename  = var.filename != "" ? var.filename : null
  image_uri = var.image_uri != "" ? var.image_uri : null
  s3_bucket = var.s3_bucket != "" ? var.s3_bucket : null
  s3_key    = var.s3_key != "" ? var.s3_key : null

  memory_size = var.memory_size
  timeout     = var.timeout

  dynamic "vpc_config" {
    for_each = var.vpc_config != null ? [var.vpc_config] : []
    content {
      security_group_ids = vpc_config.value.security_groups
      subnet_ids         = vpc_config.value.subnets
    }
  }

}

resource "aws_iam_role_policy_attachment" "AWSLambdaENIManagementAccess" {
  count      = var.vpc_config != null ? 1 : 0
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaENIManagementAccess"
  role       = aws_iam_role.this.id
}
