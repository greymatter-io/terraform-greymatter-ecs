resource "aws_ecs_service" "poa" {
  name            = "poa"
  cluster         = "${var.greymatter_ecs_cluster}"
  task_definition = "${aws_ecs_task_definition.poa_def.arn}"
  desired_count   = 1
  launch_type     = "EC2"

  load_balancer {
    target_group_arn = "${var.main_alb_target_group_arn}"
    container_name   = "poa"
    container_port   = "9091"
  }
}

resource "aws_ecs_task_definition" "poa_def" {
  family                   = "greymatter-poa"
  container_definitions    = "${file("${path.module}/task-def.json")}"
  requires_compatibilities = ["EC2"]
  network_mode             = "host"
  cpu                      = "256"
  memory                   = "800"
  execution_role_arn       = "${var.ecs_execution_role_arn}"
  task_role_arn            = "${var.ecs_execution_role_arn}"

  volume {
    name      = "certs"
    host_path = "/home/ec2-user/pki"
  }

  volume {
    name      = "poa-settings"
    host_path = "/home/ec2-user/poa/settings.toml"
  }
}

# resource "aws_efs_file_system" "poa_settings" {
#   creation_token = "efs-poa-settings"


#   lifecycle_policy {
#     transition_to_ia = "AFTER_30_DAYS"
#   }
# }


# resource "aws_efs_mount_target" "poa_settings" {
#   file_system_id  = "${aws_efs_file_system.poa_settings.id}"
#   subnet_id       = "subnet-0c98f17a06e2bdcb6"
#   security_groups = ["sg-0cf1296ff756aa71f"]
# }

