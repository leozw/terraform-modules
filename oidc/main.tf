data "tls_certificate" "this" {
  for_each = var.oidc

  url = each.value.url_certificate_get
}

resource "aws_iam_openid_connect_provider" "this" {
  for_each = var.oidc
 
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = concat([data.tls_certificate.this[each.key].certificates[0].sha1_fingerprint], each.value.additional_thumbprints)
  url             = each.value.url_connect_provider
}