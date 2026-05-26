#!/usr/bin/env bash
#
# Deploy n8n + OpenShift MCP Server to ROSA HCP or ARO
# Uses MCP Lifecycle Operator for the MCP server (not a standalone Deployment)
#

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

MCP_NAMESPACE="${MCP_NAMESPACE:-openshift-mcp-server}"
MCP_URL="http://kubernetes-mcp-server.${MCP_NAMESPACE}.svc.cluster.local:8080/sse"

echo -e "${BLUE}════════════════════════════════════════════════${NC}"
echo -e "${BLUE}  Deploy Solution Architect Demo to ROSA / ARO${NC}"
echo -e "${BLUE}════════════════════════════════════════════════${NC}"
echo ""

# Check prerequisites
if ! command -v oc &> /dev/null; then
    echo -e "${RED}✗ Error: 'oc' CLI not found${NC}"
    exit 1
fi

if ! oc whoami &> /dev/null; then
    echo -e "${RED}✗ Error: Not logged into OpenShift cluster${NC}"
    echo "  Run: oc login <your-cluster-url>"
    exit 1
fi

CLUSTER_URL=$(oc whoami --show-server)
echo -e "${GREEN}✓${NC} Connected to: ${CLUSTER_URL}"
echo ""

# Step 1: Generate n8n encryption key
echo -e "${YELLOW}[1/6]${NC} Configure n8n secrets"
echo ""

ENCRYPTION_KEY=$(openssl rand -hex 32)
echo -e "${GREEN}✓${NC} Generated n8n encryption key"

cat > secret.yaml <<EOF
---
apiVersion: v1
kind: Secret
metadata:
  name: n8n-secrets
  namespace: n8n
type: Opaque
stringData:
  encryption-key: "${ENCRYPTION_KEY}"
EOF

echo -e "${GREEN}✓${NC} LLM: run ../scripts/setup-ollama-rosa.sh (or configure OpenAI/Vertex in n8n)"
echo ""

# Step 2: Install MCP operator + MCP server
echo -e "${YELLOW}[2/6]${NC} Installing OpenShift MCP Server (via operator)..."
chmod +x install-mcp-operator.sh apply-deployment-openshift.sh
./install-mcp-operator.sh
echo ""

# Step 3: Create n8n namespace
echo -e "${YELLOW}[3/6]${NC} Creating namespace 'n8n'..."
oc apply -f 01-namespace.yaml
echo ""

# Step 4: Apply secrets
echo -e "${YELLOW}[4/6]${NC} Applying secrets..."
oc apply -f secret.yaml
echo -e "${GREEN}✓${NC} Secrets created"
echo ""

# Step 5: Deploy n8n
echo -e "${YELLOW}[5/6]${NC} Deploying n8n..."
oc apply -f 02-pvc.yaml
./apply-deployment-openshift.sh
oc apply -f 05-service.yaml -f 06-route.yaml

echo -e "${GREEN}✓${NC} n8n deployed"
echo ""

# Step 6: Configure n8n webhook URL
echo -e "${YELLOW}[6/6]${NC} Configuring n8n webhook URL..."
sleep 5

N8N_HOST=$(oc get route n8n -n n8n -o jsonpath='{.spec.host}' 2>/dev/null || echo "")
if [ -n "$N8N_HOST" ]; then
    oc set env deployment/n8n -n n8n WEBHOOK_URL="https://${N8N_HOST}/"
    echo -e "${GREEN}✓${NC} Webhook URL configured: https://${N8N_HOST}/"
else
    echo -e "${YELLOW}!${NC} Route not ready yet — set WEBHOOK_URL manually after route is created"
fi
echo ""

# Wait for pods
echo -e "${YELLOW}Waiting for n8n pod...${NC}"
oc wait --for=condition=Ready pod -l app.kubernetes.io/name=n8n -n n8n --timeout=180s 2>/dev/null \
  || echo "n8n pod still starting..."
echo ""

# Summary
echo -e "${GREEN}════════════════════════════════════════════════${NC}"
echo -e "${GREEN}  Deployment Complete!${NC}"
echo -e "${GREEN}════════════════════════════════════════════════${NC}"
echo ""

N8N_URL=$(oc get route n8n -n n8n -o jsonpath='{.spec.host}' 2>/dev/null || echo "pending...")

echo -e "${BLUE}Access URLs:${NC}"
echo "  n8n Web UI:     https://${N8N_URL}"
echo "  MCP Server:     ${MCP_URL}"
echo ""

echo -e "${BLUE}Next Steps:${NC}"
echo "1. Open n8n: https://${N8N_URL}"
echo "2. Create admin account (first time)"
echo "3. Install community package: @n8n/n8n-nodes-langchain"
echo "4. Deploy Ollama: ../scripts/setup-ollama-rosa.sh"
echo "5. Import: ../workflows/03-solution-architect-ollama.json"
echo "6. MCP URL (already in workflow): ${MCP_URL}"
echo "7. Test with: ../demo-scripts/SAMPLE-INPUTS.md"
echo ""

echo -e "${BLUE}Verify:${NC}"
echo "  oc get pods -n n8n"
echo "  oc get pods -n ${MCP_NAMESPACE}"
echo "  oc logs -f deployment/n8n -n n8n"
echo ""

echo -e "${BLUE}Demo Resources:${NC}"
echo "  Quick start:    ../OLLAMA-QUICKSTART.md"
echo "  Sample inputs:  ../demo-scripts/SAMPLE-INPUTS.md"
echo ""

echo -e "${YELLOW}Note:${NC} First n8n startup may take 30–60 seconds."
echo ""
