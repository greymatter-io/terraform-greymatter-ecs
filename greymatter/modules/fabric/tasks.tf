
# task definitions

resource "aws_ecs_task_definition" "control-api" {
  family                   = "control-api"
  container_definitions    = local.control_api_container
  requires_compatibilities = ["EC2"]
  network_mode             = "awsvpc"
  cpu                      = "512"
  memory                   = "512"
  execution_role_arn       = var.execution_role_arn
  task_role_arn            = var.execution_role_arn
}

resource "aws_ecs_task_definition" "control" {
  family                   = "control"
  container_definitions    = local.control_container
  requires_compatibilities = ["EC2"]
  network_mode             = "awsvpc"
  cpu                      = "128"
  memory                   = "128"
  execution_role_arn       = var.execution_role_arn
  task_role_arn            = var.execution_role_arn
}

# task defs with variables defined here:


locals {

  control_api_container = <<DEFINITION
[
    {
        "memoryReservation": 128,
        "logConfiguration": {
            "logDriver": "awslogs",
            "options": {
                "awslogs-group": "greymatter",
                "awslogs-region": "${var.aws_region}",
                "awslogs-stream-prefix": "control-api"
            }
        },
        "name": "control-api",
        "essential": true,
        "entryPoint": [
        "sh",
        "-c",
        "set -ueo pipefail; mkdir /control-plane/certificates; echo ${base64encode(file("./gm/certs/control-api/ca.crt"))} | base64 -d > /control-plane/certificates/ca.crt; echo ${base64encode(file("./gm/certs/control-api/cert.crt"))} | base64 -d > /control-plane/certificates/server.crt; echo ${base64encode(file("./gm/certs/control-api/key.crt"))} | base64 -d > /control-plane/certificates/server.key; echo ${base64encode(file("${path.module}/mesh/backup.json"))} | base64 -d > /control-plane/gm_control_api_backend.json; ./gm-control-api"
        ],
        "environment": [
            {
                "name": "GM_CONTROL_API_USE_TLS",
                "value": "true"
            },
            {
                "name": "GM_CONTROL_API_LOG_LEVEL",
                "value": "debug"
            },
            {
                "name": "GM_CONTROL_API_ADDRESS",
                "value": "0.0.0.0:5555"
            },
            {
                "name": "GM_CONTROL_API_ORG_KEY",
                "value": "deciphernow"
            },
            {
                "name": "GM_CONTROL_API_ZONE_KEY",
                "value": "zone-default-zone"
            },
            {
                "name": "GM_CONTROL_API_ZONE_NAME",
                "value": "zone-default-zone"
            },
            {
                "name": "GM_CONTROL_API_SERVER_CERT_PATH",
                "value": "/control-plane/certificates/server.crt"
            },
            {
                "name": "GM_CONTROL_API_SERVER_KEY_PATH",
                "value": "/control-plane/certificates/server.key"
            },
            {
                "name": "GM_CONTROL_API_CA_CERT_PATH",
                "value": "/control-plane/certificates/ca.crt"
            },
            {
                "name": "GM_CONTROL_API_PERSISTER_PATH",
                "value": "/control-plane/gm_control_api_backend.json"
            },
            {
                "name": "GM_CONTROL_API_PERSISTER_TYPE",
                "value": "file"
            }
        ],
        "image": "docker.greymatter.io/development/gm-control-api:${lookup(var.versions, "gm-control-api", "1.5.0")}",
        "repositoryCredentials": {
            "credentialsParameter": "${var.docker_secret_arn}"
        },
        "portMappings": [
            {
            "hostPort": 5555,
            "containerPort": 5555,
            "protocol": "tcp"
            }
        ]
    },
    {
        "memoryReservation": 128,
        "name": "control-api-sidecar",
        "logConfiguration": {
            "logDriver": "awslogs",
            "options": {
                "awslogs-group": "greymatter",
                "awslogs-region": "${var.aws_region}",
                "awslogs-stream-prefix": "control-api-sidecar"
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
                "value": "control-api"
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
        "dockerLabels": { "gm-cluster": "control-api:10808" }
      }
]
  DEFINITION

  control_container = <<DEFINITION
  [
    {
	"memoryReservation": 128,
    "name": "control",
    "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
            "awslogs-group": "greymatter",
            "awslogs-region": "${var.aws_region}",
            "awslogs-stream-prefix": "control"
        }
    },
    "entryPoint": [
    "sh",
    "-c",
    "set -ueo pipefail; mkdir /gm-control/certificates; echo ${base64encode(file("./gm/certs/control/cert.crt"))} | base64 -d > /gm-control/certificates/server.crt; echo ${base64encode(file("./gm/certs/control/key.crt"))} | base64 -d > /gm-control/certificates/server.key; /usr/local/bin/gm-control.sh"
    ],
    "secrets": [
        {
            "name": "GM_CONTROL_ECS_AWS_ACCESS_KEY_ID",
            "valueFrom": "${var.access_key_arn}"
        },
        {
            "name": "GM_CONTROL_ECS_AWS_SECRET_ACCESS_KEY",
            "valueFrom": "${var.secret_access_key_arn}"
        }
    ],
	"environment": [
        {
            "name": "GM_CONTROL_CONSOLE_LEVEL",
            "value": "debug"
        },
        {
            "name": "GM_CONTROL_API_KEY",
            "value": "xxx"
        },
        {
            "name": "GM_CONTROL_API_ZONE_NAME",
            "value": "zone-default-zone"
        },
        {
            "name": "GM_CONTROL_API_INSECURE",
            "value": "true"
        },
        {
            "name": "GM_CONTROL_API_SSL",
            "value": "true"
        },
        {
            "name": "GM_CONTROL_API_SSLCERT",
            "value": "/gm-control/certificates/server.crt"
        },
        {
            "name": "GM_CONTROL_API_SSLKEY",
            "value": "/gm-control/certificates/server.key"
        },
        {
            "name": "GM_CONTROL_CMD",
            "value": "ecs"
        },
        {
            "name": "GM_CONTROL_API_HOST",
            "value": "control-api.fabric.${var.dns_ns_name}:5555"
        },
        {
            "name": "GM_CONTROL_ECS_AWS_REGION",
            "value": "${var.aws_region}"
        },
        {
            "name": "GM_CONTROL_ECS_CLUSTERS",
            "value": "${var.cluster_name}"
        },
        {
            "name": "GM_CONTROL_XDS_RESOLVE_DNS",
            "value": "true"
        },
        {
            "name": "GM_CONTROL_XDS_ENABLE_REST",
            "value": "true"
        }
	],
	"image": "docker.greymatter.io/development/gm-control:${lookup(var.versions, "gm-control", "1.5.0")}",
	"repositoryCredentials": {
	    "credentialsParameter": "${var.docker_secret_arn}"
	},
	"portMappings": [
            {
        "hostPort": 50001,
		"containerPort": 50001,
		"protocol": "tcp"
            }
	]
    }
]
    DEFINITION
}
