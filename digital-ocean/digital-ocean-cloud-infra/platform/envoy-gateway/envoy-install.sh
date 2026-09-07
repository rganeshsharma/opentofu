#!/usr/bin/env bash

set -euo pipefail

echo "Installing Envoy CRD's...."  && \
helm template envoygateway-crds \
  oci://docker.io/envoyproxy/gateway-crds-helm \
  --version v1.8.3 \
  --set 'crds.gatewayAPI.enabled=false' \
  --set 'crds.envoyGateway.enabled=true' \
  | grep -v '^Pulled:' \
  | grep -v '^Digest:' \
  | kubectl apply --server-side -f -

echo "Verify Envoy CRD's Installation..." && kubectl get crd | grep gateway.envoyproxy.io

echo "Create envoy NS..." && \
kubectl create namespace envoy-gateway-system \
  --dry-run=client \
  -o yaml | kubectl apply -f -

echo "Add and verify Labels...."  && \
kubectl label namespace envoy-gateway-system \
  app.kubernetes.io/part-of=envoy-gateway \
  --overwrite && \
kubectl get ns envoy-gateway-system --show-labels

echo "Install Envoy Gateway..." && \
helm upgrade --install envoy-gateway \
  oci://docker.io/envoyproxy/gateway-helm \
  --version v1.8.3 \
  --namespace envoy-gateway-system \
  --set crds.enabled=false \
  -f envoy-gateway-values.yaml

echo "Verify:" && kubectl get pods -n envoy-gateway-system -o wide

echo "Check if Listerner is up:" && \
kubectl logs \
  -n envoy-gateway-system \
  deployment/envoy-gateway \
  --tail=100

echo "Install Envoy Gateway Class....." && \
kubectl apply -f gatewayclass.yaml
kubectl get gatewayclass -A

