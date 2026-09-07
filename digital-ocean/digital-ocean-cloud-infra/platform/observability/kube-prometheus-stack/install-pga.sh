#!/usr/bin/env bash

set -euo pipefail

: "${GRAFANA_ADMIN_PASSWORD:?GRAFANA_ADMIN_PASSWORD is not set}"

echo "Create and Install kube-prometheus-stack......" && \
kubectl create namespace monitoring \
  --dry-run=client \
  -o yaml \
  | kubectl apply -f -

echo "Create Grafana Creds....." && \
kubectl create secret generic grafana-admin-credentials \
  -n monitoring \
  --from-literal=admin-user=admin \
  --from-literal=admin-password='Ypur-Password'

echo "Verify Secret exists...." && kubectl get secret grafana-admin-credentials -n monitoring

echo "Adding and Installing Prometheus Community Chart...." && \
helm repo add prometheus-community \
  https://prometheus-community.github.io/helm-charts && \

helm repo update && \

helm search repo prometheus-community/kube-prometheus-stack && \
helm upgrade --install kube-prometheus-stack \
  prometheus-community/kube-prometheus-stack \
  --namespace monitoring \
  --version 89.2.2 \
  --values values.yml \
  --wait

echo "Verify Isntallation...." && \
helm list -n monitoring && \
kubectl get pods -n monitoring