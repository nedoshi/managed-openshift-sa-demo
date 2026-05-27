# Solution Architect Agent - Demo Package

**Purpose:** AI-powered OpenShift architecture workflows for Solution Architects on ROSA HCP.

---

## What It Does

An **n8n workflow** that turns discovery notes into complete ROSA proposals using on-cluster AI — **no API keys required**.

| Scenario | Input | Output |
|----------|-------|--------|
| **Pre-Sales** | Discovery notes | ROSA proposal with architecture, costs, timeline |
| **Post-Sales** | "Optimize my cluster" | Live cluster audit via MCP |
| **Competitive** | EKS/AKS setup | ROSA comparison + migration plan |

---

## Quick Start (ROSA HCP)

```bash
# 1. Deploy n8n + MCP server (+ MCP RBAC)
./deploy/deploy-to-rosa-hcp.sh
./deploy/install-mcp-operator.sh

# 2. Deploy Ollama in namespace n8n (this repo)
./scripts/setup-ollama-rosa.sh          # CPU
# ./scripts/setup-ollama-rosa.sh --gpu  # GPU — see Prerequisites

# For GPU machine pools, NVIDIA GPU Operator, and Open WebUI on ROSA, see:
# https://cloud.redhat.com/experts/ai-ml/ollama-openwebui/

# 3. Import workflow in n8n UI and Publish
#    workflows/03-solution-architect-ollama-with-export.json  (chat + Google Docs)
#    workflows/03-solution-architect-ollama.json              (chat only)

# 4. Configure Google Drive OAuth on the export workflow (folder ID in formatter JS)

# 5. Test with demo-scripts/SAMPLE-INPUTS.md
```

---

## Repository Layout

```
deploy/          # n8n, MCP server, Ollama (07-ollama.yaml), MCP RBAC
scripts/         # setup-ollama-rosa.sh
workflows/       # n8n workflow JSON + Code node sources (*.js)
demo-scripts/    # SAMPLE-INPUTS.md (copy-paste demo prompts)
```

**Workflow Code node sources** (keep in sync with JSON after edits):

| File | Used in |
|------|---------|
| `workflows/ollama-scenario-router.js` | Scenario Router node |
| `workflows/ollama-google-doc-formatter.js` | Format Proposal for Google Docs node |

---

## Can someone else recreate the demo?

**Yes**, with this repo plus cluster access:

1. Run deploy scripts (`deploy-to-rosa-hcp.sh`, `install-mcp-operator.sh`, `setup-ollama-rosa.sh`).
2. Import the workflow JSON into n8n (credentials + Google folder ID are per-environment).
3. Pull `qwen2.5:14b` (or model named in the workflow) on the Ollama pod.
4. Use `demo-scripts/SAMPLE-INPUTS.md` in n8n chat.

Optional: GPU setup following [Red Hat: Ollama and Open WebUI on ROSA](https://cloud.redhat.com/experts/ai-ml/ollama-openwebui/) instead of or in addition to `setup-ollama-rosa.sh`.

---

## Prerequisites

**Cluster & tools**

- ROSA HCP or ARO cluster
- `oc` CLI logged in
- n8n community package: `@n8n/n8n-nodes-langchain` (install via n8n UI after deploy)

**Ollama on CPU (default)** — no GPU required; inference is slower (minutes for long replies).

**Ollama on GPU (recommended for demos)** — if you use `./scripts/setup-ollama-rosa.sh --gpu`:

- GPU **worker machine pool** on ROSA (e.g. AWS `g4dn.xlarge`)
- **[NVIDIA GPU Operator](https://docs.nvidia.com/datacenter/cloud-native/gpu-operator/latest/openshift/olm-install.html)** installed and `ClusterPolicy` Ready
- Or follow [Red Hat Cloud Experts: Ollama on ROSA with GPUs](https://cloud.redhat.com/experts/ai-ml/ollama-openwebui/)
- Verify: `oc get nodes -l nvidia.com/gpu.present=true`

Use **`qwen2.5:14b`** on a T4 GPU (g4dn.xlarge) for solution-architect workflows (~9GB). Use `qwen2.5:7b` only if VRAM is tight.
