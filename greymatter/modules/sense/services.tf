# service definitions

resource "aws_ecs_service" "dashboard" {
  name            = "dashboard"
  cluster         = var.cluster_id
  task_definition = aws_ecs_task_definition.dashboard.arn
  desired_count   = 1
  network_configuration {
    subnets         = var.subnets
    security_groups = [var.sidecar_sg_id]
  }
}

resource "aws_ecs_service" "catalog" {
  name            = "catalog"
  cluster         = var.cluster_id
  task_definition = aws_ecs_task_definition.catalog.arn
  desired_count   = 1
  network_configuration {
    subnets         = var.subnets
    security_groups = [var.sidecar_sg_id]
  }
}