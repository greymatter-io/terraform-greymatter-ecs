

# service definition

resource "aws_ecs_service" "sidecar" {
    name = "${var.name}-sidecar"
    cluster = var.cluster_id
    task_definition = aws_ecs_task_definition.sidecar-task.arn
    iam_role = var.service_role_arn
    desired_count = 1
    health_check_grace_period_seconds = 180000000

    load_balancer {
        target_group_arn = aws_lb_target_group.sidecar-tg.arn
        container_name = "${var.name}-sidecar"
        container_port = var.sidecar_port
    }
}