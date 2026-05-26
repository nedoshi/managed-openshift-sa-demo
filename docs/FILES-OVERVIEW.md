# Files Overview

Complete guide to all files in this demo package.

---

## 📁 Repository Structure

```
managed-openshift-sa-demo/
├── README.md                           # Main overview and entry point
├── QUICK-START.md                      # 15-minute setup guide
├── .gitignore                          # Protects sensitive credentials
│
├── workflows/                          # n8n workflow definitions
│   ├── 01-solution-architect-vertexai.json     # ⭐ Vertex AI (no API keys)
│   ├── 02-discovery-architect-openai.json      # OpenAI (fast demo)
│   └── 03-solution-architect-unified.md        # Technical design doc
│
├── docs/                               # Documentation
│   ├── VERTEX-AI-SETUP.md             # Vertex AI setup guide
│   ├── WORKFLOW-COMPARISON.md         # Detailed workflow comparison
│   ├── ARCHITECTURE-DIAGRAMS.md       # Visual architecture diagrams
│   ├── troubleshooting.md             # Common issues and fixes
│   ├── sample-queries.md              # Example queries
│   └── FILES-OVERVIEW.md              # This file
│
├── demo-scripts/                       # Demo materials
│   ├── QUICK-START-GUIDE.md           # Original quick start
│   └── SAMPLE-INPUTS.md               # Copy-paste demo inputs
│
├── scripts/                            # Automation scripts
│   └── setup-vertex-ai.sh             # Automated Vertex AI setup
│
└── deploy/                             # Kubernetes/OpenShift deployments
    ├── 00-openshift-mcp-server-namespace.yaml
    ├── 01-namespace.yaml
    ├── 02-pvc.yaml
    ├── 04-deployment.yaml
    ├── 05-service.yaml
    ├── 06-route.yaml
    ├── mcp-server-openshift.yaml
    ├── apply-deployment-openshift.sh
    ├── deploy-to-rosa-hcp.sh
    └── install-mcp-operator.sh
```

---

## 🎯 Start Here Files

### README.md
**Purpose:** Main entry point and overview  
**What's inside:**
- Key capabilities and features
- Path A (Vertex AI) vs Path B (OpenAI) setup
- Links to all resources
- Three scenario descriptions

**When to read:** First file to read

---

### QUICK-START.md
**Purpose:** Get running in 15 minutes  
**What's inside:**
- Step-by-step setup for both workflows
- Prerequisites and installation
- Sample test inputs
- Troubleshooting quick fixes

**When to read:** When you're ready to set up

---

## 🔧 Workflow Files

### workflows/01-solution-architect-vertexai.json ⭐
**Purpose:** Production-ready n8n workflow using Vertex AI  
**What's inside:**
- Chat trigger for user interface
- Google Vertex AI (Claude 3.5 Sonnet) integration
- MCP client for Kubernetes/OpenShift queries
- AWS ROSA pricing API integration
- Pricing parser and memory buffer

**Key features:**
- ✅ No API keys required
- ✅ Uses Google Cloud IAM
- ✅ Real-time ROSA pricing
- ✅ Live cluster data via MCP
- ✅ Comprehensive system prompt (8K tokens)

**Model:** Claude 3.5 Sonnet (best for architecture reasoning)  
**Cost:** ~$10-15/month for 100 queries  
**Setup time:** 15 minutes  

**When to use:**
- Production deployments
- Google Cloud customers
- Enterprise compliance needed
- Want to avoid API key management

**Import instructions:**
1. Open n8n: `http://localhost:5678`
2. Import this JSON file
3. Configure Google Cloud credentials
4. Test with SAMPLE-INPUTS.md

---

### workflows/02-discovery-architect-openai.json
**Purpose:** Quick demo workflow using OpenAI  
**What's inside:**
- Chat trigger for user interface
- OpenAI GPT-4o integration
- MCP client for Kubernetes/OpenShift queries

**Key features:**
- ⚡ Fast setup (5 minutes)
- ✅ Live cluster data via MCP
- ❌ No real-time pricing (relies on model knowledge)
- ⚠️ API key required

