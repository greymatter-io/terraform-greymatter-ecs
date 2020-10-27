
# task definitions

resource "aws_ecs_task_definition" "dashboard" {
  family                   = "dashboard"
  container_definitions    = local.dashboard_container
  requires_compatibilities = ["EC2"]
  network_mode             = "awsvpc"
  cpu                      = "128"
  memory                   = "128"
  execution_role_arn       = var.execution_role_arn
  task_role_arn            = var.execution_role_arn
}

locals {

  dashboard_container = <<DEFINITION
[
    {
        "memoryReservation": 128,
        "logConfiguration": {
            "logDriver": "awslogs",
            "options": {
                "awslogs-group": "greymatter",
                "awslogs-region": "${var.aws_region}",
                "awslogs-stream-prefix": "dashboard"
            }
        },
        "name": "dashboard",
        "essential": true,
        "entryPoint": [
        "sh",
        "-c",
        "set -ueo pipefail; mkdir /control-plane/certificates; echo ${base64encode(file("./gm/certs/control-api/ca.crt"))} | base64 -d > /control-plane/certificates/ca.crt; echo ${base64encode(file("./gm/certs/control-api/cert.crt"))} | base64 -d > /control-plane/certificates/server.crt; echo ${base64encode(file("./gm/certs/control-api/key.crt"))} | base64 -d > /control-plane/certificates/server.key; echo ${base64encode(file("${path.module}/mesh/backup.json"))} | base64 -d > /control-plane/gm_control_api_backend.json; ./gm-control-api"
        ],
        "environment": [
            {
                "name": "BASE_URL",
                "value": "/"
            },
            {
                "name": "CONFIG_SERVER",
                "value": "/services/control-api/latest/"
            },
            {
                "name": "FABRIC_SERVER",
                "value": "/services/catalog/latest/"
            },
            {
                "name": "OBJECTIVES_SERVER",
                "value": "/services/slo/latest/"
            },
            {
                "name": "PROMETHEUS_SERVER",
                "value": "/services/prometheus/latest/api/v1/"
            },
            {
                "name": "REQUEST_TIMEOUT",
                "value": "15000"
            },
            {
                "name": "USE_PROMETHEUS",
                "value": "false"
            }
        ],
        "image": "docker.greymatter.io/development/gm-dashboard:${lookup(var.versions, "gm-dashboard", "3.4.2")}",
        "repositoryCredentials": {
            "credentialsParameter": "${var.docker_secret_arn}"
        },
        "portMappings": [
            {
            "hostPort": 1337,
            "containerPort": 1337,
            "protocol": "tcp"
            }
        ]
    }
]
  DEFINITION
}