#!/bin/sh

# control-api sidecar
greymatter create domain < gm/mesh/control-api/domain/domain.api.json
greymatter create listener < gm/mesh/control-api/listener/listener.api.json
greymatter create proxy < gm/mesh/control-api/proxy/proxy.api.json

# links control-api sidecar to existing control-api-service cluster
greymatter create route < gm/mesh/control-api/route/route.api.json

# new edge cluster to control-api
greymatter create cluster < gm/mesh/control-api/cluster/edge.api.cluster.json
greymatter create route < gm/mesh/control-api/route/edge.api.route.json
greymatter create route < gm/mesh/control-api/route/edge.api.route2.json

# delete initial connection from edge directly to control-api
greymatter delete route edge-control-api-init
greymatter delete route edge-control-api-init-2


# dashboard sidecar
greymatter create domain < gm/mesh/dashboard/domain/domain.json
greymatter create listener < gm/mesh/dashboard/listener/listener.json
greymatter create proxy < gm/mesh/dashboard/proxy/proxy.json

# links dashboard sidecar to existing dashboard-service cluster
greymatter create route < gm/mesh/dashboard/route/local-route.json

# new edge cluster to dashboard
greymatter create cluster < gm/mesh/dashboard/cluster/local-cluster.json
greymatter create cluster < gm/mesh/dashboard/cluster/edge-cluster.json
greymatter create route < gm/mesh/dashboard/route/edge-route.json
greymatter create route < gm/mesh/dashboard/route/edge-route2.json
