# Ollama Setup Guide (100% Local - No API Keys)

**Perfect for enterprise environments where you can't use external APIs**

---

## What Is This?

Deploy **Ollama** (open-source LLM server) directly on your ROSA HCP cluster alongside n8n and MCP server. Everything runs locally - no external API keys needed.

---

## Why Ollama on ROSA?

| Feature | Ollama on ROSA | Vertex AI | OpenAI |
|---------|---------------|-----------|--------|
| **API Keys** | ❌ None needed | ⚠️ Service account | ⚠️ API key |
| **Data Privacy** | ✅ 100% on-cluster | ⚠️ Google Cloud | ⚠️ External API |
| **Cost** | ✅ Free (just compute) | 💰 $10-15/month | 💰 $8-12/month |
| **Latency** | ✅ Local (fast) | ⚠️ External API | ⚠️ External API |
| **Enterprise Ready** | ✅ Red Hat support | ✅ Yes | ⚠️ Depends |
| **Offline** | ✅ Works offline | ❌ Needs internet | ❌ Needs internet |

**Perfect for:**
- ✅ Enterprise/regulated environments
- ✅ Air-gapped clusters
- ✅ Data sovereignty requirements
- ✅ Cost-conscious deployments
- ✅ Red Hat OpenShift customers

---

## Prerequisites

1. **Running ROSA HCP cluster** (you already have this ✅)
2. **n8n deployed** (you already have this ✅)
3. **MCP server deployed** (you already have this ✅)
4. **oc CLI** installed and logged in
5. **Cluster resources:**
   - 4-8 GB RAM for Ollama pod
   - 2-4 CPU cores
   - 50 GB storage for models

---

## Quick Start (3 Steps)

### Step 1: Deploy Ollama to ROSA

```bash
# Make sure you're logged in to your ROSA cluster
oc login --token=YOUR_TOKEN --server=YOUR_SERVER

# Run the automated setup script
./scripts/setup-ollama-rosa.sh
```

**What this does:**
1. ✅ Creates PersistentVolumeClaim (50GB for models)
2. ✅ Deploys Ollama pod
3. ✅ Creates Service for internal access
4. ✅ Creates Route for external access (optional)
5. ✅ Downloads your chosen model (llama3.1:8b recommended)
6. ✅ Tests the deployment

**Time:** 5-10 minutes (mostly downloading the model)

---

### Step 2: Import Ollama Workflow into n8n

```bash
# Access your n8n on ROSA
# URL: https://n8n-n8n.apps.YOUR-CLUSTER.openshiftapps.com

# In n8n UI:
# 1. Click "Import from File"
# 2. Select: workflows/03-solution-architect-ollama.json
# 3. Click "Save"
```

**The workflow is pre-configured:**
- Ollama URL: `http://ollama.n8n.svc.cluster.local:11434`
- Model: `llama3.1:8b` (change if you chose different)
- MCP Client: Already connected to your MCP server

**No credentials needed!** Everything is internal to the cluster.

---

### Step 3: Test with Sample Input

Open the n8n chat interface and paste this:

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

**Expected Output:**
- Complete ROSA proposal (2-3 pages)
- Multi-AZ architecture diagram
- Instance types and sizing
- Cost breakdown
- Compliance approach
- Implementation timeline

**Response time:** 30-60 seconds (local processing)

---

## Model Selection Guide

### Recommended Models

| Model | Size | Speed | Quality | Use Case |
|-------|------|-------|---------|----------|
| **llama3.1:8b** ⭐ | 4.7 GB | Fast | Good | Demos, general use |
| **qwen2.5:14b** | 9 GB | Medium | Excellent | Technical content |
| **llama3.1:70b** | 40 GB | Slow | Best | Production, critical |
| **mistral:latest** | 4.1 GB | Fast | Good | Alternative |

### Download Models

```bash
# Get pod name
POD=$(oc get pod -l app=ollama -n n8n -o jsonpath='{.items[0].metadata.name}')

# Download a model
oc exec -n n8n $POD -- ollama pull llama3.1:8b

# List available models
oc exec -n n8n $POD -- ollama list

# Test a model
oc exec -n n8n $POD -- ollama run llama3.1:8b "Hello, are you working?"
```

### Switch Models in Workflow

In n8n:
1. Open workflow: `03-solution-architect-ollama.json`
2. Click on "Ollama (Local)" node
3. Change **model** field to your choice:
   - `llama3.1:8b`
   - `qwen2.5:14b`
   - `llama3.1:70b`
   - `mistral:latest`
4. Save

---

## Architecture

### How It Works

