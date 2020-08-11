variable "ecs_execution_role_arn" {
    type = string
    description = "ecsTaskExecutionRole ARN"
}

variable "docker_secret_arn" {
    description = "ARN of AWS secret containing dockerß repository credentials"
}

variable "service_role_arn" {
    description = "ecsServiceRole ARN"
}

variable "vpc_id" {
    description = "VPC id for greymatter"
}

variable "cluster_id" {
    description = "cluster id for greymatter ecs cluster"
}