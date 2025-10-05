#!/usr/bin/env bash
set -euo pipefail

set -x

cd "$(dirname "$0")"

NAMESPACE="cert-manager"
RELEASE="cert-manager"
CHART="oci://quay.io/jetstack/charts/cert-manager"
VERSION="v1.18.2"

echo "Installing cert-manager in namespace ${NAMESPACE}"
kubectl get ns "${NAMESPACE}" >/dev/null 2>&1 || kubectl create ns "${NAMESPACE}"

echo "Installing ${RELEASE} version ${VERSION} from ${CHART}"
helm install "${RELEASE}" "${CHART}" \
  --namespace "${NAMESPACE}" \
  --version "${VERSION}" \
  -f values.yaml

echo "Waiting for cert-manager to be ready..."
kubectl -n "${NAMESPACE}" rollout status deploy/cert-manager --timeout=180s
kubectl -n "${NAMESPACE}" rollout status deploy/cert-manager-webhook --timeout=180s
kubectl -n "${NAMESPACE}" rollout status deploy/cert-manager-cainjector --timeout=180s

echo "cert-manager installation completed."