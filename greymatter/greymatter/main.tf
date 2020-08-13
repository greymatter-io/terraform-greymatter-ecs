# terraform {
#   backend "s3" {
#     bucket   = "greymatter-use2-tfstate"
#     key      = "greymatter-init-terraform/terraform.tfstate"
#     region   = "us-east-1"
#     role_arn = ""
#   }
# }

provider "aws" {
  region = "us-east-1"
}

module "infrastructure" {
  source                 = "./modules/infrastructure"
  platform_name          = "${var.platform_name}"
  greymatter_ecs_cluster = "${var.ecs_cluster_name}"
  vpc_id                 = "${var.vpc_id}"
  subnet_list            = ["${var.public_subnet_ids}"]
  security_group_list    = "${var.security_group_main_id}"
}

module "services" {
  source                    = "./modules/services"
  greymatter_ecs_cluster    = "${var.ecs_cluster_name}"
  ecs_execution_role_arn    = "${module.infrastructure.ecs_execution_role_arn}"
  platform_name             = "${var.platform_name}"
  main_alb_target_group_arn = "${module.infrastructure.main_alb_target_group_arn}"
  subnet_list               = ["${module.network.public_subnet_ids}"]
  security_group_list       = "${module.infrastructure.security_group_main_id}"
}
