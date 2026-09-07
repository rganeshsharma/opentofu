#!/usr/bin/env bash

set -euo pipefail

: "${DIGITALOCEAN_TOKEN:?DIGITALOCEAN_TOKEN is not set}"

echo "Create and Install Cert-Manager......" && \
kubectl create namespace cert-manager \
  --dry-run=client \
  -o yaml \
  | kubectl apply -f -

kubectl create secret generic digitalocean-dns \
  --namespace cert-manager \
  --from-literal=access-token="${DIGITALOCEAN_TOKEN}" \
  --dry-run=client \
  -o yaml | kubectl apply -f -

helm upgrade --install \
  cert-manager oci://quay.io/jetstack/charts/cert-manager \
  --version v1.21.1 \
  --set crds.enabled=true \
  --namespace cert-manager \
  -f values.yml