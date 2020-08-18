provider "aws" {
  region = "us-east-2"
}

data "aws_availability_zones" "available" {}

resource "aws_vpc" "vpc" {
  cidr_block           = "10.0.0.0/24"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "ECS VPC"
  }
}

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc.id
}

resource "aws_subnet" "public" {
  vpc_id            = aws_vpc.vpc.id
  count             = "2"
  availability_zone = "${element(data.aws_availability_zones.available.names, count.index)}"
  cidr_block        = "${cidrsubnet(aws_vpc.vpc.cidr_block, ceil(log(2, 2)), count.index)}"
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }
}

resource "aws_route_table_association" "route_table_association" {
  subnet_id      = "${element(aws_subnet.public.*.id, 2)}"
  route_table_id = aws_route_table.public.id
}

module "greymatter" {
  source                       = "git::ssh://git@github.com/greymatter-io/terraform-greymatter-ecs//greymatter?ref=add_modules"
  security_group_name          = "gm-sg"
  cluster_name                 = "gm-cluster"
  key_pair_name                = "enter-ecs"
  autoscaling_service_role_arn = "arn:aws:iam::269783025111:role/aws-service-role/autoscaling.amazonaws.com/AWSServiceRoleForAutoScaling"
  vpc_id                       = aws_vpc.vpc.id
  subnets                      = ["subnet-099a269f5c9732b3a", "subnet-02c91dc0d4ae1b1ec"]
}
