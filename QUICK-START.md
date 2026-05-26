# Quick Start Guide - OpenShift Solution Architect Demo

**Get running in 15 minutes with the Vertex AI workflow (no API keys required)**

---

## Choose Your Path

### Path A: Vertex AI (Recommended - No API Keys!)

✅ **Best for:**
- Google Cloud customers
- Production deployments
- No API key management
- Enterprise compliance needs

⏱️ **Time:** 15 minutes  
💰 **Cost:** ~$10-15/month for typical usage

**Steps:**
```bash
# 1. Run automated setup
./scripts/setup-vertex-ai.sh

# 2. Follow the prompts to:
#    - Enable Vertex AI API
#    - Create service account or use ADC
#    - Get credentials for n8n

# 3. Import workflow into n8n
#    - Open n8n: http://localhost:5678
#    - Import: workflows/01-solution-architect-vertexai.json
#    - Configure Google Cloud credentials

# 4. Test with sample inputs
#    - See: demo-scripts/SAMPLE-INPUTS.md
```

📖 **Full Guide:** [docs/VERTEX-AI-SETUP.md](docs/VERTEX-AI-SETUP.md)

---

### Path B: OpenAI (Fast Demo Setup)

✅ **Best for:**
- Quick demos (ready in 5 min)
- Non-Google Cloud users
- Internal testing
- POCs and experimentation

⏱️ **Time:** 5 minutes  
💰 **Cost:** ~$8-12/month for typical usage

**Steps:**
```bash
# 1. Get OpenAI API key
#    https://platform.openai.com/api-keys

# 2. Import workflow into n8n
#    - Open n8n: http://localhost:5678
#    - Import: workflows/02-discovery-architect-openai.json

# 3. Add OpenAI credentials
#    - Settings → Credentials → Add
#    - Paste API key

# 4. Test with sample inputs
#    - See: demo-scripts/SAMPLE-INPUTS.md
```

---

## Prerequisites

### Install n8n

**Option 1: npm (Recommended)**
```bash
npm install -g n8n
n8n start
```

**Option 2: Docker**
```bash
docker run -it --rm \
  --name n8n \
  -p 5678:5678 \
  -v ~/.n8n:/home/node/.n8n \
  n8nio/n8n
```

**Option 3: npx (No install)**
```bash
npx n8n
```

### For Vertex AI Path: Install gcloud CLI

```bash
# macOS
brew install --cask google-cloud-sdk

# Linux
curl https://sdk.cloud.google.com | bash

# Windows
# Download from: https://cloud.google.com/sdk/docs/install

# Verify
gcloud --version
```

---

## Test the Workflow

### Sample Input 1: Pre-Sales Discovery

```
Discovery Notes - Acme Financial Services

Company: Acme Financial (5,000 employees)
Current State: On-premise VMware, planning cloud migration

Requirements:
- HIPAA and PCI-DSS compliance
- 50 microservices (Java, Node.js, Python)
- 10,000 daily active users
- 99.9% SLA required
- Need disaster recovery across regions
- Budget: $50-75K/month

Pain Points:
- 2-3 day production deployments
- Manual scaling causing outages
- Compliance audits are painful
- Want managed Kubernetes

Timeline: Production by Q3 2026
```

**Expected Output:**
- Complete ROSA proposal
- Multi-AZ architecture diagram
- Specific instance types and sizing
- Cost breakdown ($45K/month)
- HIPAA/PCI compliance approach
- 90-day implementation plan

---

### Sample Input 2: Competitive Analysis

```
Current EKS Environment - RetailCo

Infrastructure:
- 3x m5.2xlarge control plane (managed by AWS)
- 12x m5.4xlarge worker nodes
- 500 GB EBS gp3 storage
- Application Load Balancer
- CloudWatch logging
- Current cost: $8,500/month

Considering ROSA because:
- Want better enterprise support
- Need Red Hat middleware (AMQ, Data Grid)
- Compliance team prefers Red Hat

Questions:
- How does ROSA pricing compare?
- Is migration worth it?
- What do we gain beyond Kubernetes?
```

