#!/bin/sh

export GREYMATTER_API_HOST=edge-1988872944.us-east-2.elb.amazonaws.com:10808
export GREYMATTER_API_INSECURE=true
export GREYMATTER_API_PREFIX=/control-api
export GREYMATTER_API_SSL=false
export GREYMATTER_CONSOLE_LEVEL=debug

# control-api sidecar
greymatter create domain < mesh/control-api/domain/domain.api.json
greymatter create listener < mesh/control-api/listener/listener.api.json
greymatter create proxy < mesh/control-api/proxy/proxy.api.json

# links control-api sidecar to existing control-api-service cluster
greymatter create route < mesh/control-api/route/route.api.json

# new edge cluster to control-api
greymatter create cluster < mesh/control-api/cluster/edge.api.cluster.json
greymatter create route < mesh/control-api/route/edge.api.route.json
greymatter create route < mesh/control-api/route/edge.api.route2.json

# delete initial connection from edge directly to control-api
greymatter delete route edge-control-api-init
greymatter delete route edge-control-api-init-2

