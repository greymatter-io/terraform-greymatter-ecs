
# task definitions

resource "aws_ecs_task_definition" "control-api" {
  family                   = "control-api"
  container_definitions    = local.control_api_container
  requires_compatibilities = ["EC2"]
  network_mode             = "bridge"
  cpu                      = "128"
  memory                   = "128"
  execution_role_arn       = var.ecs_execution_role_arn
  task_role_arn            = var.ecs_execution_role_arn
}

resource "aws_ecs_task_definition" "control" {
  family                   = "control"
  container_definitions    = local.control_container
  requires_compatibilities = ["EC2"]
  network_mode             = "bridge"
  cpu                      = "128"
  memory                   = "128"
  execution_role_arn       = var.ecs_execution_role_arn
  task_role_arn            = var.ecs_execution_role_arn
  depends_on               = [aws_lb.control-api]
}

resource "aws_ecs_task_definition" "control-api-sidecar" {
  family                   = "control-api-sidecar"
  container_definitions    = local.sidecar_container
  requires_compatibilities = ["EC2"]
  network_mode             = "bridge"
  cpu                      = "128"
  memory                   = "128"
  execution_role_arn       = var.ecs_execution_role_arn
  task_role_arn            = var.ecs_execution_role_arn
  depends_on               = [aws_lb.control]
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
                "awslogs-group": "openjobs",
                "awslogs-region": "us-east-2",
                "awslogs-stream-prefix": "api"
            }
        },
        "name": "control-api",
        "essential": true,
        "environment": [
            {
                "name": "GM_CONTROL_API_USE_TLS",
                "value": "false"
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
            "containerPort": 5555,
            "protocol": "tcp",
            "hostPort": 5555
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
            "awslogs-group": "openjobs",
            "awslogs-region": "us-east-2",
            "awslogs-stream-prefix": "control"
        }
    },
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
            "value": "false"
        },
        {
            "name": "GM_CONTROL_CMD",
            "value": "ecs"
        },
        {
            "name": "GM_CONTROL_API_HOST",
            "value": "${aws_lb.control-api.dns_name}:5555"
        },
        {
            "name": "GM_CONTROL_ECS_AWS_REGION",
            "value": "us-east-2"
        },
        {
            "name": "GM_CONTROL_ECS_CLUSTERS",
            "value": "gm-cluster"
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

  sidecar_container = <<DEFINITION
[
        {
        "memoryReservation": 128,
        "name": "control-api-sidecar",
        "logConfiguration": {
            "logDriver": "awslogs",
            "options": {
                "awslogs-group": "openjobs",
                "awslogs-region": "us-east-2",
                "awslogs-stream-prefix": "sidecar"
            }
        },
        "environment": [
            {
                "name": "PROXY_REST_DYNAMIC",
                "value": "true"
            },
            {
                "name": "XDS_CLUSTER",
                "value": "proxy"
            },
            {
                "name": "XDS_HOST",
                "value": "${aws_lb.control.dns_name}"
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
        "image": "docker.greymatter.io/development/gm-proxy:latest",
        "repositoryCredentials": {
            "credentialsParameter": "${var.docker_secret_arn}"
        },
        "portMappings": [
                {
            "hostPort": 10808,
            "containerPort": 10808,
            "protocol": "tcp"
                }
        ],
        "dockerLabels": { "gm-cluster": "control-api:10808" }
      }
]
    DEFINITION

}
