variable "aws_region" {
  description = "AWS Region"
}

variable "vpc_id" {
  description = "ID for the VPC of the Grey Matter ECS Cluster"
}

variable "cluster_id" {
  description = "Cluster ID for Grey Matter ECS Cluster created in the infrastructure module."
}

variable "subnets" {
  type        = list(string)
  description = "List of private subnet ids in VPC. Sidecar tasks must be launched in private subnets (awsvpc network type)."
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

variable "sidecar_sg_id" {
  description = "ID of the security group to use for the sidecar task"
}

# optional variables

variable "dns_ns_name" {
  description = "Desired domain name for the Route 53 Hosted Zone"
  default     = "greymatter.dev"
}

variable "sidecar_port" {
  default     = 10808
  description = "The port to use for ingress traffic to the sidecar."
}

variable "versions" {
  default = {
    gm-dashboard = "4.0.0"
  }
  type = map(string)
}
