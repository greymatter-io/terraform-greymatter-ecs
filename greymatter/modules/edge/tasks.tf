
# edge ecs task definition
resource "aws_ecs_task_definition" "edge-task" {
  family                   = "edge"
  container_definitions    = local.sidecar_container
  requires_compatibilities = ["EC2"]
  network_mode             = "awsvpc"
  cpu                      = "128"
  memory                   = "128"
  execution_role_arn       = var.execution_role_arn
  task_role_arn            = var.execution_role_arn
}

# edge container definitions
locals {
  sidecar_container = <<DEFINITION
[
        {
        "memoryReservation": 128,
        "name": "edge",
        "logConfiguration": {
            "logDriver": "awslogs",
            "options": {
                "awslogs-group": "greymatter",
                "awslogs-region": "${var.aws_region}",
                "awslogs-stream-prefix": "edge"
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
                "value": "edge"
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
            "containerPort": ${var.sidecar_port},
            "protocol": "tcp",
            "hostPort": ${var.sidecar_port}
                }
        ]
      }
]
    DEFINITION
}