**Expected Output:**
- Side-by-side cost comparison
- Feature parity analysis
- Migration effort estimate (4-6 weeks)
- Red Hat middleware value proposition
- ROI calculation

---

## What You Get

### All Three Scenarios Automated:

1. **Pre-Sales Discovery → Proposal**
   - Input: Customer discovery notes
   - Output: Complete ROSA proposal with costs and timeline
   - Demo time: 2 minutes

2. **Post-Sales Optimization**
   - Input: "Optimize my cluster" request
   - Output: Detailed audit with specific fixes
   - Demo time: 2 minutes
   - *Requires: MCP server connection to live cluster*

3. **EKS/AKS → ROSA Comparison**
   - Input: Current EKS/AKS setup
   - Output: Cost comparison + migration plan + ROI
   - Demo time: 2 minutes

---

## Troubleshooting

### Vertex AI: "Permission denied"

```bash
# Verify service account has correct role
gcloud projects get-iam-policy YOUR-PROJECT-ID \
  --flatten="bindings[].members" \
  --filter="bindings.members:serviceAccount:n8n-vertex-ai@*"

# Should show: roles/aiplatform.user
```

### Vertex AI: "Model not found"

The model name must be exact:
```
✅ claude-3-5-sonnet-v2@20241022
❌ claude-3.5-sonnet
❌ claude-3-5-sonnet-20241022
```

### OpenAI: "Invalid API key"

```bash
# Test your API key
curl https://api.openai.com/v1/models \
  -H "Authorization: Bearer YOUR-API-KEY"

# Should return a list of models
```

### n8n: "Cannot find module"

```bash
# For npm installation
npm install -g n8n@latest

# For Docker, pull latest
docker pull n8nio/n8n:latest
```

---

## Next Steps

1. ✅ **Test with sample inputs** (see above)
2. 📖 **Review demo script** - [demo-scripts/SOLUTION-ARCHITECT-DEMO-SCRIPT.md](demo-scripts/SOLUTION-ARCHITECT-DEMO-SCRIPT.md)
3. 🎯 **Customize system prompts** for your use cases
4. 🔧 **Set up MCP server** for live cluster queries (optional)
5. 📊 **Compare workflows** - [docs/WORKFLOW-COMPARISON.md](docs/WORKFLOW-COMPARISON.md)

---

## Resources

| Resource | Link |
|----------|------|
| **Vertex AI Setup** | [docs/VERTEX-AI-SETUP.md](docs/VERTEX-AI-SETUP.md) |
| **Workflow Comparison** | [docs/WORKFLOW-COMPARISON.md](docs/WORKFLOW-COMPARISON.md) |
| **Sample Inputs** | [demo-scripts/SAMPLE-INPUTS.md](demo-scripts/SAMPLE-INPUTS.md) |
| **Demo Script** | [demo-scripts/SOLUTION-ARCHITECT-DEMO-SCRIPT.md](demo-scripts/SOLUTION-ARCHITECT-DEMO-SCRIPT.md) |
| **Troubleshooting** | [docs/troubleshooting.md](docs/troubleshooting.md) |

---

## Questions?

**Which workflow should I use?**
- Google Cloud customer? → Vertex AI
- Need fast demo? → OpenAI
- Production deployment? → Vertex AI
- Experimenting? → OpenAI

**Do I need a live OpenShift cluster?**
- No! Scenarios 1 and 3 work without one
- Scenario 2 (optimization) requires MCP server + live cluster

**How much does this cost?**
- Vertex AI: ~$10-15/month (100 queries)
- OpenAI: ~$8-12/month (100 queries)
- n8n: Free (self-hosted)

**Can I run both workflows?**
- Yes! Run OpenAI for testing, Vertex AI for production
- See hybrid approach in [WORKFLOW-COMPARISON.md](docs/WORKFLOW-COMPARISON.md)

---

**Ready to demo? Start with Path A (Vertex AI) for the best experience!**
