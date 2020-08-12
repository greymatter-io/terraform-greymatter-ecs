
# task definitions

resource "aws_ecs_task_definition" "control-api" {
  family                   = "greymatter-control-api"
  container_definitions    = "${file("${path.module}/control-api-task.json")}"
  requires_compatibilities = ["EC2"]
  network_mode             = "host"
  cpu                      = "256"
  memory                   = "800"
  execution_role_arn       = "${var.ecs_execution_role_arn}"
  task_role_arn            = "${var.ecs_execution_role_arn}"
}

resource "aws_ecs_task_definition" "control" {
  family                   = "greymatter-control"
  container_definitions    = "${file("${path.module}/control-task.json")}"
  requires_compatibilities = ["EC2"]
  network_mode             = "host"
  cpu                      = "256"
  memory                   = "400"
  execution_role_arn = "${var.ecs_execution_role_arn}"
  task_role_arn      = "${var.ecs_execution_role_arn}"
}

resource "aws_ecs_task_definition" "control-api-sidecar" {
  family                   = "greymatter-control-api"
  container_definitions    = "${file("${path.module}/sidecar-task.json")}"
  requires_compatibilities = ["EC2"]
  network_mode             = "host"
  cpu                      = "256"
  memory                   = "400"
  execution_role_arn = "${var.ecs_execution_role_arn}"
  task_role_arn      = "${var.ecs_execution_role_arn}"
}