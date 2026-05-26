# Solution Architect Agent - Demo Package

**Created:** May 21, 2026  
**Purpose:** Optimizing OpenShift Architecture Workflows Beyond Gemini Notebook
**Audience:** Solution Architects

---

## What's In This Package

### 🎯 Start Here:
**[QUICK-START-GUIDE.md](QUICK-START-GUIDE.md)** - Your 30-minute roadmap to demo success

### 📋 Complete Demo Materials:

1. **[SOLUTION-ARCHITECT-DEMO-SCRIPT.md](SOLUTION-ARCHITECT-DEMO-SCRIPT.md)** (12 pages)
   - Minute-by-minute demo script (12 minutes total)
   - Exact talking points for each scenario
   - Objection handling guide
   - Q&A preparation

2. **[SAMPLE-INPUTS.md](SAMPLE-INPUTS.md)** (18 pages)
   - **Scenario 1:** Acme Financial (pre-sales discovery → proposal)
   - **Scenario 2:** TechCorp (cluster optimization for existing customer)
   - **Scenario 3:** RetailCo (EKS → ROSA competitive analysis)
   - Ready to copy-paste during live demo

3. **[03-solution-architect-unified.md](../workflows/03-solution-architect-unified.md)** (Technical design)
   - Workflow architecture details
   - System prompts for each scenario
   - Implementation notes
   - Future enhancements

---

## The Three Scenarios

### Why These Beat Gemini:

| Scenario | What It Does | Why Gemini Can't | Demo Time |
|----------|--------------|------------------|-----------|
| **1. Pre-Sales Proposal** | Discovery notes → Complete ROSA proposal (architecture + costs + timeline) | ❌ No real-time pricing<br>❌ Can't validate capacity | 2 min |
| **2. Post-Sales Optimization** | Live cluster analysis → Specific recommendations + cost savings | ❌ Can't query clusters<br>❌ Can't analyze actual usage | 2 min |
| **3. EKS → ROSA Comparison** | Current EKS setup → Fair comparison + migration plan + ROI | ❌ No EKS pricing access<br>❌ Can't validate features | 2 min |

---

## Quick Start (30 Minutes)

### Step 1: Read the Demo Script (10 min)
```bash
open SOLUTION-ARCHITECT-DEMO-SCRIPT.md
```
Focus on:
- Opening Hook (page 1)
- Act 2: Workflow Demos (pages 3-6)
- The Close (page 7)

### Step 2: Test Existing Workflow (10 min)
```bash
# Start MCP server
cd /Users/flyers/demos/n8n-k8s-mcp-openshift-agent
./scripts/quick-demo-setup.sh

# Open n8n
open http://localhost:5678

# Import workflow: workflows/02-discovery-architect.json
# Test with: "What are OpenShift operators?"
```

### Step 3: Prep Sample Inputs (10 min)
```bash
open SAMPLE-INPUTS.md
```
Copy these to clipboard manager:
1. Scenario 1: Lines 15-450 (Acme Financial)
2. Scenario 2: Lines 450-780 (TechCorp)
3. Scenario 3: Lines 780-end (RetailCo)

---

## The Value Proposition

### Current State (with Gemini):
- **Proposal creation:** 20 seconds for generic template + 2 days of your research
- **Cluster optimization:** Can't access clusters, manual audit required (4-6 hours)
- **Competitive analysis:** 30 seconds for generic comparison + 1 day of cost research

### With This Workflow:
- **Proposal creation:** 45 seconds total (complete, customer-ready)
- **Cluster optimization:** 30 seconds (live cluster analysis via MCP)
- **Competitive analysis:** 45 seconds total (fair comparison with real data)

### ROI for Black Belts:
- 10 proposals/month → Save **20 days**
- 5 cluster audits/month → Save **30 hours**
- 3 competitive analyses/month → Save **3 days**

**Total: 23+ days per month back = 1 extra month per quarter**

---

## What Makes This Different

### vs. Gemini Notebook:

**Gemini is great for:**
- ✅ Brainstorming
- ✅ Learning concepts
- ✅ Generic questions
- ✅ Static analysis

**This workflow is for:**
- ✅ Live cluster analysis (MCP integration)
- ✅ Real-time pricing (API access)
- ✅ Customer-ready deliverables
- ✅ Scaling to 100 customers

**Key insight:**
> "Gemini analyzes what you give it.  
> This analyzes what's actually there."

---

## Demo Flow (12 Minutes)

### Opening (1 min)
> "How long does it take you to create a ROSA proposal?  
> [2-3 days]  
> What if I told you this workflow can do it in 2 minutes?"

### Act 1: Gemini Baseline (3 min)
- Show Gemini approach (paste discovery notes, get generic output)
- Point out limitations (no real-time pricing, generic advice)

### Act 2: Workflow Demos (6 min)
- **Scenario 1:** Discovery → Proposal (2 min)
- **Scenario 2:** Cluster → Optimization (2 min)
- **Scenario 3:** EKS → ROSA Comparison (2 min)

