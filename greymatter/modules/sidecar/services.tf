# sidecar ecs service
resource "aws_ecs_service" "sidecar" {
  name            = "${var.name}-sidecar"
  cluster         = var.cluster_id
  task_definition = aws_ecs_task_definition.sidecar-task.arn
  desired_count   = 1

  network_configuration {
    subnets         = var.subnets
    security_groups = [var.sidecar_sg_id]
  }
}