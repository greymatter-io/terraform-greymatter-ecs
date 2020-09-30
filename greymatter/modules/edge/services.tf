# edge ecs service, linked to edge lb
resource "aws_ecs_service" "edge" {
  name            = "edge"
  cluster         = var.cluster_id
  task_definition = aws_ecs_task_definition.edge-task.arn
  desired_count   = 1

  network_configuration {
    subnets         = var.subnets
    security_groups = [var.sidecar_sg_id]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.edge.arn
    container_name   = "edge"
    container_port   = var.sidecar_port
  }

  depends_on = [aws_lb_target_group.edge]
}

# public route53 zone creating ingress into mesh
resource "aws_route53_zone" "gm" {
  name = var.dns_ns_name
}

# route53 record for edge for easier ingress
resource "aws_route53_record" "edge" {
  zone_id = aws_route53_zone.gm.id
  name    = "edge.${var.dns_ns_name}"
  type    = "A"

  alias {
    name                   = aws_lb.edge.dns_name
    zone_id                = aws_lb.edge.zone_id
    evaluate_target_health = true
  }
}