**Model:** GPT-4o (fast and capable)  
**Cost:** ~$8-12/month for 100 queries  
**Setup time:** 5 minutes  

**When to use:**
- Quick demos
- Non-Google Cloud environments
- Internal testing
- POCs and experimentation

**Import instructions:**
1. Get API key from platform.openai.com
2. Import this JSON file into n8n
3. Add OpenAI credentials
4. Test with SAMPLE-INPUTS.md

---

### workflows/03-solution-architect-unified.md
**Purpose:** Technical design documentation  
**What's inside:**
- Workflow architecture overview
- Three scenario definitions
- System prompt designs
- Data source descriptions
- Future enhancement ideas

**When to read:**
- Understanding the design rationale
- Customizing system prompts
- Adding new scenarios
- Architecture review

---

## 📖 Documentation Files

### docs/VERTEX-AI-SETUP.md
**Purpose:** Complete Vertex AI setup guide  
**What's inside:**
- Prerequisites (gcloud CLI, project setup)
- Step-by-step authentication setup
- Service account vs ADC comparison
- n8n configuration instructions
- Testing procedures
- Troubleshooting guide
- Cost optimization tips
- Production deployment checklist

**When to read:** Before setting up Vertex AI workflow

**Key sections:**
- Enable Vertex AI API
- Create service account or use ADC
- Configure n8n credentials
- Test with sample inputs
- Troubleshoot common errors

---

### docs/WORKFLOW-COMPARISON.md
**Purpose:** Detailed comparison of both workflows  
**What's inside:**
- Feature comparison matrix
- Authentication flow comparison
- Model comparison (Claude vs GPT-4o)
- When to use each workflow
- Migration paths between workflows
- Hybrid deployment approach
- Performance benchmarks
- FAQ

**When to read:**
- Choosing between workflows
- Understanding trade-offs
- Planning production deployment
- Migrating between workflows

**Key tables:**
- Quick comparison table
- Feature parity matrix
- Cost comparison
- Performance benchmarks

---

### docs/ARCHITECTURE-DIAGRAMS.md
**Purpose:** Visual architecture diagrams  
**What's inside:**
- Vertex AI workflow architecture (Mermaid)
- OpenAI workflow architecture (Mermaid)
- Data flow diagrams
- Authentication flow diagrams
- Deployment architectures
- Integration points
- Cost comparison diagrams

**When to read:**
- Understanding the architecture
- Presenting to stakeholders
- Planning integrations
- Deployment planning

**All diagrams in Mermaid format** (renders on GitHub, VS Code, etc.)

---

### docs/troubleshooting.md
**Purpose:** Common issues and solutions  
**What's inside:**
- Error messages and fixes
- Configuration issues
- Network problems
- Authentication errors
- Performance tuning

**When to read:** When something isn't working

---

### docs/sample-queries.md
**Purpose:** Example queries for testing  
**What's inside:**
- Sample discovery notes
- Test cluster queries
- Edge cases
- Expected outputs

**When to read:** Testing the workflows

---

### docs/FILES-OVERVIEW.md
**Purpose:** This file - complete file reference  
**When to read:** Understanding the repository structure

---

## 🎬 Demo Materials

### demo-scripts/QUICK-START-GUIDE.md
**Purpose:** Original quick start guide  
**What's inside:**
- Demo preparation checklist
- Talking points for SSA demos
- Sample scenario walk-throughs
- Objection handling

**When to read:** Preparing for a demo

---

### demo-scripts/SAMPLE-INPUTS.md
**Purpose:** Ready-to-use demo inputs  
**What's inside:**
- **Scenario 1:** Acme Financial (pre-sales discovery)
- **Scenario 2:** TechCorp (cluster optimization)
- **Scenario 3:** RetailCo (EKS → ROSA comparison)

**Format:** Copy-paste ready for live demos

**When to use:**
- Testing workflows
- Live demos
- Training
- Benchmarking

**Each scenario includes:**
- Customer background
- Requirements
- Pain points
- Expected output description

---

## 🤖 Scripts

