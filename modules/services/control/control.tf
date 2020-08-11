resource "aws_ecs_service" "control" {
  name            = "control"
  cluster         = "${var.greymatter_ecs_cluster}"
  task_definition = "${aws_ecs_task_definition.control.arn}"
  desired_count   = 1
  launch_type     = "EC2"

  load_balancer {
    target_group_arn = "${var.main_alb_target_group_arn}"
    container_name   = "control"
    container_port   = "50000"
  }
}

resource "aws_ecs_task_definition" "control" {
  family                   = "greymatter-control"
  container_definitions    = "${file("${path.module}/task-def.json")}"
  requires_compatibilities = ["EC2"]
  network_mode             = "host"
  cpu                      = "256"
  memory                   = "400"

  execution_role_arn = "${var.ecs_execution_role_arn}"
  task_role_arn      = "${var.ecs_execution_role_arn}"
}
