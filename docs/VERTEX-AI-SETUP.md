# Vertex AI Setup Guide (No API Keys Required)

**Goal:** Run the OpenShift Solution Architect workflow using Claude via Google Cloud Vertex AI without managing API keys.

---

## Why Vertex AI Instead of Anthropic API?

| Aspect | Anthropic Direct API | Vertex AI |
|--------|---------------------|-----------|
| **Authentication** | API key required | Google Cloud IAM (no keys to manage) |
| **Billing** | Separate Anthropic billing | On Google Cloud bill |
| **Rate Limits** | Separate rate limits | Enterprise-grade quotas |
| **Compliance** | HIPAA/SOC2 via Anthropic | Inherits GCP compliance (HIPAA, FedRAMP, etc.) |
| **Models** | Claude 3.5 Sonnet, Opus, Haiku | Same Claude models via Vertex |
| **Best For** | Direct API access | Enterprise deployments with existing GCP |

**TL;DR:** If you're already using Google Cloud, Vertex AI gives you Claude without managing API keys.

---

## Prerequisites

### 1. Google Cloud Project

```bash
# Check if you have gcloud installed
gcloud --version

# If not installed: https://cloud.google.com/sdk/docs/install

# Login to Google Cloud
gcloud auth login

# Set your project (replace with your project ID)
gcloud config set project YOUR-PROJECT-ID

# Verify current project
gcloud config get-value project
```

### 2. Enable Vertex AI API

```bash
# Enable the Vertex AI API
gcloud services enable aiplatform.googleapis.com

# Verify it's enabled
gcloud services list --enabled | grep aiplatform
```

### 3. Set Up Authentication for n8n

**Option A: Service Account (Recommended for Production)**

```bash
# Create a service account for n8n
gcloud iam service-accounts create n8n-vertex-ai \
    --display-name="n8n Vertex AI Access" \
    --description="Service account for n8n to access Vertex AI"

# Grant Vertex AI User role
gcloud projects add-iam-policy-binding YOUR-PROJECT-ID \
    --member="serviceAccount:n8n-vertex-ai@YOUR-PROJECT-ID.iam.gserviceaccount.com" \
    --role="roles/aiplatform.user"

# Create and download key
gcloud iam service-accounts keys create ~/n8n-vertex-ai-key.json \
    --iam-account=n8n-vertex-ai@YOUR-PROJECT-ID.iam.gserviceaccount.com

# Save the path - you'll need it for n8n credentials
echo "Service account key saved to: ~/n8n-vertex-ai-key.json"
```

**Option B: Application Default Credentials (Recommended for Development)**

```bash
# Set up application default credentials
gcloud auth application-default login

# This creates credentials at:
# macOS: ~/.config/gcloud/application_default_credentials.json
# Linux: ~/.config/gcloud/application_default_credentials.json
# Windows: %APPDATA%\gcloud\application_default_credentials.json
```

### 4. Verify Vertex AI Access

```bash
# Test that you can access Vertex AI
curl -X POST \
  -H "Authorization: Bearer $(gcloud auth print-access-token)" \
  -H "Content-Type: application/json" \
  https://us-central1-aiplatform.googleapis.com/v1/projects/YOUR-PROJECT-ID/locations/us-central1/publishers/anthropic/models/claude-3-5-sonnet-v2@20241022:streamRawPredict \
  -d '{
    "anthropic_version": "vertex-2023-10-16",
    "messages": [{"role": "user", "content": "Hello!"}],
    "max_tokens": 100
  }'

# You should see a response from Claude
```

---

## n8n Configuration

### 1. Install n8n (if not already installed)

```bash
# Using npm
npm install -g n8n

# Or using Docker
docker run -it --rm \
  --name n8n \
  -p 5678:5678 \
  -v ~/.n8n:/home/node/.n8n \
  n8nio/n8n
```

### 2. Add Google Cloud Credentials to n8n

**Via n8n UI:**

1. Open n8n: `http://localhost:5678`
2. Go to **Settings** → **Credentials**
3. Click **Add Credential**
4. Search for **"Google Cloud"** or **"Google Service Account"**
5. Choose authentication method:

   **Option A: Service Account JSON**
   - Upload the `n8n-vertex-ai-key.json` file
   - Or paste the JSON content directly

   **Option B: Application Default Credentials**
   - Select "Use Application Default Credentials"
   - Leave other fields empty

6. Click **Save**
7. **Note the credential ID** - you'll update it in the workflow

**Via Environment Variables (Docker/Production):**

```bash
# For service account
export GOOGLE_APPLICATION_CREDENTIALS=/path/to/n8n-vertex-ai-key.json

# For Docker
docker run -it --rm \
  --name n8n \
  -p 5678:5678 \
  -v ~/.n8n:/home/node/.n8n \
  -v ~/n8n-vertex-ai-key.json:/keys/vertex-ai-key.json \
  -e GOOGLE_APPLICATION_CREDENTIALS=/keys/vertex-ai-key.json \
  n8nio/n8n
```

