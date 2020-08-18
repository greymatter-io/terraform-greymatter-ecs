
variable "vpc_id" {
  type = string
}

variable "docker_secret_arn" {
  type    = string
  default = "arn:aws:secretsmanager:us-east-2:269783025111:secret:deciphernow-docker-yYVtgb"
}

variable "execution_role_arn" {
  default = "arn:aws:iam::269783025111:role/ecsTaskExecutionRole"

}

variable "service_role_arn" {
  default = "arn:aws:iam::269783025111:role/ecsServiceRole"
}

variable "security_group_name" {
  default = "gm-sg"
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
  default = "arn:aws:iam::269783025111:role/aws-service-role/autoscaling.amazonaws.com/AWSServiceRoleForAutoScaling"
}
