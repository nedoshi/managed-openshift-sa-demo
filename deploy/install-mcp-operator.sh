#!/usr/bin/env bash
#
# Install the MCP Lifecycle Operator and deploy the OpenShift MCP server.
# Uses kubernetes-sigs/mcp-lifecycle-operator (Red Hat OpenShift MCP server operator).
#
set -euo pipefail

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

OPERATOR_INSTALL_URL="${OPERATOR_INSTALL_URL:-https://github.com/kubernetes-sigs/mcp-lifecycle-operator/releases/latest/download/install.yaml}"
MCP_NAMESPACE="${MCP_NAMESPACE:-openshift-mcp-server}"

echo -e "${BLUE}════════════════════════════════════════════════${NC}"
echo -e "${BLUE}  Install OpenShift MCP Server (via Operator)${NC}"
echo -e "${BLUE}════════════════════════════════════════════════${NC}"
echo ""

if ! command -v oc &>/dev/null; then
  echo -e "${RED}✗ Error: 'oc' CLI not found${NC}"
  exit 1
fi

if ! oc whoami &>/dev/null; then
  echo -e "${RED}✗ Error: Not logged into OpenShift cluster${NC}"
  echo "  Run: oc login <your-cluster-url>"
  exit 1
fi

echo -e "${GREEN}✓${NC} Connected to: $(oc whoami --show-server)"
echo ""

# Step 1: Install operator if not present
echo -e "${YELLOW}[1/4]${NC} Installing MCP Lifecycle Operator..."
if oc get crd mcpservers.mcp.x-k8s.io &>/dev/null; then
  echo -e "${GREEN}✓${NC} MCP Lifecycle Operator CRD already installed"
else
  echo "  Applying operator manifest from ${OPERATOR_INSTALL_URL}"
  oc apply -f "$OPERATOR_INSTALL_URL"
  echo -e "${GREEN}✓${NC} Operator installed"
fi
echo ""

# Step 2: Wait for operator pod
echo -e "${YELLOW}[2/4]${NC} Waiting for operator to be ready..."
oc wait --for=condition=Available deployment/mcp-lifecycle-operator-controller-manager \
  -n mcp-lifecycle-operator-system --timeout=180s 2>/dev/null \
  || echo -e "${YELLOW}!${NC} Operator pod still starting (continuing...)"
echo ""

# Step 3: Create namespace and MCPServer CR
echo -e "${YELLOW}[3/4]${NC} Deploying Kubernetes MCP Server..."
oc apply -f 00-openshift-mcp-server-namespace.yaml
oc apply -f mcp-server-openshift.yaml
echo -e "${GREEN}✓${NC} MCPServer resource applied"
echo ""

# Step 4: Wait for MCP server pod
echo -e "${YELLOW}[4/4]${NC} Waiting for MCP server pod..."
for i in $(seq 1 24); do
  READY=$(oc get pods -n "$MCP_NAMESPACE" -l app.kubernetes.io/name=kubernetes-mcp-server \
    -o jsonpath='{.items[0].status.conditions[?(@.type=="Ready")].status}' 2>/dev/null || true)
  if [ "$READY" = "True" ]; then
    echo -e "${GREEN}✓${NC} MCP server pod is ready"
    break
  fi
  # Fallback: any Running pod in namespace
  RUNNING=$(oc get pods -n "$MCP_NAMESPACE" --field-selector=status.phase=Running -o name 2>/dev/null | head -1)
  if [ -n "$RUNNING" ] && [ "$i" -ge 12 ]; then
    echo -e "${GREEN}✓${NC} MCP server pod running: ${RUNNING}"
    break
  fi
  sleep 5
done

echo ""
echo -e "${GREEN}════════════════════════════════════════════════${NC}"
echo -e "${GREEN}  MCP Server Ready${NC}"
echo -e "${GREEN}════════════════════════════════════════════════${NC}"
echo ""
echo -e "${BLUE}In-cluster URL (for n8n workflows):${NC}"
echo "  http://kubernetes-mcp-server.${MCP_NAMESPACE}.svc.cluster.local:8080/sse"
echo ""
echo -e "${BLUE}Verify:${NC}"
echo "  oc get mcpserver -n ${MCP_NAMESPACE}"
echo "  oc get pods -n ${MCP_NAMESPACE}"
echo "  oc get svc -n ${MCP_NAMESPACE}"
echo ""
