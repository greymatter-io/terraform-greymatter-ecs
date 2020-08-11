resource "aws_ecs_service" "catalog" {
  name            = "catalog"
  cluster         = "${var.greymatter_ecs_cluster}"
  task_definition = "${aws_ecs_task_definition.catalog.arn}"
  desired_count   = 1
  launch_type     = "EC2"

  load_balancer {
    target_group_arn = "${var.main_alb_target_group_arn}"
    container_name   = "proxy-catalog"
    container_port   = "8080"
  }
}

resource "aws_ecs_task_definition" "catalog" {
  family                   = "greymatter-catalog"
  container_definitions    = "${file("${path.module}/task-def.json")}"
  requires_compatibilities = ["EC2"]
  network_mode             = "host"
  cpu                      = "256"
  memory                   = "800"
  execution_role_arn       = "${var.ecs_execution_role_arn}"
  task_role_arn            = "${var.ecs_execution_role_arn}"
}