### Close (2 min)
- Show comparison table (time savings)
- **"Gemini is a tool for thinking. This is a tool for doing."**
- Q&A

---

## Key Talking Points (Memorize These)

1. **"Gemini analyzes snapshots. This analyzes live state."**

2. **"2 days of research → 2 minutes automated"**

3. **"Which approach scales when you manage 15 customer clusters?"**

4. **"It shows its work - you validate like any other tool. But you're editing a 95% complete draft, not starting from scratch."**

5. **"23+ days per month back. What could you do with an extra month per quarter?"**

---

## Addressing Objections

### "I can paste cluster data into Gemini"
**Response:** "Sure, but first you run 20+ kubectl commands. This did that in 30 seconds. Which scales?"

### "Too complex to set up"
**Response:** [Run `quick-demo-setup.sh` on screen] "Two minutes. One script."

### "What if recommendations are wrong?"
**Response:** "It shows its work. You validate. But 95% complete draft vs. blank page."

### "Security concerns (sending data to Claude)?"
**Response:** "Three options: Azure OpenAI (data residency), Ollama (100% on-prem), or redact sensitive data."

---

## Success Metrics

### You've Won:
- ✅ "When can I get access?"
- ✅ "Can you add [scenario X]?"
- ✅ "This would have saved me 3 days last week"
- ✅ "How do we roll this out?"

### You've Lost:
- ❌ "Seems like overkill"
- ❌ "I'll just stick with Gemini"
- ❌ "Too complicated"

**If losing:** Pivot to just Scenario 2 (cluster optimization) - pure ROI, undeniable value.

---

## After the Demo

### Immediate (end of meeting):
1. Share workflow files (zip package)
2. Schedule enablement session
3. Create Slack channel (#openshift-sa-agent)

### Short-term (this week):
1. Collect feedback (what scenarios are missing?)
2. Build requested features
3. Track adoption metrics

### Long-term (this quarter):
1. Scale to organization (training, templates)
2. Integrate with existing tools (Salesforce, Confluence)
3. Measure business impact (faster sales cycles, higher win rates)

---

## Files Reference

```
demo-scripts/
├── README.md                              ← You are here
├── QUICK-START-GUIDE.md                   ← Start here (30-min prep)
├── SOLUTION-ARCHITECT-DEMO-SCRIPT.md      ← Complete demo script
├── SAMPLE-INPUTS.md                       ← Copy-paste inputs
└── 01-setup-mystery-scenario.sh           ← Bonus: Live troubleshooting demo

workflows/
└── 03-solution-architect-unified.md       ← Technical design doc

workflows/
└── 02-discovery-architect.json            ← Existing workflow to use
```

---

## Troubleshooting

### MCP Server Not Responding:
```bash
curl http://localhost:8081/healthz
# If fails:
pkill -f kubernetes-mcp-server
./scripts/quick-demo-setup.sh
```

### Workflow Returns Generic Output:
- Check MCP Client node is connected to AI Agent
- Verify connection type is `ai_tool`
- Re-run with explicit instruction: "Query the live cluster"

### Everything Breaks:
- Have screenshots ready (show pre-generated outputs)
- Fall back to reading demo script verbatim
- "Let me show you what the output looks like while we debug..."

---

## Next Steps for You

### Today:
- [ ] Read QUICK-START-GUIDE.md
- [ ] Test workflow with simple query
- [ ] Copy sample inputs to clipboard

### Tomorrow:
- [ ] Practice demo flow (time yourself, aim for 12 min)
- [ ] Customize Scenario 1 with your customer data
- [ ] Record yourself (watch for pacing)

### This Week:
- [ ] Run demo for 1-2 friendly colleagues
- [ ] Get feedback, iterate
- [ ] Prepare backup (screenshots)

### Next Week:
- [ ] **DEMO TO BLACK BELTS** 🚀

---

## Resources

### Documentation:
- [Main Project README](../README.md)
- [Troubleshooting Guide](../docs/troubleshooting.md)
- [Sample Queries](../docs/sample-queries.md)
- [Project Summary](../PROJECT-SUMMARY.md)

### Quick Commands:
```bash
# Start demo environment
./scripts/quick-demo-setup.sh

# Test MCP server
curl http://localhost:8081/healthz

# Open n8n
open http://localhost:5678

# View logs
tail -f /tmp/mcp-server.log
```

---

## The One-Sentence Pitch

> "This workflow does in 2 minutes what takes you 2 days with Gemini: analyzing live clusters, fetching current pricing, and generating customer-ready proposals."

---

## Final Advice

**This demo is not about AI being smart.**

**It's about Solution Architects getting their time back.**

Make it personal:
> "Think about the last proposal you did. How long did it take?  
> What if you had that time back?"

That's how you win.

---

**You're ready! Go crush this demo!** 🚀

---

Questions? Start with [QUICK-START-GUIDE.md](QUICK-START-GUIDE.md) or check [troubleshooting](../docs/troubleshooting.md).
