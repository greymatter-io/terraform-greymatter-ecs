
module "infrastructure" {
  source                       = "./modules/infrastructure"
  security_group_name          = var.security_group_name
  cluster_name                 = var.cluster_name
  key_pair_name                = var.key_pair_name
  autoscaling_service_role_arn = var.autoscaling_service_role_arn
}


module "fabric" {
  source                 = "./modules/fabric"
  ecs_execution_role_arn = var.execution_role_arn
  docker_secret_arn      = var.docker_secret_arn
  service_role_arn       = var.service_role_arn
  vpc_id                 = var.vpc_id
  cluster_id             = module.infrastructure.aws_ecs_cluster.gm-cluster.id
  subnets                = var.subnets
  gm_sg_id               = module.infrastructure.aws_security_group.gm-sg.id
}
