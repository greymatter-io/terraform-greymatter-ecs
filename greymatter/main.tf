module "infrastructure" {
  source                 = "./modules/infrastructure"
  cluster_name           = var.cluster_name
  key_pair_name          = var.key_pair_name
  subnets                = concat(var.public_subnets, var.private_subnets)
  vpc_id                 = var.vpc_id
  optimized_ami          = var.optimized_ami
  docker_gm_credentials  = var.docker_gm_credentials
  aws_access_key_id      = var.aws_access_key_id
  aws_secret_access_key  = var.aws_secret_access_key
  instance_type          = var.ec2_instance_type
  max_instances          = var.ec2_max_instances
  min_instances          = var.ec2_min_instances
  sidecar_port          = var.sidecar_port
}


module "fabric" {
  source                = "./modules/fabric"
  service_role_arn      = module.infrastructure.ecs-service-role-arn
  execution_role_arn    = module.infrastructure.ecs-task-execution-role-arn
  docker_secret_arn     = module.infrastructure.docker_secret_arn
  cluster_name          = var.cluster_name
  vpc_id                = var.vpc_id
  cluster_id            = module.infrastructure.gm_cluster_id
  subnets               = var.private_subnets
  gm_sg_id              = module.infrastructure.gm_sg_id
  access_key_arn        = module.infrastructure.ssm_access_key_arn
  secret_access_key_arn = module.infrastructure.ssm_secret_access_key_arn
  aws_region            = var.aws_region
  dns_ns_name           = var.dns_ns_name
}

module "control-api-sidecar" {
  source                = "./modules/sidecar"
  service_role_arn      = module.infrastructure.ecs-service-role-arn
  execution_role_arn    = module.infrastructure.ecs-task-execution-role-arn
  docker_secret_arn     = module.infrastructure.docker_secret_arn
  vpc_id                = var.vpc_id
  cluster_id            = module.infrastructure.gm_cluster_id
  subnets               = var.private_subnets
  gm_sg_id              = module.infrastructure.gm_sg_id
  name                  = "control-api"
  aws_region            = var.aws_region
  dns_ns_name           = var.dns_ns_name
  sidecar_port          = var.sidecar_port
  sidecar_sg_id         = module.infrastructure.sidecar_sg_id
}

module "edge" {
  source                = "./modules/edge"
  service_role_arn      = module.infrastructure.ecs-service-role-arn
  execution_role_arn    = module.infrastructure.ecs-task-execution-role-arn
  docker_secret_arn     = module.infrastructure.docker_secret_arn
  vpc_id                = var.vpc_id
  cluster_id            = module.infrastructure.gm_cluster_id
  subnets               = var.public_subnets
  gm_sg_id              = module.infrastructure.gm_sg_id
  aws_region            = var.aws_region
  dns_ns_name           = var.dns_ns_name
  sidecar_port          = var.sidecar_port
  sidecar_sg_id         = module.infrastructure.sidecar_sg_id
}

output "edge_dns" {
  value = module.edge.edge_dns
}