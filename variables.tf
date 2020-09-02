variable "cluster_name" {
  default = "gm-cluster"
  description = "Name of the Grey Matter ECS Cluster"
}

variable "key_pair_name" {
  type    = string
  description = "Existing AWS Key Pair for EC2 Instances"
}

variable "access_key_arn" {
  description = "ARN of existing Systems Manager Parameter for AWS Access Key (see README)"
}

variable "secret_access_key_arn" {
  description = "ARN of existing Systems Manager parameter for AWS Secret Access Key (see README)"
}

variable "docker_secret_arn" {
  description = "ARN of existing Secrets Manager secret containing docker credentials (see README)"
}

variable "aws_region" {
  description = "AWS Region"
}

variable "dns_ns_name" {
  description = "Desired domain name for new Route 53 Hosted Zone"
  default = "greymatter.dev"
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