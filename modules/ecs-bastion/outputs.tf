output "cluster_id" {
  value = aws_ecs_cluster.this.id
}

output "cluster_name" {
  value = var.cluster_name
}

output "task_family" {
  value = var.task_family
}

output "task_definition_arn" {
  value = aws_ecs_task_definition.this.arn
}

output "task_execution_role_arn" {
  value = aws_iam_role.this.arn
}

output "ecr" {
  value = "${data.aws_caller_identity.current.account_id}.dkr.ecr.ap-northeast-1.amazonaws.com/${var.name_prefix}-ecr"
}