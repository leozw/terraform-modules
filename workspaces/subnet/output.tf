output "private_ids" {
  description = "Output subnet private"
  value       = try(aws_subnet.private.*.id, "")
}

output "private_cidrs" {
  description = "Output subnet private"
  value       = try(aws_subnet.private.*.cidr_block, "")
}

output "public_ids" {
  description = "Output subnet public"
  value       = try(aws_subnet.public.*.id, "")
}

output "public_cidrs" {
  description = "Output subnet public"
  value       = try(aws_subnet.public.*.cidr_block, "")
}

output "igw" {
  description = "Output vpc cidr"
  value       = try(aws_internet_gateway.this[0].id, "")
}

output "nat" {
  description = "Output vpc cidr"
  value       = try(aws_nat_gateway.this[0].id, "")
}
