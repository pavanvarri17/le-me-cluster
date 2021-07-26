// vpc output
output "vpc_id" {
  value = "${module.vpc.vpc_id}"
}

output "vpc_cidr_ip" {
  value = "${module.vpc.vpc_cidr_block}"
}

output "vpc_public_subnets" {
  value = "${module.vpc.public_subnets}"
}

output "vpc_private_subnets" {
  value = "${module.vpc.private_subnets}"
}

#output "vpc_database_subnets" {
 # value = "${module.vpc.database_subnets}"
#}
output "default_sg" {
   value = "${module.vpc.default_security_group_id}"
}