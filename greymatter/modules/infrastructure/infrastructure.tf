module "cluster" {
  source                 = "./cluster"
  greymatter_ecs_cluster = "${var.greymatter_ecs_cluster}"
  platform_name          = "${var.platform_name}"
}

module "iam" {
  source = "./iam"
}

module "instances" {
  source               = "./instances"
  subnet_list          = "${var.subnet_list}"
  security_group_list  = "${var.security_group_list}"
  vpc_id               = "${var.vpc_id}"
  iam_instance_profile = "${module.iam.ecs_execution_instance_profile_arn}"
}

module "security_groups" {
  source = "./security_groups"
  vpc_id = "${var.vpc_id}"
}

output "ecs_execution_role_arn" {
  value = "${module.iam.ecs_execution_role_arn}"
}

output "security_group_main_id" {
  value = "${module.security_groups.security_group_main_id}"
}

output "main_alb_target_group_arn" {
  value = "${module.instances.main_alb_target_group_arn}"
}
