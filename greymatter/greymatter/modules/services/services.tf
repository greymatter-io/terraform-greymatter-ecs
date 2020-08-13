variable "ecs_execution_role_arn" {}
variable "greymatter_ecs_cluster" {}
variable "platform_name" {}
variable "main_alb_target_group_arn" {}

variable "subnet_list" {
  default = []
}

variable "security_group_list" {}

module "control" {
  source                    = "./control"
  greymatter_ecs_cluster    = "${var.greymatter_ecs_cluster}"
  platform_name             = "${var.platform_name}"
  ecs_execution_role_arn    = "${var.ecs_execution_role_arn}"
  main_alb_target_group_arn = "${var.main_alb_target_group_arn}"
  subnet_list               = ["${var.subnet_list}"]
  security_group_list       = "${var.security_group_list}"
}

module "control_api" {
  source                    = "./control_api"
  greymatter_ecs_cluster    = "${var.greymatter_ecs_cluster}"
  platform_name             = "${var.platform_name}"
  ecs_execution_role_arn    = "${var.ecs_execution_role_arn}"
  main_alb_target_group_arn = "${var.main_alb_target_group_arn}"
  subnet_list               = ["${var.subnet_list}"]
  security_group_list       = "${var.security_group_list}"
}

module "catalog" {
  source                    = "./catalog"
  greymatter_ecs_cluster    = "${var.greymatter_ecs_cluster}"
  platform_name             = "${var.platform_name}"
  ecs_execution_role_arn    = "${var.ecs_execution_role_arn}"
  main_alb_target_group_arn = "${var.main_alb_target_group_arn}"
  subnet_list               = ["${var.subnet_list}"]
  security_group_list       = "${var.security_group_list}"
}