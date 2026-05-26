# Quick Start: Solution Architect Agent Demo

**Goal:** Present compelling demo to OpenShift SSA in 15 minutes  
**Outcome:** Prove this workflow beats Gemini Notebook for real SA work

---

## What You're Demonstrating

### The Three Scenarios That Will Win:

1. **Pre-Sales Discovery → Proposal** (Scenario 1)
   - Input: Customer discovery notes
   - Output: Complete ROSA proposal (architecture + costs + timeline)
   - **Gemini can't:** Access real-time ROSA pricing, validate capacity

2. **Post-Sales Optimization** (Scenario 2)
   - Input: "Optimize my cluster" request
   - Output: Detailed audit with specific fixes and cost savings
   - **Gemini can't:** Query live clusters, analyze actual resource usage

3. **EKS → ROSA Competitive Analysis** (Scenario 3)
   - Input: Current EKS setup details
   - Output: Fair cost comparison + migration plan + ROI analysis
   - **Gemini can't:** Access EKS pricing APIs, validate feature parity

---

## Files Created For You

### 📁 In `/demo-scripts/` folder:

1. **`SOLUTION-ARCHITECT-DEMO-SCRIPT.md`** (12 pages)
   - Complete demo script with exact talking points
   - Timing guide (12 minutes total)
   - Objection handlers
   - Q&A preparation

2. **`SAMPLE-INPUTS.md`** (18 pages)
   - Scenario 1: Acme Financial (discovery notes)
   - Scenario 2: TechCorp (cluster optimization)
   - Scenario 3: RetailCo (EKS → ROSA comparison)
   - Ready to copy-paste during demo

3. **`03-solution-architect-unified.md`** (Technical design doc)
   - Workflow architecture
   - System prompts for each scenario
   - Implementation notes

4. **`QUICK-START-GUIDE.md`** (This file)
   - Your roadmap to demo success

5. **`01-setup-mystery-scenario.sh`** (Bonus - live troubleshooting demo)
   - Creates realistic cluster issue
   - For "wow" moment demo

---

## Your 30-Minute Prep Checklist

### ☑️ Step 1: Review the Demo Script (10 min)

```bash
cd /Users/flyers/demos/n8n-k8s-mcp-openshift-agent/demo-scripts
open SOLUTION-ARCHITECT-DEMO-SCRIPT.md
```

**Read these sections:**
- Opening Hook (page 1)
- Act 2: The Workflow Demo (pages 3-6)
- The Close (page 7)

**Memorize these talking points:**
- "Gemini analyzes what you give it. This analyzes what's actually there."
- "2 days of research → 2 minutes automated"
- "Which approach scales when you manage 15 customer clusters?"

### ☑️ Step 2: Setup n8n Workflow (15 min)

**Open n8n:**
```bash
# Your ROSA-deployed n8n instance:
open https://n8n-n8n.apps.rosa.nddemo.gune.p3.openshiftapps.com
```

**In n8n (first time setup):**

1. **Install MCP Client node** (Required - Community Node)
   - Settings → Community Nodes
   - Click "Install a community node"
   - Enter: `@n8n/n8n-nodes-langchain`
   - Click "Install" and wait ~30 seconds
   - Refresh page

2. **Add OpenAI credential**
   - Settings → Credentials → Add Credential
   - Search: "OpenAI"
   - Paste your API key
   - Save

3. **Import workflow**
   - Click "+" → Add workflow
   - "..." menu → Import from file
   - Select: `workflows/02-discovery-architect-openai.json`

4. **Configure workflow**
   - Click "OpenAI GPT-4" node → Select your credential
   - Click "MCP Client (Kubernetes)" node → Verify URL: `http://kubernetes-mcp-server.openshift-mcp-server.svc.cluster.local:8080/sse`
   - Save workflow

5. **Test**
   - Click "Test workflow"
   - In chat: "List all namespaces"
   - Verify it responds in ~10 seconds with real cluster data

**If it doesn't work:**
- Verify MCP server: `oc get pods -n openshift-mcp-server`
- Check OpenAI API key is valid
- See main README.md troubleshooting section

### ☑️ Step 3: Prep Your Inputs (10 min)

```bash
open SAMPLE-INPUTS.md
```

