output "arn" {
  value = aws_opensearch_domain.this.arn
}

output "domain_id" {
  value = aws_opensearch_domain.this.domain_id
}

output "domain_name" {
  value = aws_opensearch_domain.this.domain_name
}

output "endpoint" {
  value = aws_opensearch_domain.this.endpoint
}

output "kibana_endpoint" {
  value = aws_opensearch_domain.this.kibana_endpoint
}

output "region" {
  value = data.aws_region.current.name
}

output "account" {
  value = data.aws_caller_identity.current.account_id

}