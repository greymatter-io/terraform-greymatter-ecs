variable "cluster_name" {
  default = "gm-cluster"
  description = "Name of the Grey Matter ECS Cluster"
}

variable "vpc_id" {
  type = string
  description = "ID for the VPC of the Grey Matter ECS Cluster"
}

variable "aws_region" {
  description = "AWS Region"
}

variable "execution_role_arn" {
  type        = string
  description = "ecsTaskExecutionRole ARN"
}

variable "docker_secret_arn" {
  description = "ARN of existing Secrets Manager secret containing docker credentials (see README)"
}

variable "service_role_arn" {
  description = "ecsServiceRole ARN"
}

variable "cluster_id" {
  description = "cluster id for greymatter ecs cluster"
}

variable "subnets" {
  description = "List of private subnet ids in VPC. Fabric tasks must be launched in private subnets (awsvpc network type)."
}

variable "gm_sg_id" {
  description = "ID of the security group for ECS Instances"
}

variable "access_key_arn" {
  description = "ARN of existing Systems Manager Parameter for AWS Access Key (see README)"
}

variable "secret_access_key_arn" {
  description = "ARN of existing Systems Manager parameter for AWS Secret Access Key (see README)"
}

variable "dns_ns_name" {
  description = "Desired domain name for new Route 53 Hosted Zone"
}
