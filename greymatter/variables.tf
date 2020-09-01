
variable "vpc_id" {
  type = string
}

variable "cluster_name" {
  default = "gm-cluster"
}

variable "key_pair_name" {
  type    = string
}

variable "public_subnets" {}
variable "private_subnets" {}

variable "access_key_arn" {}

variable "secret_access_key_arn" {}

variable "docker_secret_arn" {}

variable "aws_region" {}

variable "dns_ns_name" {}