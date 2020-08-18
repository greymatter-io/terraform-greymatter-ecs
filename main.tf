provider "aws" {
  region = "us-east-2"
}

module "greymatter" {
  source                       = "git::ssh://git@github.com/greymatter-io/terraform-greymatter-ecs//greymatter?ref=add_modules"
  security_group_name          = "gm-sg"
  cluster_name                 = "gm-cluster"
  key_pair_name                = "enter-ecs"
  autoscaling_service_role_arn = "arn:aws:iam::269783025111:role/aws-service-role/autoscaling.amazonaws.com/AWSServiceRoleForAutoScaling"
  vpc_id                       = "vpc-95f405fe"
}
