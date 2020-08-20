
# task definitions

resource "aws_ecs_task_definition" "sidecar-task" {
  family                   = "${var.name}-sidecar"
  container_definitions    = local.sidecar_container
  requires_compatibilities = ["EC2"]
  network_mode             = "bridge"
  cpu                      = "128"
  memory                   = "128"
  execution_role_arn       = var.ecs_execution_role_arn
  task_role_arn            = var.ecs_execution_role_arn
}

# task defs with variables defined here:


locals {
  sidecar_container = <<DEFINITION
[
        {
        "memoryReservation": 128,
        "name": "${var.name}-sidecar",
        "logConfiguration": {
            "logDriver": "awslogs",
            "options": {
                "awslogs-group": "openjobs",
                "awslogs-region": "us-east-2",
                "awslogs-stream-prefix": "${var.name}-sidecar"
            }
        },
        "environment": [
            {
                "name": "PROXY_REST_DYNAMIC",
                "value": "true"
            },
            {
                "name": "XDS_CLUSTER",
                "value": "${var.name}"
            },
            {
                "name": "XDS_HOST",
                "value": "${var.control_dns}"
            },
            {
                "name": "XDS_PORT",
                "value": "${var.control_port}"
            },
            {
                "name": "XDS_ZONE",
                "value": "zone-default-zone"
            },
            {
                "name": "XDS_NODE_ID",
                "value": "default"
            }
        ],
        "image": "docker.greymatter.io/development/gm-proxy:latest",
        "repositoryCredentials": {
            "credentialsParameter": "${var.docker_secret_arn}"
        },
        "portMappings": [
                {
            "containerPort": ${var.sidecar_port},
            "protocol": "tcp"
                }
        ],
        "dockerLabels": { "gm-cluster": "${var.name}:${var.sidecar_port}" }
      }
]
    DEFINITION

}
