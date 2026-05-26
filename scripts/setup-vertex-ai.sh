#!/bin/bash

# Setup Script for Vertex AI + n8n OpenShift Solution Architect Demo
# This script automates the Google Cloud setup for the Vertex AI workflow

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}╔════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║  OpenShift Solution Architect - Vertex AI Setup               ║${NC}"
echo -e "${BLUE}║  No API Keys Required - Uses Google Cloud Authentication      ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════════════╝${NC}"
echo ""

# Check if gcloud is installed
if ! command -v gcloud &> /dev/null; then
    echo -e "${RED}❌ Error: gcloud CLI not found${NC}"
    echo -e "${YELLOW}Please install: https://cloud.google.com/sdk/docs/install${NC}"
    exit 1
fi

echo -e "${GREEN}✅ gcloud CLI found${NC}"

# Check if user is authenticated
if ! gcloud auth list --filter=status:ACTIVE --format="value(account)" &> /dev/null; then
    echo -e "${YELLOW}⚠️  Not authenticated. Running 'gcloud auth login'...${NC}"
    gcloud auth login
fi

CURRENT_ACCOUNT=$(gcloud auth list --filter=status:ACTIVE --format="value(account)" | head -n1)
echo -e "${GREEN}✅ Authenticated as: ${CURRENT_ACCOUNT}${NC}"

# Get or set project
CURRENT_PROJECT=$(gcloud config get-value project 2>/dev/null || echo "")

if [ -z "$CURRENT_PROJECT" ] || [ "$CURRENT_PROJECT" == "(unset)" ]; then
    echo -e "${YELLOW}No project set. Please enter your Google Cloud Project ID:${NC}"
    read -p "Project ID: " PROJECT_ID
    gcloud config set project "$PROJECT_ID"
else
    echo -e "${BLUE}Current project: ${CURRENT_PROJECT}${NC}"
    read -p "Use this project? (y/n): " USE_CURRENT
    if [[ $USE_CURRENT != "y" ]]; then
        read -p "Enter new project ID: " PROJECT_ID
        gcloud config set project "$PROJECT_ID"
    else
        PROJECT_ID=$CURRENT_PROJECT
    fi
fi

echo -e "${GREEN}✅ Using project: ${PROJECT_ID}${NC}"
echo ""

# Enable Vertex AI API
echo -e "${BLUE}Enabling Vertex AI API...${NC}"
if gcloud services enable aiplatform.googleapis.com --project="$PROJECT_ID"; then
    echo -e "${GREEN}✅ Vertex AI API enabled${NC}"
else
    echo -e "${RED}❌ Failed to enable Vertex AI API${NC}"
    exit 1
fi

# Ask user for authentication method
echo ""
echo -e "${BLUE}Choose authentication method:${NC}"
echo "1) Service Account (Recommended for production)"
echo "2) Application Default Credentials (Recommended for development)"
read -p "Enter choice (1 or 2): " AUTH_CHOICE

if [ "$AUTH_CHOICE" == "1" ]; then
    # Service Account setup
    SERVICE_ACCOUNT_NAME="n8n-vertex-ai"
    SERVICE_ACCOUNT_EMAIL="${SERVICE_ACCOUNT_NAME}@${PROJECT_ID}.iam.gserviceaccount.com"
    KEY_FILE="$HOME/n8n-vertex-ai-key.json"

    echo ""
    echo -e "${BLUE}Creating service account: ${SERVICE_ACCOUNT_EMAIL}${NC}"

    # Check if service account already exists
    if gcloud iam service-accounts describe "$SERVICE_ACCOUNT_EMAIL" --project="$PROJECT_ID" &> /dev/null; then
        echo -e "${YELLOW}⚠️  Service account already exists${NC}"
    else
        gcloud iam service-accounts create "$SERVICE_ACCOUNT_NAME" \
            --display-name="n8n Vertex AI Access" \
            --description="Service account for n8n to access Vertex AI" \
            --project="$PROJECT_ID"
        echo -e "${GREEN}✅ Service account created${NC}"
    fi

    # Grant Vertex AI User role
    echo -e "${BLUE}Granting Vertex AI User role...${NC}"
    gcloud projects add-iam-policy-binding "$PROJECT_ID" \
        --member="serviceAccount:${SERVICE_ACCOUNT_EMAIL}" \
        --role="roles/aiplatform.user" \
        --condition=None \
        > /dev/null 2>&1

    echo -e "${GREEN}✅ IAM role granted${NC}"

    # Create key
    echo -e "${BLUE}Creating service account key...${NC}"
    if [ -f "$KEY_FILE" ]; then
        echo -e "${YELLOW}⚠️  Key file already exists at ${KEY_FILE}${NC}"
        read -p "Overwrite? (y/n): " OVERWRITE
        if [[ $OVERWRITE == "y" ]]; then
            gcloud iam service-accounts keys create "$KEY_FILE" \
                --iam-account="$SERVICE_ACCOUNT_EMAIL" \
                --project="$PROJECT_ID"
            echo -e "${GREEN}✅ New key created${NC}"
        fi
    else
        gcloud iam service-accounts keys create "$KEY_FILE" \
            --iam-account="$SERVICE_ACCOUNT_EMAIL" \
            --project="$PROJECT_ID"
        echo -e "${GREEN}✅ Key created at: ${KEY_FILE}${NC}"
    fi

    echo ""
    echo -e "${GREEN}╔════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║  Service Account Setup Complete!                              ║${NC}"
    echo -e "${GREEN}╚════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${BLUE}📝 Next Steps for n8n:${NC}"
    echo ""
    echo "1. Open n8n: http://localhost:5678"
    echo "2. Go to Settings → Credentials → Add Credential"
    echo "3. Search for 'Google Cloud' or 'Google Service Account'"
    echo "4. Upload this file: ${KEY_FILE}"
    echo "5. Import workflow: workflows/01-solution-architect-vertexai.json"
    echo "6. Update 'Google Vertex AI (Claude)' node credentials"
    echo ""
    echo -e "${YELLOW}⚠️  Keep this key secure! Add to .gitignore${NC}"
    echo ""

