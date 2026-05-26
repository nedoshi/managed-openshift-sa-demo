# Solution Architect Agent - Complete Demo Script

**Audience:** OpenShift Black Belts  
**Duration:** 12 minutes  
**Goal:** Show how this beats Gemini for real SA work  

---

## Pre-Demo Setup (5 minutes before)

```bash
# 1. Start MCP server (if doing Scenario 2)
cd /Users/flyers/demos/n8n-k8s-mcp-openshift-agent
./scripts/quick-demo-setup.sh

# 2. Open tabs:
# - Tab 1: n8n workflow (http://localhost:5678)
# - Tab 2: Google Gemini (https://gemini.google.com)
# - Tab 3: This demo script

# 3. Copy sample inputs to clipboard manager:
# - Scenario 1 input (discovery notes)
# - Scenario 2 input (optimization request)
# - Scenario 3 input (EKS comparison)

# 4. Test workflow with simple query:
# "What are the three scenarios you can help with?"
```

---

## Opening Hook (1 minute)

**Say this verbatim:**

> "Quick question: How long does it take you to create a ROSA proposal after a discovery call?"
>
> [Wait for answers - typical: "2-3 days"]
>
> "Right. Two to three days of research, architecture design, cost calculations, best practices validation."
>
> "What if I told you this workflow can do it in 2 minutes? And not just proposals - also cluster optimization reports and competitive migration analyses."
>
> "Let me show you three scenarios we face every week, and compare Gemini vs. this workflow."

---

## Act 1: The Gemini Baseline (3 minutes)

### Scenario 1: Discovery to Proposal (Gemini approach)

**Say:**
> "Scenario 1 is the most common: Customer had a discovery call, needs a proposal by Monday. Let me show you the Gemini approach."

**Do:**

1. **Switch to Gemini tab**

2. **Paste Scenario 1 input** (discovery notes)

3. **Add this prompt:**
   ```
   Based on these discovery notes, create a ROSA architecture 
   proposal including:
   - Technical architecture
   - Cost estimate
   - Implementation timeline
   - Value proposition
   ```

4. **Wait for response** (15-20 seconds)

5. **Point out the problems:**

