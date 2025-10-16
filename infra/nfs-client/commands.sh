#!/usr/bin/env bash
set -euo pipefail

# echo commands as they run
set -x

cd "$(dirname "$0")"

# Add/refresh chart repo
helm repo add nfs-subdir-external-provisioner https://kubernetes-sigs.github.io/nfs-subdir-external-provisioner/
helm repo update

# Namespace for the provisioner
kubectl get ns storage >/dev/null 2>&1 || kubectl create ns storage

# Install/upgrade the provisioner with values
helm upgrade --install nfs-client nfs-subdir-external-provisioner/nfs-subdir-external-provisioner \
  --namespace storage \
  --values ./values.yaml

# Quick checks
kubectl -n storage get deploy,po
kubectl get storageclass
