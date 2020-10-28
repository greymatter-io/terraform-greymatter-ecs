variable "cluster_name" {
  default     = "gm-cluster"
  description = "Name of the Grey Matter ECS Cluster"
}

variable "vpc_id" {
  description = "ID for the VPC of the Grey Matter ECS Cluster"
}

variable "aws_region" {
  description = "AWS Region"
}

variable "execution_role_arn" {
  description = "ECS Task Execution Role ARN generated in the infrastructure module."
}

variable "service_role_arn" {
  description = "ECS Service Role ARN generated in the infrastructure module."
}


variable "docker_secret_arn" {
  description = "ARN of existing Secrets Manager secret containing docker credentials (see README)"
}

variable "cluster_id" {
  description = "cluster id for greymatter ecs cluster"
}

variable "subnets" {
  type        = list(string)
  description = "List of private subnet ids in VPC. Fabric tasks must be launched in private subnets (awsvpc network type)."
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

variable "versions" {
  default = {
    gm-control = "1.5.1-dev"
    gm-control-api = "1.5.0"
    gm-proxy = "1.5.0"
  }
  type = map(string)
}

variable "sidecar_port" {
  default     = 10808
  description = "The port to use for ingress traffic to the sidecar."
}