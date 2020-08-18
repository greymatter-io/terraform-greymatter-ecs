//variable "platform_name" {
//  default = "greymatter-ecs-example"
//}
//
//variable "platform_cidr" {
//  default = "192.168.0.0/16"
//}
//
//variable "peering_vpc_id" {
//  default = ""
//}
//
//variable "peering_account_id" {
//  default = ""
//}
//
//variable "ecs_cluster_name" {
//  default = "greymatter-ecs-cluster"
//}
//
//variable "aws_access_key" {
//    description = "AWS access key for GM_CONTROL_ECS_AWS_ACCESS_KEY_ID"
//}
//
//variable "aws_secret_access_key" {
//    description = "AWS secret access key for GM_CONTROL_ECS_AWS_SECRET_ACCESS_KEY"
//}


variable "vpc_id" {
  type    = string
  default = "vpc-95f405fe"
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

//variable "aws_access_key" {
//    description = "AWS access key for GM_CONTROL_ECS_AWS_ACCESS_KEY_ID"
//}

//variable "aws_secret_access_key" {
//    description = "AWS secret access key for GM_CONTROL_ECS_AWS_SECRET_ACCESS_KEY"
//}

variable "subnets" {
  type    = list(string)
  default = ["subnet-6111ae2d", "subnet-682b3200", "subnet-8a8ddaf0"]
}

//variable "aws_access_key_arn" {
//}

//variable "aws_secret_access_key_arn" {
//}
