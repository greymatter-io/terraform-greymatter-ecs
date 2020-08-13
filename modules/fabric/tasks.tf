
# task definitions

locals {
  control_container =  <<DEFINITION
  [
    {
	"memoryReservation": 400,
    "name": "control",
    "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
            "awslogs-group": "openjobs",
            "awslogs-region": "us-east-2",
            "awslogs-stream-prefix": "control"
        }
    },
    "secrets": [
        {
            "name": "GM_CONTROL_ECS_AWS_ACCESS_KEY_ID",
            "valueFrom": "arn:aws:ssm:us-east-2:090224759624:parameter/access_key"
        },
        {
            "name": "GM_CONTROL_ECS_AWS_SECRET_ACCESS_KEY",
            "valueFrom": "arn:aws:ssm:us-east-2:090224759624:parameter/secret_access_key"
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
	    "credentialsParameter": "arn:aws:secretsmanager:us-east-2:090224759624:secret:docker-gm-nexus-rwdgiA"
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

resource "aws_ecs_task_definition" "control-api" {
  family                   = "control-api"
  container_definitions    = file("${path.module}/control-api-task.json")
  requires_compatibilities = ["EC2"]
  network_mode             = "host"
  cpu                      = "256"
  memory                   = "800"
  execution_role_arn       = var.ecs_execution_role_arn
  task_role_arn            = var.ecs_execution_role_arn
}

resource "aws_ecs_task_definition" "control" {
  family                   = "control"
  container_definitions    = local.control_container
  requires_compatibilities = ["EC2"]
  network_mode             = "host"
  cpu                      = "256"
  memory                   = "400"
  execution_role_arn       = var.ecs_execution_role_arn
  task_role_arn            = var.ecs_execution_role_arn
  depends_on               = [aws_lb.control-api]
}

resource "aws_ecs_task_definition" "control-api-sidecar" {
  family                   = "control-api-sidecar"
  container_definitions    = file("${path.module}/sidecar-task.json")
  requires_compatibilities = ["EC2"]
  network_mode             = "host"
  cpu                      = "256"
  memory                   = "400"
  execution_role_arn       = var.ecs_execution_role_arn
  task_role_arn            = var.ecs_execution_role_arn
  depends_on               = [aws_lb.control]
}