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

# gateways
resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc.id
}

resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_gw.id
  subnet_id     = aws_subnet.public[1].id
}

# NAT gateways require an EIP
resource "aws_eip" "nat_gw" {
  vpc   = true
}

# public subnets
resource "aws_subnet" "public" {
  vpc_id            = aws_vpc.vpc.id
  count             = 2
  map_public_ip_on_launch = true
  availability_zone = element(data.aws_availability_zones.available.names, count.index)
  cidr_block        = cidrsubnet(aws_vpc.vpc.cidr_block, 4, count.index + 2)
}

# private subnets
resource "aws_subnet" "private" {
  count = 2
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = cidrsubnet(aws_vpc.vpc.cidr_block, 4, count.index + 4)
  availability_zone       = element(data.aws_availability_zones.available.names, count.index)
  map_public_ip_on_launch = false
}

# route tables
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.vpc.id
}

# public routes
resource "aws_route" "public_default_route" {
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.internet_gateway.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_route_table_association" {
  count = 2
  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = aws_route_table.public.id
}

# private routes
resource "aws_route" "private_default_route" {
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.nat_gw.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_route_table_association" {
  count = 2
  subnet_id      = element(aws_subnet.private.*.id, count.index)
  route_table_id = aws_route_table.private.id
}


module "greymatter" {
  source                       = "git::ssh://git@github.com/greymatter-io/terraform-greymatter-ecs//greymatter?ref=master"
  cluster_name                 = var.cluster_name
  key_pair_name                = var.key_pair_name
  vpc_id                       = aws_vpc.vpc.id
  public_subnets               = [aws_subnet.public.0.id, aws_subnet.public.1.id]
  private_subnets              = [aws_subnet.private.0.id, aws_subnet.private.1.id]               
  access_key_arn               = var.access_key_arn
  secret_access_key_arn        = var.secret_access_key_arn
  docker_secret_arn            = var.docker_secret_arn
  aws_region                   = var.aws_region
  dns_ns_name                  = var.dns_ns_name
  kms_ssm_arn                  = var.kms_ssm_arn
  kms_secretsmanager_arn       = var.kms_secretsmanager_arn
  optimized_ami                = var.optimized_ami
}
