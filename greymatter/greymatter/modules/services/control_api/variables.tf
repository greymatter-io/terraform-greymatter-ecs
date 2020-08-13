variable "greymatter_ecs_cluster" {}
variable "platform_name" {}
variable "ecs_execution_role_arn" {}
variable "main_alb_target_group_arn" {}

variable "subnet_list" {
  default = []
}

variable "security_group_list" {}
