
# task definitions

resource "aws_ecs_task_definition" "control-api" {
  family                   = "control-api"
  container_definitions    = local.control_api_container
  requires_compatibilities = ["EC2"]
  network_mode             = "awsvpc"
  cpu                      = "128"
  memory                   = "128"
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
        "set -ueo pipefail; mkdir /control-plane/certificates; echo ${base64encode(file("./certs/control-api/ca.crt"))} | base64 -d > /control-plane/certificates/ca.crt; echo ${base64encode(file("./certs/control-api/cert.crt"))} | base64 -d > /control-plane/certificates/server.crt; echo ${base64encode(file("./certs/control-api/key.crt"))} | base64 -d > /control-plane/certificates/server.key; ./gm-control-api"
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
                "name": "GM_CONTROL_API_PERSISTER_TYPE",
                "value": "file"
            }
        ],
        "image": "docker.greymatter.io/development/gm-control-api:latest",
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
    "set -ueo pipefail; mkdir /gm-control/certificates; echo ${base64encode(file("./certs/control/cert.crt"))} | base64 -d > /gm-control/certificates/server.crt; echo ${base64encode(file("./certs/control/key.crt"))} | base64 -d > /gm-control/certificates/server.key; /usr/local/bin/gm-control.sh"
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
            "value": "control-api.${var.dns_ns_name}:5555"
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
            "value": "false"
        },
        {
            "name": "GM_CONTROL_XDS_ENABLE_REST",
            "value": "true"
        }
	],
	"image": "docker.greymatter.io/development/gm-control:latest",
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
