
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

variable "name" {
  description = "Unique name for the sidecar - this is what will be used for discovery"
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

# optional vars

variable "dns_ns_name" {
  description = "Domain name of the route53 zone to reach Grey Matter fabric (will be prefixed with 'fabric.')"
  default     = "greymatter.dev"
}

variable "sidecar_port" {
  default     = 10808
  description = "The port to use for ingress traffic to the sidecar."
}

variable "versions" {
  default = {
    gm-proxy = "1.5.0"
  }
  type = map(string)
}
