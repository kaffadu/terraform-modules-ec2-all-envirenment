output "vpc_id" {
  value = module.myinfra.vpc_id
}

output "vpc_cidr" {
  value = module.myinfra.vpc_cidr
}

output "web_public_subnets_id" {
  value = module.myinfra.web_public_subnets_id
}

output "app_private_subnets_id" {
  value = module.myinfra.app_private_subnets_id
}

output "security-group_id" {
  value = module.myinfra.security-group_id
}