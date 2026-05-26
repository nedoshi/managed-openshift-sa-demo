#!/bin/bash

# Deploy Ollama to ROSA HCP with proper SCC handling
# Handles OpenShift Security Context Constraints

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}╔════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║  Deploy Ollama to ROSA HCP (SCC-Compatible)                   ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════════════╝${NC}"
echo ""

# Check oc CLI
if ! command -v oc &> /dev/null; then
    echo -e "${RED}❌ oc CLI not found${NC}"
    exit 1
fi

# Check login
if ! oc whoami &> /dev/null; then
    echo -e "${RED}❌ Not logged in to OpenShift${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Logged in as: $(oc whoami)${NC}"
echo ""

# Ensure namespace exists
if ! oc get namespace n8n &> /dev/null; then
    echo -e "${YELLOW}Creating namespace n8n...${NC}"
    oc create namespace n8n
fi

echo -e "${GREEN}✅ Namespace: n8n${NC}"
echo ""

# Clean up any existing deployment
if oc get deployment ollama -n n8n &> /dev/null; then
    echo -e "${YELLOW}Deleting existing Ollama deployment...${NC}"
    oc delete deployment ollama -n n8n --wait=true
    sleep 5
fi

# Apply deployment
echo -e "${BLUE}Deploying Ollama with OpenShift SCC compatibility...${NC}"
oc apply -f deploy/07-ollama.yaml

echo ""
echo -e "${BLUE}Waiting for pod to be ready (this may take 2-3 minutes)...${NC}"

# Wait for deployment to be available
for i in {1..60}; do
    if oc get deployment ollama -n n8n &> /dev/null; then
        READY=$(oc get deployment ollama -n n8n -o jsonpath='{.status.readyReplicas}' 2>/dev/null || echo "0")
        if [ "$READY" == "1" ]; then
            echo -e "${GREEN}✅ Ollama pod is ready${NC}"
            break
        fi
    fi
    
    # Check for errors
    if oc get deployment ollama -n n8n -o jsonpath='{.status.conditions[?(@.type=="ReplicaFailure")].status}' 2>/dev/null | grep -q "True"; then
        echo -e "${RED}❌ Deployment failed${NC}"
        echo ""
        echo -e "${YELLOW}Checking for SCC issues...${NC}"
        oc get events -n n8n --field-selector involvedObject.name=ollama --sort-by='.lastTimestamp' | tail -5
        echo ""
        echo -e "${YELLOW}💡 Try granting nonroot-v2 SCC to the service account:${NC}"
        echo "   oc adm policy add-scc-to-user nonroot-v2 -z ollama -n n8n"
        exit 1
    fi
    
    echo -n "."
    sleep 5
done

echo ""

# Get pod name
POD_NAME=$(oc get pod -l app=ollama -n n8n -o jsonpath='{.items[0].metadata.name}' 2>/dev/null || echo "")

if [ -z "$POD_NAME" ]; then
    echo -e "${RED}❌ No pod found${NC}"
    echo ""
    echo -e "${YELLOW}Checking recent events:${NC}"
    oc get events -n n8n --sort-by='.lastTimestamp' | grep ollama | tail -10
    exit 1
fi

echo -e "${GREEN}✅ Pod running: $POD_NAME${NC}"

# Wait for Ollama service to be ready
echo ""
echo -e "${BLUE}Waiting for Ollama service to start...${NC}"
sleep 10

for i in {1..12}; do
    if oc exec -n n8n "$POD_NAME" -- curl -sf http://localhost:11434 &> /dev/null; then
        echo -e "${GREEN}✅ Ollama service is responding${NC}"
        break
    fi
    echo -n "."
    sleep 5
done

echo ""
echo ""
echo -e "${BLUE}Choose model to download:${NC}"
echo "1) llama3.1:8b (Recommended - 4.7GB, fast, good quality)"
echo "2) qwen2.5:14b (9GB, excellent for technical content)"
echo "3) mistral:latest (4.1GB, good alternative)"
echo "4) Skip model download (do it manually later)"
read -p "Enter choice (1-4): " MODEL_CHOICE

case $MODEL_CHOICE in
    1) MODEL="llama3.1:8b" ;;
    2) MODEL="qwen2.5:14b" ;;
    3) MODEL="mistral:latest" ;;
    4) MODEL="" ;;
    *) MODEL="llama3.1:8b" ;;
esac

if [ -n "$MODEL" ]; then
    echo ""
    echo -e "${BLUE}Downloading model: ${MODEL}${NC}"
    echo -e "${YELLOW}This will take 5-10 minutes depending on model size...${NC}"
    echo ""
    
    if oc exec -n n8n "$POD_NAME" -- ollama pull "$MODEL"; then
        echo ""
        echo -e "${GREEN}✅ Model downloaded: ${MODEL}${NC}"
        
        # Test model
        echo ""
        echo -e "${BLUE}Testing model...${NC}"
        TEST_OUTPUT=$(oc exec -n n8n "$POD_NAME" -- ollama run "$MODEL" "Say OK" 2>&1 || echo "")
        if echo "$TEST_OUTPUT" | grep -qi "OK"; then
            echo -e "${GREEN}✅ Model is working!${NC}"
        else
            echo -e "${YELLOW}⚠️  Model downloaded but test unclear${NC}"
        fi
    else
        echo -e "${RED}❌ Failed to download model${NC}"
        echo -e "${YELLOW}You can try manually:${NC}"
        echo "  oc exec -n n8n deployment/ollama -- ollama pull $MODEL"
    fi
fi

# Get route
OLLAMA_ROUTE=$(oc get route ollama -n n8n -o jsonpath='{.spec.host}' 2>/dev/null || echo "")

echo ""
echo -e "${GREEN}╔════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║  Ollama Deployed Successfully! 🎉                              ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${BLUE}📝 Connection Details:${NC}"
echo ""
echo -e "${GREEN}Internal URL (for n8n):${NC}"
echo "  http://ollama.n8n.svc.cluster.local:11434"
echo ""
if [ -n "$OLLAMA_ROUTE" ]; then
    echo -e "${GREEN}External URL (for testing):${NC}"
    echo "  https://$OLLAMA_ROUTE"
    echo ""
fi
echo -e "${BLUE}🔧 Useful Commands:${NC}"
echo ""
echo "# List downloaded models:"
echo "  oc exec -n n8n deployment/ollama -- ollama list"
echo ""
echo "# Download additional models:"
echo "  oc exec -n n8n deployment/ollama -- ollama pull llama3.1:8b"
echo ""
echo "# Test a model:"
if [ -n "$MODEL" ]; then
    echo "  oc exec -n n8n deployment/ollama -- ollama run $MODEL 'Hello'"
else
    echo "  oc exec -n n8n deployment/ollama -- ollama run MODEL_NAME 'Hello'"
fi
echo ""
echo "# Check logs:"
echo "  oc logs -l app=ollama -n n8n -f"
echo ""
echo "# Check pod details:"
echo "  oc describe pod -l app=ollama -n n8n"
echo ""
echo -e "${BLUE}📋 Next Steps:${NC}"
echo ""
echo "1. Import workflow into n8n:"
echo "   workflows/03-solution-architect-ollama.json"
echo ""
echo "2. The workflow is pre-configured with:"
echo "   - URL: http://ollama.n8n.svc.cluster.local:11434"
if [ -n "$MODEL" ]; then
    echo "   - Model: $MODEL"
fi
echo ""
echo "3. Test with sample inputs from:"
echo "   demo-scripts/SAMPLE-INPUTS.md"
echo ""
echo -e "${GREEN}✅ Ready to use! No API keys required.${NC}"
echo ""
