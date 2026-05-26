# Solution Architect Agent - Demo Package

**Purpose:** AI-powered OpenShift architecture workflows for Solution Architects on ROSA HCP.

**Start here:** [OLLAMA-QUICKSTART.md](OLLAMA-QUICKSTART.md)

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
# 1. Deploy n8n + MCP server
./deploy/deploy-to-rosa-hcp.sh

# 2. Deploy Ollama (local LLM, no API keys)
./scripts/setup-ollama-rosa.sh

# 3. Import workflow in n8n UI
#    workflows/03-solution-architect-ollama.json

# 4. Test with demo-scripts/SAMPLE-INPUTS.md
```

See [OLLAMA-QUICKSTART.md](OLLAMA-QUICKSTART.md) for step-by-step instructions.

---

## Repository Layout

```
deploy/          # n8n, MCP server, Ollama manifests + deploy scripts
scripts/         # setup-ollama-rosa.sh
workflows/       # 03-solution-architect-ollama.json
demo-scripts/    # SAMPLE-INPUTS.md (copy-paste demo prompts)
```

---

## Prerequisites

- ROSA HCP or ARO cluster
- `oc` CLI logged in
- n8n community package: `@n8n/n8n-nodes-langchain` (install via n8n UI after deploy)