### scripts/setup-vertex-ai.sh
**Purpose:** Automated Vertex AI setup  
**What it does:**
1. Checks for gcloud CLI
2. Authenticates with Google Cloud
3. Sets/verifies project
4. Enables Vertex AI API
5. Creates service account (or sets up ADC)
6. Grants IAM roles
7. Creates and saves key file
8. Tests Vertex AI access
9. Prints next steps

**Usage:**
```bash
chmod +x scripts/setup-vertex-ai.sh
./scripts/setup-vertex-ai.sh
```

**Interactive:** Prompts for project ID and auth method

**Output:**
- Service account key: `~/n8n-vertex-ai-key.json`
- Or ADC: `~/.config/gcloud/application_default_credentials.json`

**When to use:** First-time Vertex AI setup

---

## 🚀 Deployment Files

All files in `deploy/` directory are for Kubernetes/OpenShift deployments.

### deploy/00-openshift-mcp-server-namespace.yaml
**Purpose:** Creates namespace for MCP server  
**What it creates:** `openshift-mcp-server` namespace

### deploy/01-namespace.yaml
**Purpose:** Creates namespace for n8n  
**What it creates:** Namespace for n8n deployment

### deploy/02-pvc.yaml
**Purpose:** Persistent volume for n8n  
**What it creates:** PVC for n8n workflow storage

### deploy/04-deployment.yaml
**Purpose:** n8n deployment  
**What it creates:**
- n8n deployment/statefulset
- Volume mounts
- Environment variables
- Resource limits

### deploy/05-service.yaml
**Purpose:** n8n service  
**What it creates:** ClusterIP service for n8n

### deploy/06-route.yaml
**Purpose:** OpenShift route for n8n  
**What it creates:** Public route to access n8n UI

### deploy/mcp-server-openshift.yaml
**Purpose:** MCP server deployment  
**What it creates:**
- MCP server deployment
- Service account with cluster-reader
- Service for MCP server

### deploy/apply-deployment-openshift.sh
**Purpose:** Deploy all resources to OpenShift  
**Usage:**
```bash
./deploy/apply-deployment-openshift.sh
```

### deploy/deploy-to-rosa-hcp.sh
**Purpose:** Deploy to ROSA HCP cluster  
**Usage:**
```bash
./deploy/deploy-to-rosa-hcp.sh
```

### deploy/install-mcp-operator.sh
**Purpose:** Install MCP operator  
**Usage:**
```bash
./deploy/install-mcp-operator.sh
```

---

## 📝 Configuration Files

### .gitignore
**Purpose:** Protect sensitive credentials  
**What it ignores:**
- Google Cloud credential files (`*-key.json`)
- n8n local data (`.n8n/`, `*.db`)
- Environment variables (`.env`)
- IDE files (`.vscode/`, `.idea/`)
- Temporary files (`tmp/`, `*.tmp`)
- Claude Code workspace (`.claude/`)

**What it DOESN'T ignore:**
- Workflow JSON files (`workflows/*.json`)
- Deployment JSON files (`deploy/*.json`)

**⚠️ Important:** Never commit credential files!

---

## 🔄 Typical File Usage Flow

### First Time Setup
1. **README.md** - Understand what this is
2. **QUICK-START.md** - Choose Path A or B
3. **scripts/setup-vertex-ai.sh** - Automate GCP setup (Path A)
4. **workflows/01-solution-architect-vertexai.json** - Import into n8n
5. **demo-scripts/SAMPLE-INPUTS.md** - Test the workflow

### Preparing for a Demo
1. **demo-scripts/QUICK-START-GUIDE.md** - Review talking points
2. **demo-scripts/SAMPLE-INPUTS.md** - Prepare copy-paste inputs
3. **docs/ARCHITECTURE-DIAGRAMS.md** - Visual aids for presentation

### Troubleshooting
1. **docs/VERTEX-AI-SETUP.md** - Step-by-step troubleshooting
2. **docs/troubleshooting.md** - Common errors and fixes
3. **docs/WORKFLOW-COMPARISON.md** - Check if different workflow works

### Customization
1. **workflows/03-solution-architect-unified.md** - Understand design
2. **workflows/01-solution-architect-vertexai.json** - Edit system prompts
3. **docs/sample-queries.md** - Add new test cases

---

## 🎯 Files by Use Case

