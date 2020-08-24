provider "aws" {
  region = var.aws_region
}

data "aws_availability_zones" "available" {}

resource "aws_vpc" "vpc" {
  cidr_block           = "10.0.0.0/24"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "Grey Matter ECS VPC"
  }
}

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc.id
}

resource "aws_subnet" "public" {
  vpc_id            = aws_vpc.vpc.id
  count             = "2"
  map_public_ip_on_launch = true
  availability_zone = element(data.aws_availability_zones.available.names, count.index)
  cidr_block        = cidrsubnet(aws_vpc.vpc.cidr_block, ceil(log(2, 2)), count.index)
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }
}

resource "aws_route_table_association" "route_table_association" {
  count = 2
  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = aws_route_table.public.id
}

module "greymatter" {
  #source                       = "git::ssh://git@github.com/greymatter-io/terraform-greymatter-ecs//greymatter?ref=master"
  source = "./greymatter"
  cluster_name                 = var.cluster_name
  key_pair_name                = var.key_pair_name
  vpc_id                       = aws_vpc.vpc.id
  subnets                      = [aws_subnet.public.0.id, aws_subnet.public.1.id]
  access_key_arn               = var.access_key_arn
  secret_access_key_arn        = var.secret_access_key_arn
  docker_secret_arn            = var.docker_secret_arn
  ca_base64                    = var.ca_base64
  key_base64                   = var.key_base64 
  cert_base64                  = var.cert_base64
}