### 3. Import the Workflow

```bash
# Copy the workflow file to your n8n workflows directory
cp workflows/01-solution-architect-vertexai.json ~/.n8n/workflows/

# Or import via n8n UI:
# 1. Open n8n
# 2. Click "Import from File"
# 3. Select: workflows/01-solution-architect-vertexai.json
```

### 4. Update Workflow Credentials

In the n8n workflow editor:

1. Click on the **"Google Vertex AI (Claude)"** node
2. Under **Credentials**, select your Google Cloud credential
3. **Model Configuration:**
   - **Model:** `claude-3-5-sonnet-v2@20241022`
   - **Region:** `us-central1` (recommended for Vertex AI)
   - **Temperature:** `0.3` (for consistent architectural recommendations)
   - **Max Tokens:** `8192` (for detailed proposals)

4. Click **Save**

### 5. Configure MCP Client (Optional - for Live Cluster Queries)

If you have the Kubernetes MCP server running:

1. Click on the **"MCP Client (Kubernetes)"** node
2. Update the URL if your MCP server is at a different location:
   ```
   http://kubernetes-mcp-server.openshift-mcp-server.svc.cluster.local:8080/sse
   ```
3. Or for local testing:
   ```
   http://localhost:8080/sse
   ```

If you **don't** have an MCP server yet:
- The workflow will still work for Scenarios 1 and 3 (pre-sales and competitive analysis)
- Scenario 2 (live cluster optimization) requires the MCP server
- See: `docs/mcp-server-setup.md` for installation

---

## Testing the Workflow

### Test 1: Pre-Sales Scenario (No Live Cluster Needed)

1. **Activate the workflow** in n8n
2. **Open the Chat** interface
3. **Paste this test input:**

```
Discovery Notes - Acme Financial Services

Company: Acme Financial (5,000 employees)
Current State: On-premise VMware infrastructure, planning cloud migration
Requirements:
- Need HIPAA and PCI-DSS compliance
- 50 microservices (Java Spring Boot, Node.js, Python)
- 10,000 daily active users
- High availability required (99.9% SLA)
- CI/CD with Jenkins, want to modernize
- Need disaster recovery across regions
- Budget: $50K-75K/month for infrastructure

Pain Points:
- Long deployment times (2-3 days for production)
- Manual scaling causing weekend outages
- Compliance audits are painful
- Want managed Kubernetes, not self-managed

Timeline: Production by Q3 2026
```

4. **Expected Output:**
   - Complete ROSA proposal with architecture diagram
   - Multi-AZ deployment design
   - Specific instance types (m5.4xlarge, etc.)
   - Cost breakdown (~$45K/month estimate)
   - HIPAA/PCI compliance approach
   - 90-day implementation timeline
   - ROI analysis

### Test 2: Competitive Analysis (No Live Cluster Needed)

**Paste this:**

```
Current State - RetailCo EKS Environment

We're running EKS in us-east-1:
- 3x m5.2xlarge nodes (control plane managed by AWS)
- 12x m5.4xlarge worker nodes
- 500 GB EBS gp3 storage
- Application Load Balancer
- CloudWatch logging
- ~$8,500/month AWS bill

Considering ROSA because:
- Want better enterprise support (AWS support is slow)
- Need Red Hat middleware (AMQ, Data Grid)
- Compliance team prefers Red Hat for certifications

Questions:
- How does ROSA pricing compare to our current EKS?
- Is migration effort worth it?
- What do we gain beyond "just Kubernetes"?
```

**Expected Output:**
- Side-by-side cost comparison (EKS vs ROSA)
- Feature parity analysis
- Migration effort estimate (4-6 weeks)
- Value proposition for Red Hat middleware
- ROI calculation with payback period

### Test 3: Live Cluster Optimization (Requires MCP Server)

**Only works if you have a ROSA/OpenShift cluster and MCP server running.**

**Paste this:**

```
Please analyze my ROSA cluster and provide optimization recommendations.

Cluster: production-rosa-us-east-1
Focus areas:
- Cost optimization opportunities
- Security best practices
- Resource utilization
- Unused resources
```

**Expected Output:**
- Current cluster state (nodes, namespaces, workloads)
- Over/under-provisioned resources
- Cost savings opportunities
- Security scan results
- Specific action items with commands

---

## Troubleshooting

### Error: "Permission denied" or "Forbidden"

