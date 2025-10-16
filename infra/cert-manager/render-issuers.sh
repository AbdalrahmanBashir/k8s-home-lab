#!/usr/bin/env bash
set -euo pipefail
set -x

: "${ACME_EMAIL:?Set ACME_EMAIL env var, e.g. export ACME_EMAIL='test@test.com'}"

dir="$(cd "$(dirname "$0")" && pwd)"

envsubst < "${dir}/cluster-issuer-prod.tmpl.yaml" > "${dir}/cluster-issuer-prod.yaml"

echo "Rendered:"
ls -1 "${dir}/"*issuer*.yaml