
variable "vpc_id" {
  type = string
}

variable "docker_secret_arn" {
  type = string
}

variable "execution_role_arn" {
}

variable "service_role_arn" {
}

variable "security_group_name" {
}

variable "cluster_name" {
}

variable "key_pair_name" {
  type = string
}

variable "autoscaling_service_role_arn" {
  type = string
}
