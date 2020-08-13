variable "platform_name" {
  default = "greymatter-ecs-example"
}

variable "platform_cidr" {
  default = "192.168.0.0/16"
}

variable "peering_vpc_id" {
  default = ""
}

variable "peering_account_id" {
  default = ""
}

variable "ecs_cluster_name" {
  default = "greymatter-ecs-cluster"
}
