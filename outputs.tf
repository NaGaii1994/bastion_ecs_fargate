output "bastion_cluster_name" {
  value = module.bastion.cluster_name
}

output "bastion_task_family" {
  value = module.bastion.task_family
}

output "bastion_ecr" {
  value = module.bastion.ecr
}

output "aws_region" {
  value = data.aws_region.current.name
}

output "aws_account_id" {
  value = data.aws_caller_identity.current.account_id
}