variable "cluster_name" {
}

variable "key_pair_name" {
  type = string
}

variable "subnets" {
}

variable "vpc_id" {
}

variable "instance_type" {
  default = "t3.xlarge"
}

variable "max_instances" {
  default = 3
}

variable "min_instances" {
  default = 0
}

variable "kms_ssm_arn" {}
variable "kms_secretsmanager_arn" {}

variable "docker_secret_arn" {}
variable "access_key_arn" {}
variable "secret_access_key_arn" {}