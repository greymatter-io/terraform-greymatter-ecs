provider "aws" {
  region = "us-east-2"
}

# cluster security group

resource "aws_security_group" "gm-sg" {
  name = "gm-sg"
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

# autoscaling group

resource "aws_ecs_cluster" "gm-cluster" {
  name = "gm-cluster"
  depends_on = [aws_autoscaling_group.ecs-autoscaling-group]
}

# TODO add keypair val
resource "aws_launch_configuration" "ecs-launch-configuration" {
    name                        = "ecs-launch-configuration"
    image_id                    = "ami-078d79190068a1b35"
    instance_type               = "t2.small"
    iam_instance_profile        = "ecsInstanceRole"

    lifecycle {
      create_before_destroy = true
    }

    root_block_device {
      volume_type = "gp2"
      volume_size = 30
    }

    security_groups             = [aws_security_group.gm-sg.id]
    associate_public_ip_address = "false"
    key_name                    = "ohiominikube"
    user_data                   = <<EOF
#!/bin/bash
echo ECS_CLUSTER=gm-cluster >> /etc/ecs/ecs.config
EOF
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
    name                        = "ecs-autoscaling-group"
    max_size                    = "1"
    min_size                    = "0"
    desired_capacity            = "1"
    vpc_zone_identifier         = var.subnets
    launch_configuration        = aws_launch_configuration.ecs-launch-configuration.name
    health_check_type           = "EC2"
    availability_zones = ["us-east-2a",
                "us-east-2b",
                "us-east-2c"]
    tags = [
    {
        key                 = "Name"
        value               = "gm-cluster",

        # Make sure EC2 instances are tagged with this tag as well
        propagate_at_launch = true
      }
    ]
    service_linked_role_arn = "arn:aws:iam::090224759624:role/aws-service-role/autoscaling.amazonaws.com/AWSServiceRoleForAutoScaling"
  }

//resource "aws_ecs_capacity_provider" "gm-provider" {
//  name = "gm-provider"
//
//  auto_scaling_group_provider {
//    auto_scaling_group_arn         = aws_autoscaling_group.ecs-autoscaling-group.arn
//
//    managed_scaling {
//      maximum_scaling_step_size = 1000
//      minimum_scaling_step_size = 1
//      status                    = "ENABLED"
//      target_capacity           = 10
//    }
//  }
//}


module "fabric" {
  source        = "./modules/fabric"
  ecs_execution_role_arn = var.execution_role_arn
  docker_secret_arn = var.docker_secret_arn
  service_role_arn = var.service_role_arn
  vpc_id = var.vpc_id
  cluster_id = aws_ecs_cluster.gm-cluster.id
  aws_access_key = var.aws_access_key
  aws_secret_access_key = var.aws_secret_access_key
  subnets = var.subnets
  gm_sg_id = aws_security_group.gm-sg.id
}