### "I want to get started quickly"
1. README.md
2. QUICK-START.md
3. scripts/setup-vertex-ai.sh

### "I want to understand the architecture"
1. docs/ARCHITECTURE-DIAGRAMS.md
2. workflows/03-solution-architect-unified.md
3. docs/WORKFLOW-COMPARISON.md

### "I want to demo this to my SSA"
1. demo-scripts/QUICK-START-GUIDE.md
2. demo-scripts/SAMPLE-INPUTS.md
3. docs/ARCHITECTURE-DIAGRAMS.md

### "I need to troubleshoot"
1. docs/VERTEX-AI-SETUP.md (Troubleshooting section)
2. docs/troubleshooting.md
3. docs/WORKFLOW-COMPARISON.md (FAQ section)

### "I want to customize it"
1. workflows/03-solution-architect-unified.md
2. Edit workflows/*.json files
3. docs/sample-queries.md

### "I want to deploy to production"
1. docs/VERTEX-AI-SETUP.md (Production section)
2. deploy/*.yaml files
3. deploy/apply-deployment-openshift.sh

---

## 🔍 Quick Reference

| I want to... | Read this file... |
|--------------|-------------------|
| Understand what this is | README.md |
| Get started in 15 min | QUICK-START.md |
| Set up Vertex AI | docs/VERTEX-AI-SETUP.md |
| Choose between workflows | docs/WORKFLOW-COMPARISON.md |
| See architecture diagrams | docs/ARCHITECTURE-DIAGRAMS.md |
| Prepare for a demo | demo-scripts/QUICK-START-GUIDE.md |
| Get test inputs | demo-scripts/SAMPLE-INPUTS.md |
| Fix an error | docs/VERTEX-AI-SETUP.md or docs/troubleshooting.md |
| Deploy to OpenShift | deploy/apply-deployment-openshift.sh |
| Customize system prompts | workflows/*.json |
| Understand the design | workflows/03-solution-architect-unified.md |
| See file structure | docs/FILES-OVERVIEW.md (this file) |

---

## 📊 File Metrics

| Category | File Count | Total Size |
|----------|------------|------------|
| **Documentation** | 6 | ~85 KB |
| **Workflows** | 3 | ~25 KB |
| **Demo Materials** | 2 | ~40 KB |
| **Scripts** | 4 | ~15 KB |
| **Deployment** | 11 | ~30 KB |
| **Total** | 26 | ~195 KB |

---

## 🎓 Learning Path

### Beginner
1. README.md (5 min)
2. QUICK-START.md (10 min)
3. Try Path B (OpenAI) first (5 min setup)
4. Test with SAMPLE-INPUTS.md (10 min)

**Total time:** 30 minutes to working demo

### Intermediate
1. All beginner files
2. docs/VERTEX-AI-SETUP.md (15 min)
3. Set up Path A (Vertex AI) (15 min)
4. docs/ARCHITECTURE-DIAGRAMS.md (10 min)
5. workflows/03-solution-architect-unified.md (20 min)

**Total time:** 1.5 hours to full understanding

### Advanced
1. All intermediate files
2. docs/WORKFLOW-COMPARISON.md (30 min)
3. Customize system prompts in workflows/*.json (30 min)
4. Deploy to OpenShift with deploy/*.yaml (30 min)
5. Set up hybrid workflow (20 min)

**Total time:** 3 hours to production deployment

---

## 🔐 Security Notes

**NEVER commit these files:**
- `*-key.json` (Google Cloud service account keys)
- `*-credentials.json` (Any credential files)
- `.env` (Environment variables)
- `.n8n/` (n8n database with credentials)

**These files ARE safe to commit:**
- `workflows/*.json` (No credentials, just workflow logic)
- `deploy/*.yaml` (No secrets, just Kubernetes manifests)
- All `.md` files (Documentation only)
- `scripts/*.sh` (Automation, no credentials)

**Best practices:**
- Use `.gitignore` to protect credentials
- Use service accounts with minimal permissions
- Rotate keys regularly (or use ADC)
- Never paste credentials in documentation
- Use secret management (Google Secret Manager)

---

**Questions? Check the specific file for that topic!**
