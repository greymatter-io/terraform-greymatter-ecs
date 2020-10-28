variable "aws_region" {
  description = "AWS Region"
}

variable "key_pair_name" {
  description = "Existing AWS Key Pair for EC2 Instances"
}

variable "optimized_ami" {
  description = "ECS Optimized AMI for region - found here: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/ecs-optimized_AMI.html#ecs-optimized-ami-linux"
}

variable "docker_gm_credentials" {
  description = "Docker credentials for greymatter nexus repository"
  type        = map(string)
}

variable "aws_access_key_id" {
  description = "AWS Secret Access Key"
}

variable "aws_secret_access_key" {
  description = "AWS Secret Access Key"
}

# optional vars

variable "cluster_name" {
  default     = "gm-cluster"
  description = "Name of the Grey Matter ECS Cluster"
}

variable "dns_ns_name" {
  description = "Desired domain name for new Route 53 Hosted Zone"
  default     = "greymatter.dev"
}

variable "ec2_instance_type" {
  default     = "t3.xlarge"
  description = "Instance type for EC2 instances."
}

variable "ec2_max_instances" {
  default = 3
}

variable "ec2_min_instances" {
  default = 0
}

variable "sidecar_port" {
  default     = 10808
  description = "The port to use for ingress traffic to the sidecar."
}

variable "versions" {
  default = {
    gm-proxy = "1.5.0"
    gm-control = "1.5.1-dev"
    gm-control-api = "1.5.0"
    gm-dashboard = "4.0.0"
  }
  type = map(string)
}
