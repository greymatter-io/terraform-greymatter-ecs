module "infrastructure" {
  source                 = "./modules/infrastructure"
  cluster_name           = var.cluster_name
  key_pair_name          = var.key_pair_name
  subnets                = concat(var.public_subnets, var.private_subnets)
  vpc_id                 = var.vpc_id
  kms_ssm_arn            = var.kms_ssm_arn
  kms_secretsmanager_arn = var.kms_secretsmanager_arn
  access_key_arn         = var.access_key_arn
  secret_access_key_arn  = var.secret_access_key_arn
  optimized_ami          = var.optimized_ami
  docker_gm_credentials  = var.docker_gm_credentials
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
  access_key_arn        = var.access_key_arn
  secret_access_key_arn = var.secret_access_key_arn
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
  access_key_arn        = var.access_key_arn
  secret_access_key_arn = var.secret_access_key_arn
  name                  = "control-api"
  control_port          = 50001
  aws_region            = var.aws_region
  dns_ns_name           = var.dns_ns_name
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
  access_key_arn        = var.access_key_arn
  secret_access_key_arn = var.secret_access_key_arn
  control_port          = 50001
  aws_region            = var.aws_region
  dns_ns_name           = var.dns_ns_name
}