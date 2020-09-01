variable "cluster_name" {
}

variable "key_pair_name" {
  type = string
}

variable "autoscaling_service_role_arn" {
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