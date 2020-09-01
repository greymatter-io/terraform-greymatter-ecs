data "aws_caller_identity" "current" {}

locals {
  service_role_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/ecsServiceRole"
  execution_role_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/ecsTaskExecutionRole"
  autoscaling_service_role_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/aws-service-role/autoscaling.amazonaws.com/AWSServiceRoleForAutoScaling"
}

module "infrastructure" {
  source                       = "./modules/infrastructure"
  cluster_name                 = var.cluster_name
  key_pair_name                = var.key_pair_name
  autoscaling_service_role_arn = local.autoscaling_service_role_arn
  subnets                      = concat(var.public_subnets, var.private_subnets)
  public_subnet1               = var.public_subnets[0]
  vpc_id                       = var.vpc_id
}


module "fabric" {
  source                 = "./modules/fabric"
  service_role_arn       = local.service_role_arn
  execution_role_arn     = local.execution_role_arn
  docker_secret_arn      = var.docker_secret_arn
  vpc_id                 = var.vpc_id
  cluster_id             = module.infrastructure.gm_cluster_id
  subnets                = var.private_subnets
  gm_sg_id               = module.infrastructure.gm_sg_id
  access_key_arn         = var.access_key_arn
  secret_access_key_arn  = var.secret_access_key_arn
  aws_region             = var.aws_region
  ca_base64              = var.ca_base64
  cert_base64            = var.cert_base64
  key_base64             = var.key_base64
}

#module "control-api-sidecar" {
#  source                 = "./modules/sidecar"
#  service_role_arn       = local.service_role_arn
#  execution_role_arn     = local.execution_role_arn
#  docker_secret_arn      = var.docker_secret_arn
#  vpc_id                 = var.vpc_id
#  cluster_id             = module.infrastructure.gm_cluster_id
#  subnets                = var.subnets
#  gm_sg_id               = module.infrastructure.gm_sg_id
#  access_key_arn         = var.access_key_arn
#  secret_access_key_arn  = var.secret_access_key_arn
#  name                   = "control-api"
#  control_dns            = module.fabric.control_dns
#  control_port           = 50001
#  aws_region             = var.aws_region
#}
#
#module "edge" {
#  source                 = "./modules/sidecar"
#  service_role_arn       = local.service_role_arn
#  execution_role_arn     = local.execution_role_arn
#  docker_secret_arn      = var.docker_secret_arn
#  vpc_id                 = var.vpc_id
#  cluster_id             = module.infrastructure.gm_cluster_id
#  subnets                = var.subnets
#  gm_sg_id               = module.infrastructure.gm_sg_id
#  access_key_arn         = var.access_key_arn
#  secret_access_key_arn  = var.secret_access_key_arn
#  name                   = "edge"
#  control_dns            = module.fabric.control_dns
#  control_port           = 50001
#  aws_region             = var.aws_region
#}