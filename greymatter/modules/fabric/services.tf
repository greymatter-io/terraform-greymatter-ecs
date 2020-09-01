# service discovery

resource "aws_service_discovery_private_dns_namespace" "greymatter" {
  name        = "greymatter.dev"
  description = "Service discovery namespace for Grey Matter Fabric"
  vpc = var.vpc_id
}

resource "aws_service_discovery_service" "control-api" {
  name = "control-api"
  dns_config {
    namespace_id = aws_service_discovery_private_dns_namespace.greymatter.id
    dns_records {
      ttl  = 10
      type = "A"
    }
    routing_policy = "MULTIVALUE"
  }

  health_check_custom_config {
    failure_threshold = 1
  }
}

resource "aws_service_discovery_service" "control" {
  name = "control"
  dns_config {
    namespace_id = aws_service_discovery_private_dns_namespace.greymatter.id
    dns_records {
      ttl  = 10
      type = "A"
    }
    routing_policy = "MULTIVALUE"
  }

  health_check_custom_config {
    failure_threshold = 1
  }
}


# service definitions

resource "aws_ecs_service" "control-api" {
    name = "control-api"
    cluster = var.cluster_id
    task_definition = aws_ecs_task_definition.control-api.arn
    desired_count = 1
    network_configuration {
      subnets = var.subnets
      security_groups = [aws_security_group.control-api-sg.id]
    }

    service_registries {
        registry_arn = aws_service_discovery_service.control-api.arn
    }

}

resource "aws_ecs_service" "control" {
    name = "control"
    cluster = var.cluster_id
    depends_on = [aws_ecs_service.control-api]
    task_definition = aws_ecs_task_definition.control.arn
    desired_count = 1

    network_configuration {
      subnets = var.subnets
      security_groups = [aws_security_group.control-sg.id]
    }

    service_registries {
        registry_arn = aws_service_discovery_service.control.arn
    }
}