**Say while Gemini is responding:**
> "Gemini is great for generic advice, but watch what it CAN'T do:
> - ❌ No real-time ROSA pricing (it's using training data from 2024)
> - ❌ No validation against current ROSA versions
> - ❌ No integration with best practices docs
> - ❌ Generic architecture (doesn't consider regional differences)
> - ❌ No cost breakdown (just estimates)"

6. **Show the Gemini output**

**Say:**
> "This is decent generic advice. But as a Black Belt, you know you'd spend another 2 days:
> - Validating current pricing
> - Checking latest ROSA features
> - Customizing for this specific customer
> - Adding real cost calculations
> - Building the Mermaid diagrams
>
> That's the 2-3 day reality."

---

## Act 2: The Workflow Demo (6 minutes)

**Say:**
> "Now watch what happens with the workflow. Same discovery notes, but the workflow has access to:
> - Real-time ROSA pricing
> - Current OpenShift documentation
> - Best practices templates
> - And for existing clusters, live cluster data via MCP"

### Scenario 1: Discovery to Proposal (Workflow)

1. **Switch to n8n tab**

2. **Open chat interface**

3. **Paste the same discovery notes**

4. **Add query:**
   ```
   Create a comprehensive ROSA proposal for this customer
   ```

5. **Narrate while it works** (~45 seconds):

**Say:**
> "Watch what it's doing:
> 1. Analyzing requirements (PCI-DSS, multi-AZ, scale)
> 2. Fetching current ROSA pricing for us-east-1
> 3. Designing architecture based on best practices
> 4. Calculating node sizing (8 vCPU pods → m5.2xlarge recommended)
> 5. Generating cost breakdown
> 6. Creating implementation timeline
> 7. Building value proposition vs. alternatives"

6. **Show the output**

**Point to specific sections:**
> "Look at this:
> - ✅ Detailed architecture with Mermaid diagram
> - ✅ Current ROSA pricing ($15,920/month for this workload)
> - ✅ Cost breakdown (control plane, workers, support, DR)
> - ✅ 90-day implementation plan
> - ✅ ROI analysis (within their $80k budget)
> - ✅ Risk mitigation strategies
> - ✅ PCI-DSS compliance considerations
>
> This is customer-ready. Not a draft. Ready to send."

**The punchline:**
> "Gemini: 20 seconds for generic advice, then 2 days of your work.
> This: 45 seconds for a complete, accurate, current proposal.
>
> That's the difference."

---

### Scenario 2: Post-Sales Optimization (Workflow)

**Say:**
> "Scenario 2: Existing customer says 'optimize my cluster.' This is where it gets interesting because we can query their live cluster."

1. **Paste Scenario 2 input** (optimization request)

2. **Query:**
   ```
   Analyze this cluster and provide optimization recommendations
   ```

3. **Narrate** (~30 seconds):

**Say:**
> "Now it's:
> 1. Querying the live cluster via MCP
> 2. Checking pod resource limits (finding gaps)
> 3. Analyzing node utilization
> 4. Scanning for security issues (pods without limits)
> 5. Comparing against OpenShift best practices
> 6. Calculating potential cost savings
>
> Gemini can't do this. It can't access their cluster."

4. **Show the output**

**Point out:**
> "Look at the findings:
> - 🔴 Critical: 15 pods without resource limits (OOM risk)
> - 🔴 Critical: Running OpenShift 4.12 (EOL in 2 months)
> - 🟡 Cost: Over-provisioned nodes (40% idle capacity)
> - 🟡 Security: No ResourceQuotas (namespace isolation risk)
>
> It's giving SPECIFIC findings from THEIR cluster, not generic advice.
>
> And the recommendations:
> - Exact oc commands to fix issues
> - Cost impact: Save $2,800/month by right-sizing
> - Implementation plan prioritized by risk
>
> This took 30 seconds. Manual audit? 4-6 hours."

---

### Scenario 3: EKS to ROSA Competitive Analysis (Workflow)

**Say:**
> "Scenario 3: Customer on EKS, considering ROSA. They want an objective comparison. This is the hardest one manually."

1. **Paste Scenario 3 input** (EKS setup)

2. **Query:**
   ```
   Compare this EKS setup to ROSA and provide migration analysis
   ```

3. **Narrate** (~45 seconds):

**Say:**
> "This is complex:
> 1. Analyzing current EKS costs ($9,536/month)
> 2. Designing equivalent ROSA architecture
> 3. Calculating ROSA costs (apples-to-apples)
> 4. Building feature comparison matrix
> 5. Assessing migration complexity
> 6. Creating migration timeline
> 7. Calculating TCO over 3 years
>
> You could do this in Excel over 2 days. Or..."

4. **Show the output**

**Point out key sections:**
> "Cost comparison:
> - EKS: $9,536/month
> - ROSA: $11,200/month (17% higher)
>
> But wait - look at the TOTAL cost:
> - EKS: $9,536 + 2 engineers @ 50% = $25,536/month equivalent
> - ROSA: $11,200 + 2 engineers @ 20% = $15,200/month equivalent
>
> ROSA actually saves $10k/month when you include operational overhead.
>
> Feature matrix:
> - Shows where ROSA wins (integrated tools, operators, console)
> - Shows where it's equivalent (control plane, scaling)
> - Fair comparison (not marketing fluff)
>
> Migration plan:
> - 8-week timeline
> - Phased approach (3 waves)
> - Risk assessment per component
>
> This is a complete business case. Ready for their CFO."

---

## Act 3: The Comparison (2 minutes)

**Show this table on screen:**

| Task | Gemini Notebook | This Workflow | Your Time Saved |
|------|----------------|---------------|-----------------|
| **Scenario 1: Proposal** | Generic template (20 sec) + Your research (2 days) | Complete proposal (45 sec) | 2 days → 1 minute |
| **Scenario 2: Optimization** | Can't access cluster. Manual audit required (4-6 hours) | Live cluster analysis (30 sec) | 6 hours → 30 seconds |
| **Scenario 3: EKS Comparison** | Generic comparison (30 sec) + Your cost research (1 day) | Complete analysis (45 sec) | 1 day → 1 minute |

**Say:**
> "Here's the math:
> - You do 10 proposals a month → Save 20 days
> - You do 5 cluster audits a month → Save 30 hours  
> - You do 3 competitive analyses a month → Save 3 days
>
> That's 23+ days per month back.
>
> What could you do with an extra month per quarter?"

---

## Addressing Objections (Built into the demo)

### Objection 1: "Gemini can do cost analysis too"

**Your response (point to screen):**
> "Yes, but with stale data. Look - this workflow just fetched ROSA pricing from this month. Gemini's training data is from early 2025. Pricing changes quarterly. Would you send a customer a proposal with 6-month-old pricing?"

### Objection 2: "I can paste cluster data into Gemini"

**Your response:**
> "Sure. But first you run 20+ kubectl commands, copy each output, paste them all into Gemini, then correlate the findings yourself. This did that in 30 seconds. Which approach scales when you manage 15 customer clusters?"

### Objection 3: "Too complex to set up"

**Your response:**
> "Watch."
>
> [Run quick-demo-setup.sh on screen - takes 2 minutes]
>
> "Two minutes. One script. That's the setup. Then you have this forever."

### Objection 4: "What about security? Sending customer data to Claude?"

**Your response:**
> "Great question. Three options:
> 1. Use Azure OpenAI instead (data residency in EU if needed)
> 2. Use Ollama (100% on-prem, zero data leaves your laptop)
> 3. Redact sensitive data before sending (the workflow can do this)
>
> For demos, Claude is fine. For production, we have options."

### Objection 5: "What if the recommendations are wrong?"

**Your response:**
> "Look at the output - it shows its work. You see:
> - What data it gathered
> - What calculations it made
> - What assumptions it used
>
> You validate like any other tool. But it's giving you a 95% complete draft instead of a blank page. You're editing, not creating from scratch."

---

## The Close (1 minute)

**Say:**
> "So here's the reality:
>
> **Gemini Notebook:**
> - Great for brainstorming
> - Great for learning
> - Great for generic questions
> - But it's static. It analyzes what you give it.
>
> **This Workflow:**
> - Analyzes what's actually there (live clusters)
> - Uses current data (real-time pricing)
> - Generates customer-ready deliverables
> - Scales to 100 customers
>
> Gemini is a tool for thinking.
> This is a tool for doing.
>
> Different jobs.
>
> Questions?"

---

## Expected Questions & Answers

### Q: "Can I customize the output format?"

**A:**
> "Yes. The workflow uses templates. You can:
> - Add your company branding
> - Change the architecture patterns
> - Adjust cost assumptions
> - Add your preferred tools/operators
>
> It's all in the workflow config. I'll show you after the demo."

### Q: "What about multi-cluster scenarios?"

**A:**
> "Great idea. We could add a Scenario 4:
> - Input: List of customer clusters
> - Output: Fleet analysis (which clusters are non-compliant, which are over-provisioned)
>
> The MCP server can query multiple kubeconfigs. Want me to build that?"

### Q: "How often does pricing data update?"

**A:**
> "Currently: We fetch it live each time from AWS/Azure pricing pages.
> Future enhancement: Cache it for 24 hours, refresh automatically.
>
> But the key is: It's always more current than Gemini's training data."

### Q: "Does it work with ARO (Azure)?"

**A:**
> "Yes. Scenario 1 and 2 work identically. Scenario 3 would be 'AKS to ARO' instead of 'EKS to ROSA'. The logic is the same, just different pricing sources."

### Q: "Can it integrate with Salesforce/CRM?"

**A:**
> "Not yet, but n8n has Salesforce nodes. We could:
> - Trigger: New opportunity in Salesforce
> - Action: Generate proposal automatically
> - Update: Attach proposal to Salesforce opportunity
>
> That's a 2-hour build. Want it?"

### Q: "What about customers with hybrid (on-prem + cloud)?"

**A:**
> "We'd need to add:
> - On-prem cost data (you'd provide your internal pricing)
> - Hybrid architecture templates
> - Network connectivity analysis (latency, bandwidth)
>
> But the structure is the same. Another scenario variant."

---

## Success Indicators

**You've won when they say:**
- ✅ "When can I get access to this?"
- ✅ "Can you add [specific customer scenario]?"
- ✅ "This would have saved me 3 days last week on [deal]"
- ✅ "How do we roll this out to the whole SA team?"

**You've lost when they say:**
- ❌ "Seems like overkill for what I need"
- ❌ "I'll just stick with Gemini"
- ❌ "Too complicated to maintain"

**If losing, pivot to:**
> "Fair enough. Let me show you just Scenario 2 (cluster optimization). That one's pure ROI - 6 hours of manual work → 30 seconds. Even if you only use that, worth it?"

---

## Post-Demo Next Steps

### Immediate (End of meeting)

1. **Share the workflow JSON**
   ```
   "I'll send you:
   - The workflow file (import into n8n)
   - Setup instructions (5 minutes)
   - Sample inputs (so you can test)
   - This demo script
   
   Who wants to be in the beta group?"
   ```

2. **Schedule enablement session**
   ```
   "I'm doing a hands-on workshop next week:
   - Build your first custom scenario
   - Customize outputs for your customers
   - Add your own architecture templates
   
   Who's in?"
   ```

3. **Create Slack channel**
   ```
   "Let's create #openshift-sa-agent for:
   - Sharing scenarios
   - Best practices
   - Custom templates
   - Success stories
   
   I'll post the invite."
   ```

### Short-term (This week)

1. **Collect feedback**
   - What scenarios are missing?
   - What output formats do they want?
   - What integrations matter?

2. **Build requested features**
   - Prioritize by impact
   - Ship updates weekly

3. **Track metrics**
   - How many SAs adopted it?
   - How many proposals generated?
   - Time savings (self-reported)

### Long-term (This quarter)

1. **Scale to organization**
   - Training materials
   - Best practices guide
   - Template library

2. **Integrate with existing tools**
   - Salesforce
   - Confluence
   - ServiceNow

3. **Measure business impact**
   - Faster sales cycles
   - Higher win rates
   - Better customer satisfaction (post-sales)

---

## Demo Troubleshooting

### If Workflow Doesn't Respond

**Do:**
1. Check MCP server: `curl http://localhost:8081/healthz`
2. Restart workflow in n8n (Stop → Start)
3. Check n8n execution log for errors

**Say:**
> "Technical hiccup. Let me show you the sample output I generated earlier while that restarts."

[Have screenshots ready as backup]

### If Response is Generic (Not Using Live Data)

**Do:**
1. Check workflow configuration (is MCP connected?)
2. Re-run query with explicit instruction: "Query the live cluster"

**Say:**
> "Looks like it's in generic mode. Let me force it to use the live cluster data..."

### If Cost Numbers Seem Off

**Do:**
1. Show where the data comes from (pricing page)
2. Explain assumptions (region, commitment, support tier)

**Say:**
> "These are list prices for us-east-1 with standard support. Real customer pricing varies with EDP agreements, RIs, etc. But this gives the right order of magnitude for proposals."

---

## Backup Plan (If Everything Breaks)

**Have these ready:**

1. **Screenshots** of each scenario output
2. **Pre-recorded demo video** (3 minutes)
3. **PDF samples** of each deliverable

**Pivot to:**
> "Let me show you what the output looks like, then we can debug the live demo after."

[Show screenshots]

> "These are real outputs. We can troubleshoot the live demo later, but you get the idea of what it generates."

---

## Timing Breakdown

| Section | Time | Notes |
|---------|------|-------|
| Opening hook | 1 min | Get them interested |
| Gemini baseline | 3 min | Show the problem |
| Scenario 1 demo | 2 min | Discovery → Proposal |
| Scenario 2 demo | 2 min | Cluster optimization |
| Scenario 3 demo | 2 min | EKS comparison |
| Comparison table | 1 min | Quantify the value |
| Close + Q&A | 3 min | Seal the deal |
| **Total** | **14 min** | (Buffer: 2 min) |

**Adjust based on audience:**
- If short on time: Skip Scenario 2, focus on 1 & 3
- If technical audience: Spend more time on MCP integration
- If business audience: Spend more time on ROI numbers

---

## Final Checklist

**Before Demo:**
- [ ] MCP server running
- [ ] n8n workflow tested with all 3 scenarios
- [ ] Sample inputs in clipboard manager
- [ ] Gemini tab open
- [ ] Backup screenshots ready
- [ ] This script printed or on second monitor

**During Demo:**
- [ ] Speak slowly (don't rush the "wow" moments)
- [ ] Pause for questions (engagement > speed)
- [ ] Show your work (let them see the agent thinking)
- [ ] Quantify savings (always tie to business value)

**After Demo:**
- [ ] Send follow-up email within 1 hour
- [ ] Include all promised materials
- [ ] Schedule enablement session
- [ ] Track who's adopting

---

**Remember:** This demo is not about showing off AI. It's about showing Black Belts how to **get their time back**. Every minute saved on proposals is a minute they can spend selling, building relationships, or solving harder problems.

**Make it personal:**
> "Think about the last proposal you did. How long did it take? What if you had that time back?"

That's how you win.

🚀 **Go crush this demo!**