elif [ "$AUTH_CHOICE" == "2" ]; then
    # Application Default Credentials
    echo ""
    echo -e "${BLUE}Setting up Application Default Credentials...${NC}"

    if gcloud auth application-default login; then
        echo -e "${GREEN}✅ Application Default Credentials configured${NC}"

        ADC_FILE="$HOME/.config/gcloud/application_default_credentials.json"

        echo ""
        echo -e "${GREEN}╔════════════════════════════════════════════════════════════════╗${NC}"
        echo -e "${GREEN}║  Application Default Credentials Setup Complete!              ║${NC}"
        echo -e "${GREEN}╚════════════════════════════════════════════════════════════════╝${NC}"
        echo ""
        echo -e "${BLUE}📝 Next Steps for n8n:${NC}"
        echo ""
        echo "1. Open n8n: http://localhost:5678"
        echo "2. Go to Settings → Credentials → Add Credential"
        echo "3. Search for 'Google Cloud'"
        echo "4. Select 'Use Application Default Credentials'"
        echo "5. Import workflow: workflows/01-solution-architect-vertexai.json"
        echo "6. Update 'Google Vertex AI (Claude)' node credentials"
        echo ""
        echo -e "${YELLOW}💡 For Docker/production, use Service Account instead${NC}"
        echo ""
    else
        echo -e "${RED}❌ Failed to set up Application Default Credentials${NC}"
        exit 1
    fi
else
    echo -e "${RED}❌ Invalid choice${NC}"
    exit 1
fi

# Test Vertex AI access
echo -e "${BLUE}Testing Vertex AI access...${NC}"
TEST_RESPONSE=$(curl -s -X POST \
  -H "Authorization: Bearer $(gcloud auth print-access-token)" \
  -H "Content-Type: application/json" \
  "https://us-central1-aiplatform.googleapis.com/v1/projects/${PROJECT_ID}/locations/us-central1/publishers/anthropic/models/claude-3-5-sonnet-v2@20241022:streamRawPredict" \
  -d '{
    "anthropic_version": "vertex-2023-10-16",
    "messages": [{"role": "user", "content": "Hello! Respond with just: OK"}],
    "max_tokens": 10
  }' 2>&1)

if echo "$TEST_RESPONSE" | grep -q "OK"; then
    echo -e "${GREEN}✅ Vertex AI access confirmed!${NC}"
else
    echo -e "${YELLOW}⚠️  Could not verify Vertex AI access${NC}"
    echo -e "${YELLOW}This might be normal if quotas need time to propagate${NC}"
    echo -e "${YELLOW}Test again in 5 minutes or check manually${NC}"
fi

echo ""
echo -e "${GREEN}╔════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║  Setup Complete! 🎉                                            ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${BLUE}📚 Resources:${NC}"
echo "  • Workflow: workflows/01-solution-architect-vertexai.json"
echo "  • Sample Inputs: demo-scripts/SAMPLE-INPUTS.md"
echo ""
echo -e "${BLUE}🚀 Ready to import the workflow into n8n!${NC}"
echo ""
