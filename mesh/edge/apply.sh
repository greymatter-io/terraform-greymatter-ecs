#!/bin/bash

for cl in kubernetes/manifests/edge/mesh/domain/*.json; do greymatter create domain < $cl; done
for cl in kubernetes/manifests/edge/mesh/listener/*.json; do greymatter create listener < $cl; done
for cl in kubernetes/manifests/edge/mesh/proxy/*.json; do greymatter create proxy < $cl; done