```bash
# Verify service account has correct roles
gcloud projects get-iam-policy YOUR-PROJECT-ID \
  --flatten="bindings[].members" \
  --filter="bindings.members:serviceAccount:n8n-vertex-ai@*"

# Should show: roles/aiplatform.user

# If missing, add it:
gcloud projects add-iam-policy-binding YOUR-PROJECT-ID \
  --member="serviceAccount:n8n-vertex-ai@YOUR-PROJECT-ID.iam.gserviceaccount.com" \
  --role="roles/aiplatform.user"
```

### Error: "Model not found" or "Invalid model"

The model name must exactly match Vertex AI's naming:

```
claude-3-5-sonnet-v2@20241022  ✅ Correct
claude-3.5-sonnet              ❌ Wrong (Anthropic API format)
claude-3-5-sonnet-20241022     ❌ Wrong (missing @version)
```

**Available Claude models in Vertex AI:**
- `claude-3-5-sonnet-v2@20241022` (Recommended - best for architecture)
- `claude-3-5-haiku@20241022` (Faster, cheaper - good for simple queries)
- `claude-3-opus@20240229` (Most capable - complex analysis)

### Error: "Quota exceeded"

```bash
# Check your Vertex AI quotas
gcloud compute project-info describe --project=YOUR-PROJECT-ID

# Request quota increase:
# https://console.cloud.google.com/iam-admin/quotas

# Filter for: "Vertex AI API"
# Metric: "Requests per minute per region"
# Request increase to: 60 (default is 10)
```

### Error: "Region not supported"

Vertex AI Claude models are available in specific regions:

```bash
# Supported regions for Claude:
- us-central1     ✅ Recommended (lowest latency)
- us-east5        ✅ Alternative
- europe-west1    ✅ EU customers
- asia-southeast1 ✅ APAC customers

# Update in the workflow node:
# Google Vertex AI (Claude) → Parameters → Region
```

### n8n Can't Find Credentials

```bash
# Check if credentials file exists
ls -la ~/.config/gcloud/application_default_credentials.json

# Or for service account
ls -la ~/n8n-vertex-ai-key.json

# Re-authenticate if needed
gcloud auth application-default login

# For Docker, verify volume mount
docker exec -it n8n ls -la /keys/
```

---

## Cost Optimization Tips

### Vertex AI Pricing (as of May 2026)

| Model | Input (per 1M tokens) | Output (per 1M tokens) |
|-------|----------------------|------------------------|
| Claude 3.5 Sonnet | $3.00 | $15.00 |
| Claude 3.5 Haiku | $0.80 | $4.00 |
| Claude 3 Opus | $15.00 | $75.00 |

**Typical Usage:**
- Pre-sales proposal: ~10K tokens input, ~5K tokens output = $0.12/query
- Cluster optimization: ~5K tokens input, ~3K tokens output = $0.06/query
- Competitive analysis: ~8K tokens input, ~4K tokens output = $0.09/query

**Monthly estimate:** 100 queries/month = ~$10-15/month

### Reduce Costs

1. **Use Claude 3.5 Haiku for simple queries:**
   ```javascript
   // In workflow, add logic to route to Haiku for:
   - Quick questions
   - Follow-up queries
   - Simple cost calculations
   ```

2. **Enable caching (coming soon in Vertex AI):**
   - Cache system prompts to reduce input tokens
   - Can save 50-70% on repeated queries

3. **Set max_tokens appropriately:**
   ```javascript
   // For quick answers:
   max_tokens: 2048  // Saves cost vs 8192
   
   // For detailed proposals:
   max_tokens: 8192  // Full architecture docs
   ```

---

## Production Deployment Checklist

- [ ] Create dedicated service account (not using personal credentials)
- [ ] Set up monitoring for Vertex AI API usage
- [ ] Configure quota alerts in Google Cloud Console
- [ ] Enable Cloud Logging for API calls
- [ ] Set up secret management (Google Secret Manager)
- [ ] Configure n8n with persistent storage
- [ ] Set up backup for n8n workflows
- [ ] Document credential rotation process
- [ ] Enable audit logging for compliance
- [ ] Test failover scenarios

---

## Next Steps

1. **Test the workflow** with sample inputs (see above)
2. **Customize system prompts** in `AI Agent` node for your use cases
3. **Set up MCP server** for live cluster queries (optional)
4. **Add more data sources:**
   - Azure pricing API for ARO comparisons
   - EKS pricing API for competitive analysis
   - Red Hat documentation scraper
5. **Create custom scenarios** based on your sales motion

---

## Support & Resources

- **Vertex AI Documentation:** https://cloud.google.com/vertex-ai/docs/generative-ai/model-reference/claude
- **n8n Documentation:** https://docs.n8n.io/integrations/builtin/credentials/google/
- **Google Cloud Support:** https://cloud.google.com/support
- **This Demo Issues:** https://github.com/YOUR-REPO/issues

---

**✅ No API keys to manage. No secrets to rotate. Just Google Cloud IAM.**
