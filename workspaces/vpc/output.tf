output "vpc_id" {
  description = "Output vpc id"
  value       = try(aws_vpc.this[0].id, "")
}

output "vpc_name" {
  description = "Output vpc name"
  value       = try(aws_vpc.this[0].tags.Name, "")
}

output "vpc_cidr" {
  description = "Output vpc cidr"
  value       = try(aws_vpc.this[0].cidr_block, "")
}