```
User Input
    ↓
n8n Chat Interface (ROSA)
    ↓
AI Agent (n8n workflow)
    ├─→ Ollama Service (http://ollama.n8n.svc.cluster.local:11434)
    │   └─→ LLM Model (llama3.1:8b, etc.)
    │
    └─→ MCP Server (live cluster data)
        └─→ Kubernetes API
    ↓
Complete Proposal
```

### All Components on ROSA

```
ROSA HCP Cluster
│
├── n8n namespace
│   ├── n8n pod (workflow engine)
│   ├── ollama pod (LLM server)
│   │   └── models (llama3.1:8b, etc.)
│   └── ollama-models-pvc (50GB storage)
│
└── openshift-mcp-server namespace
    └── mcp-server pod (Kubernetes queries)
```

**Everything is ClusterIP services - internal only, secure by default.**

---

## Performance & Sizing

### Expected Response Times

| Query Type | llama3.1:8b | qwen2.5:14b | llama3.1:70b |
|------------|-------------|-------------|--------------|
| Simple query (2K tokens) | 10-15s | 20-30s | 60-90s |
| Full proposal (8K tokens) | 30-60s | 60-120s | 3-5 min |

### Resource Requirements

**Minimum (llama3.1:8b):**
- CPU: 2 cores
- RAM: 4 GB
- Storage: 10 GB (model)

**Recommended (qwen2.5:14b):**
- CPU: 4 cores
- RAM: 8 GB
- Storage: 15 GB (model)

**High Performance (llama3.1:70b):**
- CPU: 8 cores
- RAM: 16 GB
- Storage: 50 GB (model)

### Scale Up Resources

```bash
# Scale up Ollama pod
oc set resources deployment/ollama -n n8n \
  --requests=cpu=4,memory=8Gi \
  --limits=cpu=8,memory=16Gi

# Restart pod to apply changes
oc rollout restart deployment/ollama -n n8n
```

---

## Troubleshooting

### Ollama Pod Not Starting

```bash
# Check pod status
oc get pods -n n8n -l app=ollama

# Check logs
oc logs -l app=ollama -n n8n -f

# Common issues:
# - Insufficient memory: Scale up resources
# - PVC not binding: Check storage class
```

### Model Download Fails

```bash
# Check if pod has internet access
oc exec -n n8n deployment/ollama -- curl -I https://ollama.com

# If blocked, download model locally then upload:
# 1. Download on laptop: ollama pull llama3.1:8b
# 2. Find model files: ~/.ollama/models
# 3. Copy to pod (requires oc cp or manual process)
```

### Slow Response Times

```bash
# Check resource usage
oc top pod -n n8n -l app=ollama

# If CPU/RAM maxed out:
# 1. Scale up resources (see above)
# 2. Use smaller model (llama3.1:8b vs 70b)
# 3. Reduce numPredict in workflow (8192 → 4096)
```

### n8n Can't Connect to Ollama

```bash
# Test connectivity from n8n pod
N8N_POD=$(oc get pod -l app=n8n -n n8n -o jsonpath='{.items[0].metadata.name}')
oc exec -n n8n $N8N_POD -- curl http://ollama.n8n.svc.cluster.local:11434

# Should return: "Ollama is running"

# If fails:
# - Check service: oc get svc ollama -n n8n
# - Check endpoints: oc get endpoints ollama -n n8n
```

### Model Not Generating Good Outputs

**Try these:**

1. **Switch to a better model:**
   ```bash
   oc exec -n n8n deployment/ollama -- ollama pull qwen2.5:14b
   # Update workflow to use qwen2.5:14b
   ```

2. **Adjust temperature:**
   - In workflow, "Ollama (Local)" node
   - Change temperature: 0.3 (consistent) vs 0.7 (creative)

3. **Increase output length:**
   - In workflow, "Ollama (Local)" node
   - Change numPredict: 8192 → 16384

---

## Cost Analysis

### Ollama on ROSA vs External APIs

**Monthly costs (100 queries/month):**

| Solution | Compute | Storage | API Costs | **Total** |
|----------|---------|---------|-----------|-----------|
| **Ollama (llama3.1:8b)** | $50-100* | $5 | $0 | **$55-105** |
| **Ollama (shared pod)** | $0** | $5 | $0 | **$5** |
| **Vertex AI** | $0 | $0 | $10-15 | **$10-15** |
| **OpenAI** | $0 | $0 | $8-12 | **$8-12** |

\* If running dedicated pod  
\*\* If sharing existing n8n pod resources

