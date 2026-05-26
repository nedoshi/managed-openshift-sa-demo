#!/usr/bin/env bash
#
# Apply n8n deployment with OpenShift-compatible fsGroup for the PVC.
#
set -euo pipefail

NAMESPACE="${NAMESPACE:-n8n}"
DEPLOYMENT_FILE="${DEPLOYMENT_FILE:-04-deployment.yaml}"

if ! oc whoami &>/dev/null; then
  echo "Error: not logged into OpenShift. Run: oc login <cluster-url>"
  exit 1
fi

oc apply -f "$DEPLOYMENT_FILE"

FS_GROUP=$(oc get ns "$NAMESPACE" -o jsonpath='{.metadata.annotations.openshift\.io/sa\.scc\.supplemental-groups}' 2>/dev/null | cut -d/ -f1)

if [ -n "$FS_GROUP" ]; then
  echo "Patching deployment with fsGroup=${FS_GROUP}"
  oc patch deployment n8n -n "$NAMESPACE" --type=json \
    -p="[{\"op\":\"add\",\"path\":\"/spec/template/spec/securityContext/fsGroup\",\"value\":${FS_GROUP}}]" \
    2>/dev/null \
    || oc patch deployment n8n -n "$NAMESPACE" --type=json \
    -p="[{\"op\":\"replace\",\"path\":\"/spec/template/spec/securityContext/fsGroup\",\"value\":${FS_GROUP}}]"
else
  echo "Warning: could not read supplemental group for namespace ${NAMESPACE}."
fi
