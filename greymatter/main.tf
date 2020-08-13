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
  vpc_id                 = "${module.network.platform_vpc_id}"
  subnet_list            = ["${module.network.public_subnet_ids}"]
  security_group_list    = "${module.infrastructure.security_group_main_id}"
}

module "network" {
  source             = "./modules/network"
  platform_name      = "${var.platform_name}"
  platform_cidr      = "${var.platform_cidr}"
  peering_vpc_id     = "${var.peering_vpc_id}"
  peering_account_id = "${var.peering_account_id}"
}

module "greymatter" {
  source                    = "git::ssh://git@github.com/greymatter-io/terraform-greymatter-ecs//greymatter?ref=module-format"
  greymatter_ecs_cluster    = "${var.ecs_cluster_name}"
  ecs_execution_role_arn    = "${module.infrastructure.ecs_execution_role_arn}"
  platform_name             = "${var.platform_name}"
  main_alb_target_group_arn = "${module.infrastructure.main_alb_target_group_arn}"
  subnet_list               = ["${module.network.public_subnet_ids}"]
  security_group_list       = "${module.infrastructure.security_group_main_id}"
}
