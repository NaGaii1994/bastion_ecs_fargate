output "bastion_cluster_name" {
  value = module.bastion.cluster_name
}

output "bastion_task_family" {
  value = module.bastion.task_family
}

output "vpc_related_subnet_id" {
  value = module.vpc_related[0].subnet_id
}

output "vpc_related_security_group_id" {
  value = module.vpc_related[0].security_group_id
}