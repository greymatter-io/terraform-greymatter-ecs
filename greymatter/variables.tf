
variable "vpc_id" {
  description = "ID for the VPC to launch Grey Matter ECS Cluster"
}

variable "cluster_name" {
  default     = "gm-cluster"
  description = "Name of the Grey Matter ECS Cluster"
}

variable "key_pair_name" {
  description = "Existing AWS Key Pair for EC2 Instances"
}

variable "public_subnets" {
  type        = list(string)
  description = "List of public subnet ids in VPC"
}

variable "private_subnets" {
  type        = list(string)
  description = "List of private subnet ids in VPC"
}

variable "access_key_arn" {
  description = "ARN of existing Systems Manager Parameter for AWS Access Key (see README)"
}

variable "secret_access_key_arn" {
  description = "ARN of existing Systems Manager parameter for AWS Secret Access Key (see README)"
}

variable "aws_region" {
  description = "AWS Region"
}

variable "dns_ns_name" {
  description = "Desired domain name for new Route 53 Hosted Zone"
}

variable "kms_ssm_arn" {
  description = "ARN of Key Management Service AWS managed key with alias aws/ssm. Find it here: `aws kms describe-key --key-id alias/aws/ssm`."
}

variable "kms_secretsmanager_arn" {
  description = "ARN of Key Management Service AWS managed key with alias aws/secretsmanager. Find it here: `aws kms describe-key --key-id alias/aws/secretsmanager`."
}

variable "optimized_ami" {
  description = "ECS Optimized AMI for region - found here: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/ecs-optimized_AMI.html"
}

variable "docker_gm_credentials" {
  default = {
    key1 = "username"
    key2 = "password"
  }
  description = "Docker credentials for greymatter nexus repository"
  type = map(string)
}