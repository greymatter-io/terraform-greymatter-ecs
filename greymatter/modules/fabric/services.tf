

# service definitions

resource "aws_ecs_service" "control-api" {
    name = "control-api"
    cluster = var.cluster_id
    task_definition = aws_ecs_task_definition.control-api.arn
    iam_role = var.service_role_arn
    desired_count = 1
    depends_on      = [aws_lb_target_group.control-api]
    health_check_grace_period_seconds = 180000000

    load_balancer {
        target_group_arn = aws_lb_target_group.control-api.arn
        container_name = "control-api"
        container_port = 5555
    }
}

resource "aws_ecs_service" "control" {
    name = "control"
    cluster = var.cluster_id
    task_definition = aws_ecs_task_definition.control.arn
    iam_role = var.service_role_arn
    desired_count = 1
    depends_on      = [aws_lb_target_group.control]
    health_check_grace_period_seconds = 180000000

    load_balancer {
        target_group_arn = aws_lb_target_group.control.arn
        container_name = "control"
        container_port = 50001
    }
}

resource "aws_ecs_service" "control-api-sidecar" {
    name = "control-api-sidecar"
    cluster = var.cluster_id
    task_definition = aws_ecs_task_definition.control-api-sidecar.arn
    iam_role = var.service_role_arn
    desired_count = 1
    depends_on      = [aws_lb_target_group.control-api]
    health_check_grace_period_seconds = 180000000

    load_balancer {
        target_group_arn = aws_lb_target_group.control-api-sidecar.arn
        container_name = "control-api-sidecar"
        container_port = 10808
    }
}