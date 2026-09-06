#!/usr/bin/env bash

set -euo pipefail

echo "Deploying gateway API CRDS..."
kubectl apply --server-side \
  -f https://github.com/kubernetes-sigs/gateway-api/releases/download/v1.5.1/standard-install.yaml

echo "Verify CRDs:"
kubectl get crd | grep gateway.networking.k8s.io

echo "Verify Bundle version and channel from which Gateway API downloaded:"
kubectl get crd gateways.gateway.networking.k8s.io \
  -o go-template='version={{ index .metadata.annotations "gateway.networking.k8s.io/bundle-version" }} channel={{ index .metadata.annotations "gateway.networking.k8s.io/channel" }}{{ "\n" }}'

