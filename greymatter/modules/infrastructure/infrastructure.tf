# cluster security group

resource "aws_security_group" "gm-sg" {
  name   = "gm-sg"
  vpc_id = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# autoscaling group

resource "aws_ecs_cluster" "gm-cluster" {
  name       = var.cluster_name
  depends_on = [aws_autoscaling_group.ecs-autoscaling-group]
}

data "template_file" "ecs-cluster" {
  template = file("${path.module}/ecs-cluster.tpl")

  vars = {
    ecs_cluster = "${var.cluster_name}"
    docker_user = "${lookup(var.docker_gm_credentials, "username", "")}"
    docker_password = "${lookup(var.docker_gm_credentials, "password", "")}" 
  }
}

data "aws_ami" "ecs" {
  most_recent = true # get the latest version

  filter {
    name = "name"
    values = [
    "amzn2-ami-ecs-hvm-2*"] # ECS optimized image
  }

  filter {
    name = "virtualization-type"
    values = [
    "hvm"]
  }

  owners = [
    "amazon" # Only official images
  ]
}

# TODO add size, instances variables
resource "aws_launch_configuration" "ecs-launch-configuration" {
  name                 = "ecs-launch-configuration"
  image_id             = var.optimized_ami
  instance_type        = var.instance_type
  iam_instance_profile = aws_iam_instance_profile.ecs_agent.name

  lifecycle {
    create_before_destroy = true
  }

  root_block_device {
    volume_type = "gp2"
    volume_size = 30
  }

  security_groups             = [aws_security_group.gm-sg.id]
  associate_public_ip_address = "false"
  key_name                    = var.key_pair_name
  user_data                   = data.template_file.ecs-cluster.rendered
}


data "aws_iam_policy_document" "ecs_agent" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com", "ecs.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ecs_agent" {
  name               = "ecs-agent"
  assume_role_policy = data.aws_iam_policy_document.ecs_agent.json
}


resource "aws_iam_role_policy_attachment" "ecs_agent" {
  role       = aws_iam_role.ecs_agent.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_instance_profile" "ecs_agent" {
  name = "ecs-agent"
  role = aws_iam_role.ecs_agent.name
}

resource "aws_autoscaling_group" "ecs-autoscaling-group" {
  name                 = "ecs-autoscaling-group"
  max_size             = var.max_instances
  min_size             = var.min_instances
  desired_capacity     = var.max_instances
  vpc_zone_identifier  = var.subnets
  launch_configuration = aws_launch_configuration.ecs-launch-configuration.name
  health_check_type    = "EC2"
  tags = [
    {
      key   = "Name"
      value = var.cluster_name,

      # Make sure EC2 instances are tagged with this tag as well
      propagate_at_launch = true
    }
  ]
  service_linked_role_arn = aws_iam_service_linked_role.service-role-for-autoscaling.arn
  depends_on              = [aws_iam_service_linked_role.service-role-for-autoscaling]
}

resource "aws_cloudwatch_log_group" "greymatter-logs" {
  name = "greymatter"
}

# create docker credentials secret (replaces docker_secret_arn var)
resource "aws_secretsmanager_secret" "docker_gm" {
  name = "gm-docker-secret"
}

resource "aws_secretsmanager_secret_version" "docker_gm" {
  secret_id     = aws_secretsmanager_secret.docker_gm.id
  secret_string = jsonencode(var.docker_gm_credentials)
}


# outputs
output "gm_sg_id" {
  value = aws_security_group.gm-sg.id
}

output "gm_cluster_id" {
  value = aws_ecs_cluster.gm-cluster.id
}

output "docker_secret_arn" {
  value = aws_secretsmanager_secret.docker_gm.arn
}