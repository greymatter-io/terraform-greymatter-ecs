# Terraform

If you're working on this tf code, the basic structure is described here.

## Main

Anything created in the `main.tf` of the root directory is a VPC setup with public and private subnets.

## Greymatter module

The [`greymatter` module](./../greymatter/main.tf) runs all of the internal modules to install Grey Matter:

### Infrastructure

The infrastructure module brings up the ECS cluster itself, as well as any necessary AWS roles to be re-used by ECS tasks, services, etc. and aws and docker secret credentials.

### Fabric

The fabric module creates ECS services for control and control-api. Control is run with REST enabled, and a private route53 domain is created at `fabric.${var.dns_ns_name}` where other services within the VPC can connect to both control and control-api at `control.fabric.${var.dns_ns_name}:50001` and `control-api.fabric.${var.dns_ns_name}:5555` respectively.

Control-api is bootstrapped with mesh configs found in [this file](../greymatter/modules/fabric/mesh/backup.json) - which creates a route from edge -> control-api at startup. Once the mesh comes up, this route should be replaced by mesh configs routeing from edge -> control-api-sidecar -> control-api.

### Edge

The edge module creates an ECS service for edge as well as a load balancer for ingress.

### Sidecar

The sidecar module is a reusable module that creates a sidecar for the service specified with variable `name`. Its ECS task definition specifies `dockerLabels`, with key `gm-cluster` and value `${var.name}:${var.sidecar_port}` so that it's instances will be discovered by gm-control.