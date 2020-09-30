# Terraform

If you're working on this tf code, the basic structure is described here.

## Main

Anything created in the `main.tf` of the root directory is a VPC setup with public and private subnets.

## Greymatter module

The [`greymatter` module](./../greymatter/main.tf) runs all of the internal modules to install Grey Matter:

### Infrastructure

The infrastructure module brings up the ECS cluster itself, as well as any necessary AWS roles to be re-used by ECS tasks, services, etc. and aws and docker secret credentials.

### Fabric

The fabric module creates ECS services for gm-control and gm-control-api. Grey Matter Control is run with REST enabled, and a private route53 domain is created at `fabric.${var.dns_ns_name}` where other services within the VPC can connect to both gm-control and gm-control-api at `control.fabric.${var.dns_ns_name}:50001` and `control-api.fabric.${var.dns_ns_name}:5555` respectively.

Grey Matter Control Api is bootstrapped with mesh configs found in [this file](../greymatter/modules/fabric/mesh/backup.json) - which creates a route from edge -> gm-control-api at startup. Once the mesh comes up, this route should be replaced by mesh configs routeing from edge -> gm-control-api-sidecar -> gm-control-api.

### Edge

The edge module creates an ECS service for the edge proxy as well as a load balancer for ingress. The edge is a standalone sidecar and will serve as the ingress proxy for all traffic from the outside world into the mesh.

The edge load balancer uses the certificates from `gm/certs/edge` directory for ingress.  It uses the certificates located in the `gm/certs/sidecar` directory for its egress to other services within the mesh.

### Sidecar

The sidecar module is a reusable module that creates a sidecar for the service specified with variable `name`. Its ECS task definition specifies `dockerLabels`, with key `gm-cluster` and value `${var.name}:${var.sidecar_port}` so that it's instances will be discovered by gm-control.

### TLS

TLS is set for ingress into the edge load balancer in `greymatter/modules/edge/load_balancer.tf`.  For service to service tls, docker volumes are mounted directly into each ecs task container definition from the `gm/certs` directory.  To see how this is done check the `entryPoint` for any of the gm ecs task container defs.
