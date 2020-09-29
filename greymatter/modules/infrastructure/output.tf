# outputs - needed for other modules

# output info on gm security group and the gm ecs cluster created
# found in infrastructure.tf
output "gm_sg_id" {
  value = aws_security_group.gm-sg.id
}

output "gm_cluster_id" {
  value = aws_ecs_cluster.gm-cluster.id
}

# output info on credentials resources
# found in credentials.tf
output "docker_secret_arn" {
  value = aws_secretsmanager_secret.docker_gm.arn
}

output "ssm_access_key_arn" {
  value = aws_ssm_parameter.aws_access_key.arn
}

output "ssm_secret_access_key_arn" {
  value = aws_ssm_parameter.aws_secret_access_key.arn
}

# output info on aws iam roles needed for ecs services/tasks
# found in ecs-roles.tf
output "ecs-service-role-arn" {
  value = aws_iam_role.ecs-service-role.arn
}

output "ecs-task-execution-role-arn" {
  value = aws_iam_role.ecs-task-execution-role.arn
}