**Copy these to clipboard manager (or separate text file):**
1. Scenario 1 input (Acme Financial - starts at line 15)
2. Scenario 2 input (TechCorp - starts at line ~450)
3. Scenario 3 input (RetailCo - starts at line ~780)

**Pro tip:** Use an app like Paste (macOS) or Ditto (Windows) to manage multiple clipboard items.

---

## Day-of-Demo Checklist (5 minutes before)

### ✅ Technical Setup

```bash
# 1. Verify MCP server
curl http://localhost:8081/healthz
# Should return: {"status":"ok"}

# 2. Open required tabs:
open http://localhost:5678  # n8n
open https://gemini.google.com  # For comparison

# 3. Test workflow
# In n8n chat: "List all namespaces" (or any simple query)
# Should respond in ~10 seconds

# 4. Have backup ready
open SOLUTION-ARCHITECT-DEMO-SCRIPT.md
# Scroll to "Backup Plan" section (page 14)
```
---

## The Demo Flow

### The Workflow Demos

**Scenario 1: Proposal (2 min)**
1. Switch to n8n
2. Paste same Scenario 1 input
3. Query: `"Create a comprehensive ROSA proposal for this customer"`
4. Narrate while it works (~45 sec):
   - "Analyzing requirements..."
   - "Fetching current ROSA pricing..."
   - "Designing architecture..."
   - "Calculating costs..."
5. Show output - point to specific sections:
   - ✅ Mermaid diagram
   - ✅ Current pricing ($15,920/month)
   - ✅ 90-day plan
   - ✅ ROI analysis

**Scenario 2: Optimization (2 min)**
1. Paste Scenario 2 input (TechCorp)
2. Query: `"Analyze this cluster and provide optimization recommendations"`
3. Narrate (~30 sec):
   - "Querying live cluster via MCP..."
   - "Checking resource limits..."
   - "Comparing against best practices..."
4. Show output:
   - 🔴 Critical issues (specific pods, specific problems)
   - 💰 Cost savings potential ($2,800/month)
   - 📋 Exact `oc` commands to fix

**Scenario 3: EKS Comparison (2 min)**
1. Paste Scenario 3 input (RetailCo)
2. Query: `"Compare this EKS setup to ROSA and provide migration analysis"`
3. Narrate (~45 sec):
   - "Analyzing current EKS costs..."
   - "Designing equivalent ROSA architecture..."
   - "Building feature comparison..."
4. Show output:
   - 📊 Cost comparison (EKS $9.5k/mo → ROSA $11.2k/mo infrastructure)
   - 📊 BUT total cost lower with ROSA (operational savings)
   - ✅ Fair comparison (shows where ROSA is more expensive)
   - 📋 8-week migration plan

## Troubleshooting

### If Workflow Doesn't Respond:

```bash
# Check MCP server
curl http://localhost:8081/healthz

# Restart if needed
pkill -f kubernetes-mcp-server
./scripts/quick-demo-setup.sh

# Check n8n execution logs
# n8n UI → Executions → Click failed execution
```

### If Response is Generic (Not Using Live Data):

**Do:**
1. Verify MCP Client node is connected to AI Agent
2. Check connection line in workflow (should be `ai_tool` type)
3. Re-run with explicit instruction: `"Query the live cluster first"`

### If Everything Breaks:

**Have these ready:**
- Screenshots of each scenario output
- This demo script (read the outputs verbatim)

**Say:**
> "Let me show you what the output looks like while we debug..."

[Show screenshots]


## Resources

### Documentation:
- **Main guide:** [SOLUTION-ARCHITECT-DEMO-SCRIPT.md](SOLUTION-ARCHITECT-DEMO-SCRIPT.md)
- **Sample inputs:** [SAMPLE-INPUTS.md](SAMPLE-INPUTS.md)
- **Technical design:** [03-solution-architect-unified.md](../workflows/03-solution-architect-unified.md)
- **Troubleshooting:** [../docs/troubleshooting.md](../docs/troubleshooting.md)

### Quick Commands:

```bash
# Start MCP server
cd /Users/flyers/demos/n8n-k8s-mcp-openshift-agent
./scripts/quick-demo-setup.sh

# Test MCP health
curl http://localhost:8081/healthz

# Open n8n
open http://localhost:5678

# Check MCP server logs
tail -f /tmp/mcp-server.log

# Stop MCP server
pkill -f kubernetes-mcp-server
```

---


