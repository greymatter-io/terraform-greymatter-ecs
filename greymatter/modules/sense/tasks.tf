
# task definitions

resource "aws_ecs_task_definition" "dashboard" {
  family                   = "dashboard"
  container_definitions    = local.dashboard_container
  requires_compatibilities = ["EC2"]
  network_mode             = "awsvpc"
  cpu                      = "512"
  memory                   = "512"
  execution_role_arn       = var.execution_role_arn
  task_role_arn            = var.execution_role_arn
}

resource "aws_ecs_task_definition" "catalog" {
  family                   = "catalog"
  container_definitions    = local.catalog_container
  requires_compatibilities = ["EC2"]
  network_mode             = "awsvpc"
  cpu                      = "512"
  memory                   = "512"
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
    },
{
        "memoryReservation": 128,
        "name": "dashboard-sidecar",
        "logConfiguration": {
            "logDriver": "awslogs",
            "options": {
                "awslogs-group": "greymatter",
                "awslogs-region": "${var.aws_region}",
                "awslogs-stream-prefix": "dashboard-sidecar"
            }
        },
        "entryPoint": [
        "sh",
        "-c",
        "set -ueo pipefail; mkdir /app/certificates; echo ${base64encode(file("./gm/certs/sidecar/ca.crt"))} | base64 -d > /app/certificates/ca.crt; echo ${base64encode(file("./gm/certs/sidecar/cert.crt"))} | base64 -d > /app/certificates/server.crt; echo ${base64encode(file("./gm/certs/sidecar/key.crt"))} | base64 -d > /app/certificates/server.key; ./gm-proxy -c config.yaml"
        ],
        "environment": [
            {
                "name": "PROXY_REST_DYNAMIC",
                "value": "true"
            },
            {
                "name": "XDS_CLUSTER",
                "value": "dashboard"
            },
            {
                "name": "XDS_HOST",
                "value": "control.fabric.${var.dns_ns_name}"
            },
            {
                "name": "XDS_PORT",
                "value": "50001"
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
        "image": "docker.greymatter.io/development/gm-proxy:${lookup(var.versions, "gm-proxy", "1.5.0")}",
        "repositoryCredentials": {
            "credentialsParameter": "${var.docker_secret_arn}"
        },
        "portMappings": [
                {
            "containerPort": 10808,
            "protocol": "tcp"
                }
        ],
        "dockerLabels": { "gm-cluster": "dashboard:10808" }
      }
]
  DEFINITION

  catalog_container = <<DEFINITION
[
    {
        "memoryReservation": 128,
        "logConfiguration": {
            "logDriver": "awslogs",
            "options": {
                "awslogs-group": "greymatter",
                "awslogs-region": "${var.aws_region}",
                "awslogs-stream-prefix": "catalog"
            }
        },
        "name": "catalog",
        "essential": true,
        "environment": [
            {
                "name": "CONFIG_SOURCE",
                "value": "env"
            },
            {
                "name": "CONTROL_SERVER_0_ADDRESS",
                "value": "control.fabric.${var.dns_ns_name}:50001"
            },
            {
                "name": "PORT",
                "value": "9080"
            },
            {
                "name": "INSTANCE_POLLING_INTERVAL",
                "value": "5s"
            },
            {
                "name": "USE_TLS",
                "value": "false"
            },
            {
                "name": "CONTROL_SERVER_0_REQUEST_CLUSTER_NAME",
                "value": "edge"
            },
            {
                "name": "CONTROL_SERVER_0_ZONE_NAME",
                "value": "zone-default-zone"
            },
            {
                "name": "SERVICE_0_CLUSTER_NAME",
                "value": "control-api"
            },
            {
                "name": "SERVICE_0_ZONE_NAME",
                "value": "zone-default-zone"
            },
            {
                "name": "SERVICE_0_NAME",
                "value": "Grey Matter Control API"
            },
            {
                "name": "SERVICE_0_VERSION",
                "value": "1.5.0"
            }
        ],
        "image": "docker.greymatter.io/development/gm-catalog:${lookup(var.versions, "gm-catalog", "1.0.7")}",
        "repositoryCredentials": {
            "credentialsParameter": "${var.docker_secret_arn}"
        },
        "portMappings": [
            {
            "hostPort": 9080,
            "containerPort": 9080,
            "protocol": "tcp"
            }
        ]
    },
    {
        "memoryReservation": 128,
        "name": "catalog-sidecar",
        "logConfiguration": {
            "logDriver": "awslogs",
            "options": {
                "awslogs-group": "greymatter",
                "awslogs-region": "${var.aws_region}",
                "awslogs-stream-prefix": "catalog-sidecar"
            }
        },
        "entryPoint": [
        "sh",
        "-c",
        "set -ueo pipefail; mkdir /app/certificates; echo ${base64encode(file("./gm/certs/sidecar/ca.crt"))} | base64 -d > /app/certificates/ca.crt; echo ${base64encode(file("./gm/certs/sidecar/cert.crt"))} | base64 -d > /app/certificates/server.crt; echo ${base64encode(file("./gm/certs/sidecar/key.crt"))} | base64 -d > /app/certificates/server.key; ./gm-proxy -c config.yaml"
        ],
        "environment": [
            {
                "name": "PROXY_REST_DYNAMIC",
                "value": "true"
            },
            {
                "name": "XDS_CLUSTER",
                "value": "catalog"
            },
            {
                "name": "XDS_HOST",
                "value": "control.fabric.${var.dns_ns_name}"
            },
            {
                "name": "XDS_PORT",
                "value": "50001"
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
        "image": "docker.greymatter.io/development/gm-proxy:${lookup(var.versions, "gm-proxy", "1.5.0")}",
        "repositoryCredentials": {
            "credentialsParameter": "${var.docker_secret_arn}"
        },
        "portMappings": [
                {
            "containerPort": 10808,
            "protocol": "tcp"
                }
        ],
        "dockerLabels": { "gm-cluster": "catalog:10808" }
      }
]
  DEFINITION

}