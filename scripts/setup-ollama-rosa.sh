#!/bin/bash

# Deploy and Configure Ollama on ROSA HCP for n8n
# No API keys required - 100% local/on-cluster

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
OLLAMA_MANIFEST="${REPO_ROOT}/deploy/07-ollama.yaml"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

USE_GPU=false
GPU_ONLY=false
for arg in "$@"; do
  case "$arg" in
    --gpu) USE_GPU=true ;;
    --gpu-only) USE_GPU=true; GPU_ONLY=true ;;
    -h|--help)
      echo "Usage: $0 [--gpu | --gpu-only]"
      echo "  (default) CPU deployment from deploy/07-ollama.yaml"
      echo "  --gpu       Apply shared resources, then replace deployment with GPU variant"
      echo "  --gpu-only  Replace deployment with GPU variant (PVC/Service must exist)"
      exit 0
      ;;
  esac
done

apply_ollama_gpu_deployment() {
  awk '/^# @@@ OLLAMA-GPU-DEPLOYMENT-START/,/^# @@@ OLLAMA-GPU-DEPLOYMENT-END/' "$OLLAMA_MANIFEST" \
    | grep -v '^#' | oc apply -f -
}

echo -e "${BLUE}╔════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║  Deploy Ollama to ROSA HCP - No API Keys Required            ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════════════╝${NC}"
echo ""

if ! command -v oc &> /dev/null; then
    echo -e "${RED}❌ Error: oc CLI not found${NC}"
    exit 1
fi

echo -e "${GREEN}✅ oc CLI found${NC}"

if ! oc whoami &> /dev/null; then
    echo -e "${RED}❌ Not logged in to OpenShift${NC}"
    exit 1
fi

CURRENT_USER=$(oc whoami)
CURRENT_SERVER=$(oc whoami --show-server)
echo -e "${GREEN}✅ Logged in as: ${CURRENT_USER}${NC}"
echo -e "${GREEN}✅ Server: ${CURRENT_SERVER}${NC}"
echo ""

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
if [[ "$USE_GPU" == true ]]; then
    echo -e "${BLUE}Deploying Ollama (GPU)...${NC}"
    if [[ "$GPU_ONLY" != true ]]; then
        oc apply -f "$OLLAMA_MANIFEST"
    fi
    oc delete deployment ollama -n n8n --ignore-not-found
    apply_ollama_gpu_deployment
else
    echo -e "${BLUE}Deploying Ollama (CPU)...${NC}"
    oc apply -f "$OLLAMA_MANIFEST"
fi

echo ""
echo -e "${BLUE}Waiting for Ollama pod to be ready...${NC}"
echo -e "${YELLOW}This may take 1-2 minutes (longer on first GPU start)...${NC}"

if oc wait --for=condition=ready pod -l app=ollama -n n8n --timeout=600s; then
    echo -e "${GREEN}✅ Ollama is ready${NC}"
else
    echo -e "${RED}❌ Ollama pod failed to start${NC}"
    echo -e "${YELLOW}Check: oc describe pod -l app=ollama -n n8n${NC}"
    exit 1
fi

echo ""
echo -e "${BLUE}Choose model to download:${NC}"
echo "1) llama3.1:8b (Recommended - 4.7GB)"
echo "2) qwen2.5:7b (4.7GB, good for technical content)"
echo "3) qwen2.5:3b (2GB, fastest on CPU)"
echo "4) Skip model download (do it manually later)"
read -p "Enter choice (1-4): " MODEL_CHOICE

case $MODEL_CHOICE in
    1) MODEL="llama3.1:8b" ;;
    2) MODEL="qwen2.5:7b" ;;
    3) MODEL="qwen2.5:3b" ;;
    4) MODEL="" ;;
    *) MODEL="llama3.1:8b" ;;
esac

POD_NAME=$(oc get pod -l app=ollama -n n8n -o jsonpath='{.items[0].metadata.name}')

if [ -n "$MODEL" ]; then
    echo ""
    echo -e "${BLUE}Pulling model: ${MODEL}${NC}"
    if oc exec -n n8n "$POD_NAME" -- ollama pull "$MODEL"; then
        echo -e "${GREEN}✅ Model downloaded: ${MODEL}${NC}"
    else
        echo -e "${RED}❌ Failed to download model${NC}"
    fi
fi

echo ""
echo -e "${GREEN}╔════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║  Ollama Deployment Complete! 🎉                                ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${BLUE}Internal URL (n8n):${NC} http://ollama.n8n.svc.cluster.local:11434"
echo -e "${BLUE}Manifest:${NC} deploy/07-ollama.yaml"
if [[ "$USE_GPU" == true ]]; then
    echo -e "${BLUE}Compute:${NC} GPU (nvidia.com/gpu)"
else
    echo -e "${BLUE}Compute:${NC} CPU"
fi
echo ""
echo -e "${GREEN}✅ Ready to use! No API keys required.${NC}"
