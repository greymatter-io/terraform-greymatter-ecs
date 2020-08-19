variable "security_group_name" {
  type    = string
  default = "gm-sg"
}

variable "aws_region" {
  default = "us-east-2"
}

variable "docker_secret_arn" {
  type    = string
}

variable "execution_role_arn" {

}

variable "service_role_arn" {
}

variable "cluster_name" {
  default = "gm-cluster"
}

variable "key_pair_name" {
  type    = string
  default = "enter-ecs"
}

variable "autoscaling_service_role_arn" {
  type    = string
}

variable "access_key_arn" {}

variable "secret_access_key_arn" {}