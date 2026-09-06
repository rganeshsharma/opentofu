#!/usr/bin/env bash

echo "Create and Install Cert-Manager......" && \
kubectl create namespace cert-manager \
  --dry-run=client \
  -o yaml \
  | kubectl apply -f -

kubectl create secret generic digitalocean-dns \
  --namespace cert-manager \
  --from-literal=access-token="${DIGITALOCEAN_TOKEN}"



helm install \
  cert-manager oci://quay.io/jetstack/charts/cert-manager \
  --version v1.21.1 \
  --namespace cert-manager \
  -f values.yml