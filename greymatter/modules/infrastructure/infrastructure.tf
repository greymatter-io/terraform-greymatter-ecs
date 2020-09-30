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

# ecs cluster
resource "aws_ecs_cluster" "gm-cluster" {
  name       = var.cluster_name
  depends_on = [aws_autoscaling_group.ecs-autoscaling-group]
}

data "template_file" "ecs-cluster" {
  template = file("${path.module}/ecs-cluster.tpl")

  vars = {
    ecs_cluster = "${var.cluster_name}"
  }
}

# launch config for ecs cluster
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

# autoscaling group for ecs cluster launch config
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
      propagate_at_launch = true
    }
  ]
  service_linked_role_arn = aws_iam_service_linked_role.service-role-for-autoscaling.arn
  depends_on              = [aws_iam_service_linked_role.service-role-for-autoscaling]
}

# cloudwatch group for ecs task logs
resource "aws_cloudwatch_log_group" "greymatter-logs" {
  name = "greymatter"
}

# reusable sidecar security group
resource "aws_security_group" "sidecar-sg" {
  name   = "gm-sidecar-sg"
  vpc_id = var.vpc_id
  ingress {
    from_port   = var.sidecar_port
    to_port     = var.sidecar_port
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
