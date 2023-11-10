output "vpc_id" {
  description = "Output vpc id"
  value       = var.data == false ? module.vpc.*.vpc_id : try(module.vpc.*.vpc_id, "")
}

output "vpc_name" {
  description = "Output vpc id"
  value       = var.data == false ? module.vpc.*.vpc_name : try(module.vpc.*.vpc_name, "")
}

output "cidr_block" {
  description = "Output vpc id"
  value       = var.data == false ? module.vpc.*.vpc_cidr : try(module.vpc.*.vpc_cidr, "")
}

output "nat" {
  description = "Output subnet public"
  value       = var.data == false ? module.subnet-prd.nat : try(module.subnet-prd[0].nat, "")
}

output "igw" {
  description = "Output subnet public"
  value       = var.data == false ? module.subnet-prd.igw : try(module.subnet-prd[0].igw, "")
}