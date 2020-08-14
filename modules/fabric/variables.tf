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

variable "aws_access_key" {
    description = "AWS access key for GM_CONTROL_ECS_AWS_ACCESS_KEY_ID"
}

variable "aws_secret_access_key" {
    description = "AWS secret access key for GM_CONTROL_ECS_AWS_SECRET_ACCESS_KEY"
}

variable "subnets" {
    type = list(string)
}

variable "gm_sg_id" {}

# todo : add ssm parameter in terraform for this from aws access key vars and remove these:
variable "access_key_arn" {
    default = "arn:aws:ssm:us-east-2:090224759624:parameter/access_key"
}

variable "secret_access_key_arn" {
    default = "arn:aws:ssm:us-east-2:090224759624:parameter/secret_access_key"
}
