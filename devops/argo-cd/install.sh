#!/usr/bin/env bash
set -euo pipefail
set -x
cd "$(dirname "$0")"

if ! kubectl get clusterissuer letsencrypt-prod >/dev/null 2>&1; then
  echo "ERROR: ClusterIssuer 'letsencrypt-prod' not found. Create it before running this script." >&2
  exit 1
fi

# Add/update Argo Helm repo
helm repo add argo https://argoproj.github.io/argo-helm
helm repo update

# Create namespace
kubectl get ns argocd >/dev/null 2>&1 || kubectl create ns argocd

# Install/upgrade Argo CD
helm upgrade --install argocd argo/argo-cd \
  --namespace argocd \
  --values ./values.yaml 
# Quick checks
kubectl -n argocd get deploy,sts,pods,svc
kubectl -n argocd get ingress
kubectl -n argocd get pvc
