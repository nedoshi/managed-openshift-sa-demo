#!/bin/bash

# Fix Ollama permissions for OpenShift
# Redeploy with proper security context

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}╔════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║  Fix Ollama Permissions for OpenShift                         ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════════════╝${NC}"
echo ""

# Check if logged in
if ! oc whoami &> /dev/null; then
    echo -e "${RED}❌ Not logged in to OpenShift${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Logged in as: $(oc whoami)${NC}"
echo ""

# Delete existing deployment if it exists
if oc get deployment ollama -n n8n &> /dev/null; then
    echo -e "${YELLOW}Deleting existing Ollama deployment...${NC}"
    oc delete deployment ollama -n n8n
    echo -e "${GREEN}✅ Deleted${NC}"
fi

echo ""
echo -e "${BLUE}Deploying Ollama with OpenShift-compatible permissions...${NC}"

# Apply the fixed deployment
oc apply -f deploy/07-ollama.yaml

echo ""
echo -e "${BLUE}Waiting for pod to be ready...${NC}"
echo -e "${YELLOW}This may take 1-2 minutes...${NC}"

if oc wait --for=condition=ready pod -l app=ollama -n n8n --timeout=300s; then
    echo -e "${GREEN}✅ Ollama is ready${NC}"
else
    echo -e "${RED}❌ Pod failed to start${NC}"
    echo ""
    echo -e "${YELLOW}Checking logs:${NC}"
    oc logs -l app=ollama -n n8n --tail=50
    exit 1
fi

# Get pod name
POD_NAME=$(oc get pod -l app=ollama -n n8n -o jsonpath='{.items[0].metadata.name}')

echo ""
echo -e "${BLUE}Testing Ollama service...${NC}"

# Wait a bit for service to fully start
sleep 5

if oc exec -n n8n "$POD_NAME" -- curl -s http://localhost:11434 | grep -q "Ollama"; then
    echo -e "${GREEN}✅ Ollama is responding${NC}"
else
    echo -e "${YELLOW}⚠️  Ollama may need more time to start${NC}"
fi

echo ""
echo -e "${BLUE}Choose model to download:${NC}"
echo "1) llama3.1:8b (Recommended - 4.7GB, fast, good quality)"
echo "2) qwen2.5:14b (9GB, excellent for technical content)"
echo "3) mistral:latest (4.1GB, good alternative)"
echo "4) Skip model download (do it manually later)"
read -p "Enter choice (1-4): " MODEL_CHOICE

case $MODEL_CHOICE in
    1)
        MODEL="llama3.1:8b"
        ;;
    2)
        MODEL="qwen2.5:14b"
        ;;
    3)
        MODEL="mistral:latest"
        ;;
    4)
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

    if oc exec -n n8n "$POD_NAME" -- ollama pull "$MODEL"; then
        echo -e "${GREEN}✅ Model downloaded: ${MODEL}${NC}"
        
        # Test the model
        echo ""
        echo -e "${BLUE}Testing model...${NC}"
        if oc exec -n n8n "$POD_NAME" -- ollama run "$MODEL" "Say OK" 2>&1 | grep -q "OK"; then
            echo -e "${GREEN}✅ Model is working!${NC}"
        fi
    else
        echo -e "${RED}❌ Failed to download model${NC}"
        echo -e "${YELLOW}You can try again manually:${NC}"
        echo "  oc exec -n n8n deployment/ollama -- ollama pull $MODEL"
    fi
fi

# Get route
OLLAMA_ROUTE=$(oc get route ollama -n n8n -o jsonpath='{.spec.host}' 2>/dev/null || echo "")

echo ""
echo -e "${GREEN}╔════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║  Ollama Fixed and Ready! 🎉                                    ║${NC}"
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
fi
echo ""
echo -e "${BLUE}🔧 Useful Commands:${NC}"
echo ""
echo "# List models:"
echo "  oc exec -n n8n deployment/ollama -- ollama list"
echo ""
echo "# Pull additional models:"
echo "  oc exec -n n8n deployment/ollama -- ollama pull MODEL_NAME"
echo ""
echo "# Test Ollama:"
echo "  oc exec -n n8n deployment/ollama -- ollama run $MODEL 'Hello'"
echo ""
echo "# Check logs:"
echo "  oc logs -l app=ollama -n n8n -f"
echo ""
echo -e "${GREEN}✅ Ready to import workflow: workflows/03-solution-architect-ollama.json${NC}"
echo ""
