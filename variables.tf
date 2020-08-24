variable "aws_region" {
  default = "us-east-2"
}

variable "cluster_name" {
  default = "gm-cluster"
}

variable "key_pair_name" {
  type    = string
}

variable "docker_secret_arn" {
  type    = string
}

variable "access_key_arn" {}

variable "secret_access_key_arn" {}

variable "ca_base64" {}

variable "cert_base64" {}

variable "key_base64" {}
