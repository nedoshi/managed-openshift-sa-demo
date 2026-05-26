#!/bin/bash

# Deploy and Configure Ollama on ROSA HCP for n8n
# No API keys required - 100% local/on-cluster

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}╔════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║  Deploy Ollama to ROSA HCP - No API Keys Required            ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════════════╝${NC}"
echo ""

# Check if oc is installed
if ! command -v oc &> /dev/null; then
    echo -e "${RED}❌ Error: oc CLI not found${NC}"
    echo -e "${YELLOW}Please install: https://docs.openshift.com/container-platform/latest/cli_reference/openshift_cli/getting-started-cli.html${NC}"
    exit 1
fi

echo -e "${GREEN}✅ oc CLI found${NC}"

# Check if logged in to OpenShift
if ! oc whoami &> /dev/null; then
    echo -e "${RED}❌ Not logged in to OpenShift${NC}"
    echo -e "${YELLOW}Please login first: oc login${NC}"
    exit 1
fi

CURRENT_USER=$(oc whoami)
CURRENT_SERVER=$(oc whoami --show-server)
echo -e "${GREEN}✅ Logged in as: ${CURRENT_USER}${NC}"
echo -e "${GREEN}✅ Server: ${CURRENT_SERVER}${NC}"
echo ""

# Check if n8n namespace exists
if ! oc get namespace n8n &> /dev/null; then
    echo -e "${YELLOW}⚠️  Namespace 'n8n' not found${NC}"
    read -p "Create it? (y/n): " CREATE_NS
    if [[ $CREATE_NS == "y" ]]; then
        oc create namespace n8n
        echo -e "${GREEN}✅ Namespace created${NC}"
    else
        echo -e "${RED}❌ Cannot proceed without n8n namespace${NC}"
        exit 1
    fi
else
    echo -e "${GREEN}✅ Namespace 'n8n' exists${NC}"
fi

echo ""
echo -e "${BLUE}Deploying Ollama to ROSA...${NC}"

# Deploy Ollama
if oc apply -f deploy/07-ollama-deployment.yaml; then
    echo -e "${GREEN}✅ Ollama deployment created${NC}"
else
    echo -e "${RED}❌ Failed to deploy Ollama${NC}"
    exit 1
fi

echo ""
echo -e "${BLUE}Waiting for Ollama pod to be ready...${NC}"
echo -e "${YELLOW}This may take 1-2 minutes...${NC}"

if oc wait --for=condition=ready pod -l app=ollama -n n8n --timeout=300s; then
    echo -e "${GREEN}✅ Ollama is ready${NC}"
else
    echo -e "${RED}❌ Ollama pod failed to start${NC}"
    echo -e "${YELLOW}Check logs: oc logs -l app=ollama -n n8n${NC}"
    exit 1
fi

echo ""
echo -e "${BLUE}Choose model to download:${NC}"
echo "1) llama3.1:8b (Recommended - 4.7GB, fast, good quality)"
echo "2) qwen2.5:14b (9GB, excellent for technical content)"
echo "3) llama3.1:70b (40GB, best quality, needs lots of resources)"
echo "4) mistral:latest (4.1GB, good alternative)"
echo "5) Skip model download (do it manually later)"
read -p "Enter choice (1-5): " MODEL_CHOICE

case $MODEL_CHOICE in
    1)
        MODEL="llama3.1:8b"
        ;;
    2)
        MODEL="qwen2.5:14b"
        ;;
    3)
        MODEL="llama3.1:70b"
        echo -e "${YELLOW}⚠️  Warning: This is a large model (40GB). Make sure you have enough resources.${NC}"
        ;;
    4)
        MODEL="mistral:latest"
        ;;
    5)
        echo -e "${YELLOW}Skipping model download${NC}"
        MODEL=""
        ;;
    *)
        echo -e "${RED}Invalid choice, defaulting to llama3.1:8b${NC}"
        MODEL="llama3.1:8b"
        ;;
esac

if [ -n "$MODEL" ]; then
    echo ""
    echo -e "${BLUE}Pulling model: ${MODEL}${NC}"
    echo -e "${YELLOW}This may take 5-10 minutes depending on model size...${NC}"

    POD_NAME=$(oc get pod -l app=ollama -n n8n -o jsonpath='{.items[0].metadata.name}')

    if oc exec -n n8n "$POD_NAME" -- ollama pull "$MODEL"; then
        echo -e "${GREEN}✅ Model downloaded: ${MODEL}${NC}"
    else
        echo -e "${RED}❌ Failed to download model${NC}"
        echo -e "${YELLOW}You can download it later manually:${NC}"
        echo "  oc exec -n n8n deployment/ollama -- ollama pull $MODEL"
    fi
fi

# Test Ollama
echo ""
echo -e "${BLUE}Testing Ollama...${NC}"

if [ -n "$MODEL" ]; then
    TEST_RESPONSE=$(oc exec -n n8n "$POD_NAME" -- ollama run "$MODEL" "Say 'OK' if you're working" 2>&1 | tail -1)
    if [[ $TEST_RESPONSE == *"OK"* ]] || [[ $TEST_RESPONSE == *"working"* ]]; then
        echo -e "${GREEN}✅ Ollama is working!${NC}"
    else
        echo -e "${YELLOW}⚠️  Ollama responded but may need verification${NC}"
        echo "Response: $TEST_RESPONSE"
    fi
fi

# Get Ollama route
OLLAMA_ROUTE=$(oc get route ollama -n n8n -o jsonpath='{.spec.host}' 2>/dev/null || echo "")

echo ""
echo -e "${GREEN}╔════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║  Ollama Deployment Complete! 🎉                                ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${BLUE}📝 Ollama Endpoints:${NC}"
echo ""
echo -e "${GREEN}Internal (from n8n):${NC}"
echo "  http://ollama.n8n.svc.cluster.local:11434"
echo ""
if [ -n "$OLLAMA_ROUTE" ]; then
    echo -e "${GREEN}External (for testing):${NC}"
    echo "  https://$OLLAMA_ROUTE"
    echo ""
fi
echo -e "${BLUE}📋 Next Steps:${NC}"
echo ""
echo "1. Import the Ollama workflow into n8n:"
echo "   - File: workflows/03-solution-architect-ollama.json"
echo "   - In n8n: Import from File"
echo ""
echo "2. The workflow is pre-configured to use:"
echo "   - Ollama URL: http://ollama.n8n.svc.cluster.local:11434"
if [ -n "$MODEL" ]; then
    echo "   - Model: $MODEL"
fi
echo ""
echo "3. Test with sample inputs from:"
echo "   - demo-scripts/SAMPLE-INPUTS.md"
echo ""
echo -e "${BLUE}🔧 Useful Commands:${NC}"
echo ""
echo "# List available models:"
echo "  oc exec -n n8n deployment/ollama -- ollama list"
echo ""
echo "# Pull additional models:"
echo "  oc exec -n n8n deployment/ollama -- ollama pull llama3.1:8b"
echo ""
echo "# Test Ollama:"
echo "  oc exec -n n8n deployment/ollama -- ollama run $MODEL 'Hello'"
echo ""
echo "# Check logs:"
echo "  oc logs -l app=ollama -n n8n -f"
echo ""
echo "# Scale up resources if needed:"
echo "  oc set resources deployment/ollama -n n8n --limits=cpu=8,memory=16Gi"
echo ""
echo -e "${GREEN}✅ Ready to use! No API keys required.${NC}"
echo ""
