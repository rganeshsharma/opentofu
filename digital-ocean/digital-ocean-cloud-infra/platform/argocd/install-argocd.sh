#!/usr/bin/env bash

set -euo pipefail



echo "Add Helm Repo for Argo CD...." && helm repo add argo https://argoproj.github.io/argo-helm --force-update && \
helm repo update

echo "Create and Install ArgoCD......" && \
kubectl create namespace argocd \
  --dry-run=client \
  -o yaml \
  | kubectl apply -f -

echo "Install Argo CD...." && helm upgrade --install argocd argo/argo-cd \
  --namespace argocd \
  --create-namespace \
  --version 10.8.1 \
  -f values.yml \
    --wait \
  --timeout 10m

echo "Verify ArgoCD...." && kubectl get pods -n argocd && kubectl get svc -n argocd