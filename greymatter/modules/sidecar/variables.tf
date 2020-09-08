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

variable "sidecar_port" {
  default     = 10808
  description = "The port to use for ingress traffic to the sidecar."
}

variable "aws_region" {
  description = "AWS Region"
}

variable "dns_ns_name" {
  description = "Domain name for the Route 53 Hosted Zone to find and connect to Grey Matter Control"
}

variable "control_port" {
  description = "The port on which Grey Matter Control is running."
  default     = 50001
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

variable "gm_sg_id" {
  description = "ID of the security group for ECS Instances"
}

variable "access_key_arn" {
  description = "ARN of existing Systems Manager Parameter for AWS Access Key (see README)"
}

variable "secret_access_key_arn" {
  description = "ARN of existing Systems Manager parameter for AWS Secret Access Key (see README)"
}
