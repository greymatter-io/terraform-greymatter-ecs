
variable "vpc_id" {
  type = string
}

variable "cluster_name" {
  default = "gm-cluster"
}

variable "key_pair_name" {
  type    = string
  default = "enter-ecs"
}

variable "subnets" {}

variable "access_key_arn" {}

variable "secret_access_key_arn" {}

variable "docker_secret_arn" {}

variable "ca_base64" {}

variable "cert_base64" {}

variable "key_base64" {}
