#!/usr/bin/env bash
set -euo pipefail

set -x

cd "$(dirname "$0")"

helm repo add open-telemetry https://open-telemetry.github.io/opentelemetry-helm-charts
helm repo update


echo "Create the operator namespace"
kubectl get ns opentelemetry-operator-system >/dev/null 2>&1 || kubectl create namespace opentelemetry-operator-system


helm upgrade --install opentelemetry-operator open-telemetry/opentelemetry-operator \
  --namespace opentelemetry-operator-system \
  --create-namespace \
  -f values.yaml
