# cluster security group

resource "aws_security_group" "gm-sg" {
  name = var.security_group_name
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

# autoscaling group

resource "aws_ecs_cluster" "gm-cluster" {
  name       = var.cluster_name
  depends_on = [aws_autoscaling_group.ecs-autoscaling-group]
}

# TODO add keypair val
resource "aws_launch_configuration" "ecs-launch-configuration" {
  name                 = "ecs-launch-configuration"
  image_id             = "ami-078d79190068a1b35"
  instance_type        = "t2.small"
  iam_instance_profile = "ecsInstanceRole"

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
  user_data                   = "${file("${path.module}/ecs-cluster.tpl")}"
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
  name             = "ecs-autoscaling-group"
  max_size         = "1"
  min_size         = "0"
  desired_capacity = "1"
  #vpc_zone_identifier  = var.subnets
  launch_configuration = aws_launch_configuration.ecs-launch-configuration.name
  health_check_type    = "EC2"
  availability_zones   = ["us-east-2a", "us-east-2b", "us-east-2c"]
  tags = [
    {
      key   = "Name"
      value = var.cluster_name,

      # Make sure EC2 instances are tagged with this tag as well
      propagate_at_launch = true
    }
  ]
  service_linked_role_arn = var.autoscaling_service_role_arn
}

output "gm_sg_id" {
  value = aws_security_group.gm-sg.id
}

output "gm_cluster_id" {
  value = aws_ecs_cluster.gm-cluster.id
}
