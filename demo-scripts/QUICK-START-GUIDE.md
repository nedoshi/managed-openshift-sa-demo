# Quick Start: Solution Architect Agent Demo

**Goal:** Present compelling demo to OpenShift Black Belts in 15 minutes  
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

### Why This Beats "Just Use Gemini":

| Feature | Gemini Notebook | This Workflow |
|---------|-----------------|---------------|
| **Live cluster access** | ❌ Can't query clusters | ✅ MCP integration |
| **Current pricing** | ❌ Training data (stale) | ✅ Real-time APIs |
| **Specific recommendations** | ❌ Generic advice | ✅ Cluster-specific fixes |
| **Time to deliverable** | 2-3 days of your work | 2 minutes automated |
| **Customer-ready output** | ❌ Draft you must polish | ✅ Ready to send |

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

### ✅ Physical Setup

- [ ] **Two monitors** (or laptop + external screen)
  - Monitor 1: n8n + Gemini (switch between tabs)
  - Monitor 2: Demo script (this is your cheat sheet)
  
- [ ] **Clipboard manager** with all 3 sample inputs ready

- [ ] **Water** nearby (you'll be talking for 15 minutes)

- [ ] **Phone on silent** (obvious but important)

---

## The 12-Minute Demo Flow

### Minutes 1-3: The Hook + Gemini Baseline

**Say:**
> "How long does it take you to create a ROSA proposal after a discovery call?"
> 
> [Wait for answers: "2-3 days"]
>
> "Let me show you the Gemini approach first, then this workflow."

**Do:**
1. Switch to Gemini tab
2. Paste Scenario 1 input (Acme Financial)
3. Add prompt: "Create a ROSA proposal based on these notes"
4. While waiting, point out what Gemini CAN'T do:
   - ❌ No real-time pricing
   - ❌ No validation against current ROSA versions
   - ❌ Generic architecture
5. Show Gemini output (it's decent but generic)

**Key line:**
> "This is a good start. But you'd spend 2 more days validating pricing, customizing architecture, adding real cost calculations. That's the reality."

### Minutes 4-10: The Workflow Demos

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

**Key line:**
> "Gemini can't do this. It can't access their cluster. This gives SPECIFIC findings from THEIR actual environment, not generic advice."

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

**Key line:**
> "Notice it's HONEST about costs. ROSA infrastructure is 17% higher, but total cost is lower when you include operational overhead. This is a business case for their CFO, not a sales pitch."

### Minutes 11-12: The Close

**Show this table:**

| Task | Gemini | This Workflow | Time Saved |
|------|--------|---------------|------------|
| Proposal | 20 sec + 2 days | 45 sec total | 2 days |
| Optimization | Can't access cluster | 30 sec | 6 hours |
| EKS Comparison | 30 sec + 1 day | 45 sec total | 1 day |

**Say:**
> "Here's the math:
> - 10 proposals/month → Save 20 days
> - 5 cluster audits/month → Save 30 hours
> - 3 competitive analyses/month → Save 3 days
>
> That's 23+ days per month back. What could you do with an extra month per quarter?"

**The final line:**
> "Gemini is a tool for thinking. This is a tool for doing. Different jobs.
>
> Questions?"

---

## Addressing the Top 3 Objections

### Objection 1: "I can paste cluster data into Gemini"

**Your response:**
> "Sure. But first you run 20+ kubectl commands, copy each output, paste them all. This did that in 30 seconds. Which scales when you manage 15 customer clusters?"

### Objection 2: "Too complex to set up"

**Your response:**
> "Watch."
> [Run `./scripts/quick-demo-setup.sh` on screen - takes 2 min]
> "Two minutes. One script. That's the setup."

### Objection 3: "What if recommendations are wrong?"

**Your response:**
> "Look at the output - it shows its work. You see what data it gathered, what calculations it made. You validate like any other tool. But it's giving you a 95% complete draft instead of a blank page."

---

## What Happens After the Demo

### Immediate Next Steps:

1. **Share the files:**
   ```bash
   # Package everything
   cd /Users/flyers/demos/n8n-k8s-mcp-openshift-agent
   zip -r solution-architect-demo.zip \
     demo-scripts/ \
     workflows/02-discovery-architect*.json \
     scripts/quick-demo-setup.sh \
     docs/sample-queries.md
   
   # Send to team with subject:
   # "Solution Architect Agent - Demo Files"
   ```

2. **Schedule enablement session:**
   > "I'm doing a hands-on workshop next week where you'll:
   > - Import the workflow into your n8n
   > - Run it against your demo cluster
   > - Customize it for your customer scenarios
   >
   > Who's in?"

3. **Create Slack channel:**
   > "#openshift-sa-agent for sharing scenarios and templates"

### Within 1 Week:

**Collect feedback:**
- What scenarios are they asking for?
- What output formats do they want?
- What integrations matter (Salesforce, Confluence)?

**Build Scenario 4+:**
Based on feedback, add:
- Multi-cluster fleet analysis
- Compliance gap assessment (HIPAA, FedRAMP, PCI-DSS)
- Cost optimization deep-dive
- Disaster recovery planning

---

## Success Metrics

### You've Won When They Say:

- ✅ "When can I get access to this?"
- ✅ "Can you add [specific scenario]?"
- ✅ "This would have saved me 3 days last week"
- ✅ "How do we roll this out to the whole team?"

### You've Lost When They Say:

- ❌ "Seems like overkill"
- ❌ "I'll just stick with Gemini"
- ❌ "Too complicated to maintain"

**If losing, pivot to:**
> "Fair enough. Let me show you just Scenario 2 (cluster optimization). Even if you only use that, it's 6 hours of manual work → 30 seconds. Worth it?"

---

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

---

## Next Steps for You

### Today (30 minutes):

- [  ] Read `SOLUTION-ARCHITECT-DEMO-SCRIPT.md` (pages 1-7)
- [ ] Test existing workflow with simple query
- [ ] Copy sample inputs to clipboard manager

### Tomorrow (1 hour):

- [ ] Practice demo flow (time yourself, aim for 12 min)
- [ ] Customize Scenario 1 input with your customer data
- [ ] Record yourself (phone video) - watch for pacing

### This Week (2 hours):

- [ ] Run full demo for 1-2 friendly colleagues
- [ ] Get feedback, iterate
- [ ] Prepare backup (screenshots, pre-recorded video)

### Next Week:

- [ ] **DEMO TO BLACK BELTS** 🚀
- [ ] Collect feedback
- [ ] Schedule enablement session
- [ ] Start building custom scenarios

---

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

## The One-Sentence Pitch

**If they ask you to summarize in one sentence:**

> "This workflow does in 2 minutes what takes you 2 days with Gemini: analyzing live clusters, fetching current pricing, and generating customer-ready proposals."

---

## Final Advice

### Do's:
- ✅ **Speak slowly** - let the "wow" moments land
- ✅ **Pause for questions** - engagement beats speed
- ✅ **Show your work** - let them see the agent thinking
- ✅ **Quantify savings** - always tie to business value

### Don'ts:
- ❌ **Don't rush** - you have 12 minutes, use them
- ❌ **Don't skip Scenario 2** - that's the MCP showcase
- ❌ **Don't oversell** - let the demo speak for itself
- ❌ **Don't say "AI is smart"** - say "you get time back"

### Remember:
This demo is not about showing off AI. It's about showing Black Belts how to **get their time back** so they can sell more, build better relationships, and solve harder problems.

Make it personal:
> "Think about the last proposal you did. How long did it take? What if you had that time back?"

---

## You're Ready! 🚀

**You have:**
- ✅ Three compelling scenarios
- ✅ Complete demo script with talking points
- ✅ Realistic sample inputs ready to paste
- ✅ Objection handlers prepared
- ✅ Technical setup tested

**Now go:**
1. Practice once
2. Demo to 1-2 friendly colleagues  
3. Iterate
4. **Crush the Black Belts demo**

---

**Questions? Issues? Feedback?**

Review the demo script or check troubleshooting.md.

**Good luck!** 🎯