**Break-even:**
- **< 100 queries/month:** Vertex AI/OpenAI is cheaper
- **> 500 queries/month:** Ollama is cheaper
- **Enterprise/regulated:** Ollama (data privacy = priceless)

---

## Production Best Practices

### High Availability

```yaml
# Edit deploy/07-ollama.yaml (CPU section at bottom; GPU between markers)
spec:
  replicas: 2  # Run 2 Ollama pods for HA
  
  # Add pod anti-affinity
  affinity:
    podAntiAffinity:
      requiredDuringSchedulingIgnoredDuringExecution:
      - labelSelector:
          matchLabels:
            app: ollama
        topologyKey: kubernetes.io/hostname
```

### Resource Limits

```yaml
# Prevent resource starvation
resources:
  requests:
    memory: "4Gi"
    cpu: "2"
  limits:
    memory: "8Gi"
    cpu: "4"
```

### Monitoring

```bash
# Add Prometheus metrics
oc label deployment/ollama -n n8n prometheus=true

# Monitor with Grafana dashboard
# Metrics: requests/sec, latency, memory usage
```

### Auto-scaling (Advanced)

```bash
# Scale based on CPU
oc autoscale deployment/ollama -n n8n \
  --cpu-percent=70 \
  --min=1 \
  --max=3
```

---

## Comparison: Ollama vs Cloud APIs

### Ollama Advantages

✅ **No API keys** - Zero credential management  
✅ **Data privacy** - Everything stays on-cluster  
✅ **Cost predictable** - Just compute, no per-query fees  
✅ **Offline capable** - Works without internet  
✅ **No rate limits** - Only limited by hardware  
✅ **Red Hat supported** - Runs on OpenShift  

### Ollama Limitations

⚠️ **Slower** - Local processing vs optimized cloud infrastructure  
⚠️ **Resource intensive** - Needs dedicated CPU/RAM  
⚠️ **Model management** - You download and update models  
⚠️ **Quality varies** - Open models vs GPT-4o/Claude  

### When to Use Ollama

**Choose Ollama if:**
- Enterprise/regulated environment (HIPAA, FedRAMP, etc.)
- Data can't leave the cluster
- High query volume (>500/month)
- Already have spare cluster resources
- Air-gapped/restricted network

**Choose Cloud APIs if:**
- Need highest quality outputs
- Low query volume (<100/month)
- Constrained cluster resources
- Want fastest response times
- Prototype/demo phase

---

## Model Quality Comparison

### Output Quality (1-10 scale)

| Task | llama3.1:8b | qwen2.5:14b | llama3.1:70b | GPT-4o | Claude 3.5 |
|------|-------------|-------------|--------------|--------|------------|
| **Architecture Design** | 7 | 8 | 9 | 9 | 10 |
| **Cost Calculations** | 6 | 7 | 8 | 8 | 9 |
| **Compliance Language** | 7 | 8 | 9 | 9 | 9 |
| **Mermaid Diagrams** | 7 | 8 | 8 | 9 | 9 |
| **Technical Accuracy** | 7 | 8 | 9 | 9 | 9 |

**Verdict:**
- **Demo/POC:** llama3.1:8b is good enough ✅
- **Production:** qwen2.5:14b or llama3.1:70b recommended
- **Best quality:** Still Cloud APIs (but Ollama is close!)

---

## Next Steps

1. ✅ **Deploy Ollama** - Run `./scripts/setup-ollama-rosa.sh`
2. ✅ **Import workflow** - Load `workflows/03-solution-architect-ollama.json`
3. ✅ **Test with samples** - Use `demo-scripts/SAMPLE-INPUTS.md`
4. ⏭️ **Tune performance** - Adjust resources based on usage
5. ⏭️ **Try different models** - Compare llama3.1 vs qwen2.5
6. ⏭️ **Monitor metrics** - Set up Prometheus/Grafana

---

## Support & Resources

**Documentation:**
- Ollama: https://ollama.com/library
- Models: https://ollama.com/library
- n8n Ollama: https://docs.n8n.io/integrations/builtin/cluster-nodes/root-nodes/n8n-nodes-langchain.lmchatollama/

**Commands:**
```bash
# Ollama management
oc exec -n n8n deployment/ollama -- ollama list
oc exec -n n8n deployment/ollama -- ollama pull MODEL_NAME
oc exec -n n8n deployment/ollama -- ollama run MODEL_NAME "Test query"

# Troubleshooting
oc logs -l app=ollama -n n8n -f
oc describe pod -l app=ollama -n n8n
oc get events -n n8n --sort-by='.lastTimestamp'
```

---

**✅ 100% local. 100% secure. No API keys. Enterprise-ready.**
