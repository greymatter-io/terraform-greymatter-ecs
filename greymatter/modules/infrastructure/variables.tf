variable "vpc_id" {
  description = "ID for the VPC to launch Grey Matter ECS Cluster"
}

variable "key_pair_name" {
  description = "Existing AWS Key Pair for EC2 Instances"
}

variable "subnets" {
  type        = list(string)
  description = "List of all subnets, private and public, in the VPC"
}

variable "optimized_ami" {
  description = "ECS Optimized AMI for region - found here: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/ecs-optimized_AMI.html"
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

variable "instance_type" {
  default     = "t3.xlarge"
  description = "Instance type for EC2 instances."
}

variable "max_instances" {
  default = 3
}

variable "min_instances" {
  default = 0
}