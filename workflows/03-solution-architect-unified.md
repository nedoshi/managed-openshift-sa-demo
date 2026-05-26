# Solution Architect Agent - Unified Workflow Design

## Overview

A single n8n workflow that intelligently handles three critical Solution Architect scenarios:

1. **Pre-Sales Discovery** → Proposal + Value Prop + Cost Justification
2. **Post-Sales Optimization** → Best Practices + Recommendations  
3. **Competitive Analysis** → EKS/AKS vs. ROSA Comparison

## Workflow Architecture

```
User Input (Discovery Notes)
         ↓
   Scenario Router
   (AI determines which scenario)
         ↓
    ┌────┴────┬────────┐
    ↓         ↓        ↓
Scenario 1  Scenario 2  Scenario 3
(Proposal)  (Optimize)  (Compete)
    ↓         ↓        ↓
Data Gathering Phase
├── Scenario 1: ROSA pricing, best practices docs
├── Scenario 2: Live cluster query (MCP), compliance scan
└── Scenario 3: EKS cost API, ROSA pricing, migration tools
    ↓
  AI Agent Analysis
  (Claude with specialized context per scenario)
    ↓
  Output Generation
  ├── Markdown proposal
  ├── Architecture diagrams (Mermaid)
  ├── Cost comparison tables
  └── Migration/Implementation plan
```

## Scenario Definitions

### Scenario 1: Pre-Sales Discovery → Proposal

**Trigger Indicators:**
- Discovery notes mention "considering OpenShift" or "evaluating platforms"
- No existing OpenShift cluster mentioned
- Focus on requirements gathering, business needs

**Data Sources:**
- ✅ ROSA pricing API (aws.amazon.com/rosa/pricing)
- ✅ ARO pricing calculator
- ✅ OpenShift best practices documentation
- ✅ Red Hat reference architectures
- ❌ No live cluster to query

**Output:**
```markdown
# ROSA Proposal - [Customer Name]

## Executive Summary
[Business value proposition]

## Proposed Architecture
[Mermaid diagram]

## Cost Analysis
- Infrastructure: $X/month
- Support: $Y/month  
- Migration services: $Z one-time
- Total 3-year TCO: $ABC

## Value Proposition
- Reduced operational overhead (quantified)
- Faster time-to-market (use cases)
- Enterprise support (SLAs)
- Security & compliance (certifications)

## Implementation Plan
[90-day migration timeline]

## ROI Analysis
- Current state costs: $X
- ROSA costs: $Y
- Savings: $Z (or time savings if net new)
- Payback period: N months
```

### Scenario 2: Post-Sales Optimization

**Trigger Indicators:**
- Existing ROSA/ARO cluster mentioned
- Request for "optimization" or "best practices"
- Cluster access available

**Data Sources:**
- ✅ Live cluster query via MCP (current state)
- ✅ OpenShift Compliance Operator (if installed)
- ✅ Best practices documentation
- ✅ Resource usage patterns

**Output:**
```markdown
# Cluster Optimization Report - [Cluster Name]

## Current State Analysis
- Cluster version: X.Y.Z
- Node count: N (M node types)
- Resource utilization: CPU X%, Memory Y%
- Installed operators: [list]

## Findings

### 🔴 Critical Issues
1. [Security/compliance gaps]
2. [Resource constraints]
3. [Version/lifecycle issues]

### 🟡 Optimization Opportunities  
1. [Cost savings via right-sizing]
2. [Performance improvements]
3. [Operational efficiency]

### 🟢 Current Best Practices
[What they're doing right]

## Recommendations

### Immediate Actions (Week 1)
1. [High-impact, low-effort fixes]

### Short-term (Month 1)
1. [Important improvements]

### Long-term (Quarter 1)
1. [Strategic enhancements]

## Cost Impact
- Current monthly cost: $X
- Projected savings: $Y (Z% reduction)
- Implementation cost: $A one-time

## Implementation Plan
[Detailed steps with commands]
```

### Scenario 3: EKS/AKS → ROSA Competitive Analysis

**Trigger Indicators:**
- Discovery notes mention "currently on EKS" or "using AKS"
- Request for comparison or migration analysis
- Competition scenario

**Data Sources:**
- ✅ EKS pricing (if provided, or calculate from cluster specs)
- ✅ ROSA pricing
- ✅ Feature comparison matrix
- ✅ Migration complexity assessment
- ✅ (Optional) Live EKS cluster query if MCP supports it

**Output:**
```markdown
# EKS to ROSA Migration Analysis - [Customer Name]

## Current State (EKS)

### Infrastructure
- Cluster: [size, region]
- Nodes: [count, types]
- Add-ons: [list]
- Monthly cost: $X (breakdown)

### Operational Model
- Management overhead: Y engineer-hours/month
- Upgrades: Manual, Z hours/quarter
- Support: AWS Business/Enterprise

## Proposed State (ROSA)

### Infrastructure
- Cluster: [equivalent sizing]
- Nodes: [recommended types]
- Operators: [equivalent to EKS add-ons]
- Monthly cost: $A (breakdown)

### Operational Model
- Management overhead: B engineer-hours/month (C% reduction)
- Upgrades: Automated, D hours/quarter
- Support: Red Hat production support

## Cost Comparison

| Component | EKS (Current) | ROSA (Proposed) | Difference |
|-----------|---------------|-----------------|------------|
| Control plane | $X | $A | +/- $N |
| Worker nodes | $Y | $B | +/- $M |
| Storage | $Z | $C | +/- $P |
| Support | $W | $D | +/- $Q |
| **Total** | **$TOTAL1** | **$TOTAL2** | **+/- $DIFF** |

## Feature Comparison

| Feature | EKS | ROSA | Advantage |
|---------|-----|------|-----------|
| Managed control plane | ✅ | ✅ | Tie |
| Integrated registry | ❌ (ECR separate) | ✅ (Built-in) | ROSA |
| Developer console | ❌ | ✅ | ROSA |
| Operators | ❌ (Helm) | ✅ (OperatorHub) | ROSA |
| Service mesh | Manual install | Operator | ROSA |
| Monitoring | CloudWatch | Integrated | ROSA |
| Security scanning | 3rd party | Integrated | ROSA |
| Multi-cluster mgmt | ❌ | ✅ (ACM) | ROSA |

## Migration Path

### Phase 1: Preparation (Week 1-2)
1. Provision ROSA cluster
2. Install equivalent operators
3. Configure networking (VPC peering)

### Phase 2: Migration (Week 3-6)  
1. Migrate stateless workloads (wave 1)
2. Migrate stateful workloads (wave 2)
3. DNS cutover (per service)

### Phase 3: Optimization (Week 7-8)
1. Remove EKS cluster
2. Optimize ROSA sizing
3. Enable ROSA-specific features

## Risk Analysis

### Low Risk
- [Items with clear migration path]

### Medium Risk
- [Items requiring validation]
- Mitigation: [strategies]

### High Risk
- [Complex dependencies]
- Mitigation: [detailed plan]

## ROI Analysis

### One-Time Costs
- Migration services: $X
- Training: $Y
- Testing: $Z
- **Total**: $A

### Ongoing Savings
- Infrastructure: +/- $M/month
- Operational efficiency: $N/month (time savings)
- **Total**: $P/month

**Payback Period**: Q months

## Why ROSA Over EKS

### Technical Benefits
1. [Integrated features that EKS lacks]
2. [Developer experience advantages]
3. [Enterprise features]

### Business Benefits
1. [Reduced operational burden]
2. [Faster feature delivery]
3. [Better support model]

## Next Steps
1. Validate current EKS costs (detailed audit)
2. POC migration (1 non-critical app)
3. Schedule architecture deep-dive
4. Engage Red Hat migration services
```

## Implementation Strategy

### Workflow Nodes

**1. Chat Trigger**
- Receives discovery notes or query

**2. Scenario Router (AI Agent)**
- Analyzes input text
- Determines which scenario (1, 2, or 3)
- Extracts key entities (customer name, requirements, platform)

**3. Data Gathering Switch**
- **Branch A (Scenario 1):** Fetch ROSA pricing, docs
- **Branch B (Scenario 2):** Query live cluster via MCP
- **Branch C (Scenario 3):** Fetch EKS pricing, feature comparison

**4. AI Analysis Agent**
- Context: Scenario-specific system prompt
- Tools: MCP (if scenario 2), pricing calculator, docs
- Output: Structured analysis

**5. Output Formatter**
- Converts AI output to markdown
- Generates Mermaid diagrams
- Formats tables
- Adds branding/footer

**6. Response to User**
- Displays in chat
- Offers download as .md file

### System Prompts by Scenario

**Scenario 1 Prompt:**
```
You are a Red Hat Solution Architect creating a ROSA proposal.

Context:
- Customer is evaluating managed OpenShift
- No existing cluster (net new opportunity)
- Need business justification + technical architecture

Your task:
1. Analyze discovery notes for requirements
2. Design ROSA architecture that meets needs
3. Calculate costs (infrastructure + support)
4. Build value proposition vs. alternatives
5. Create implementation timeline

Output format: Professional proposal ready for customer review

Focus on:
- Business value (ROI, time-to-market)
- Technical differentiation (vs. self-managed K8s, EKS)
- Risk mitigation (support, SLAs)
- Clear cost breakdown
```

**Scenario 2 Prompt:**
```
You are an OpenShift Site Reliability Architect performing a cluster audit.

Context:
- Customer has existing ROSA/ARO cluster
- Seeking optimization and best practices
- You have live cluster access via MCP tools

Your task:
1. Query cluster for current state
2. Compare against OpenShift best practices
3. Identify security/compliance gaps
4. Find cost optimization opportunities
5. Prioritize recommendations (critical → nice-to-have)

Output format: Technical audit report with actionable recommendations

Focus on:
- Evidence-based findings (not generic advice)
- Specific commands/configs to implement
- Cost impact quantification
- Risk prioritization
```

**Scenario 3 Prompt:**
```
You are a competitive analyst comparing EKS/AKS to ROSA.

Context:
- Customer currently on EKS or AKS
- Evaluating migration to ROSA
- Need objective comparison + migration plan

Your task:
1. Analyze current EKS/AKS setup (from notes or live data)
2. Design equivalent ROSA architecture
3. Compare costs (apples-to-apples)
4. Compare features (highlight ROSA advantages)
5. Create migration plan with risk assessment

Output format: Executive summary + detailed analysis

Focus on:
- Fair comparison (don't oversell)
- Real cost differences (include all factors)
- Migration complexity (be realistic)
- ROSA unique value (operators, integrated tools, support)
```

## Demo Script Integration

### 5-Minute Demo Flow

**Minute 1: Set Context**
```
"As Solution Architects, we face three common scenarios:
1. Net new customer needs a proposal (Scenario 1)
2. Existing customer wants optimization (Scenario 2)  
3. EKS customer considering ROSA (Scenario 3)

Normally, each takes 2-3 days of research and analysis.
Let me show you what happens with this workflow."
```

**Minute 2: Scenario 1 Demo**
```
[Paste discovery notes]
Query: "Create a ROSA proposal for this customer"
[Show output in 45 seconds]
```

**Minute 3: Scenario 2 Demo**
```
Query: "Analyze this cluster and recommend optimizations"
[Show it querying live cluster, finding issues, generating report]
```

**Minute 4: Scenario 3 Demo**
```
[Paste EKS cluster specs]
Query: "Compare this EKS setup to ROSA and provide migration analysis"
[Show cost comparison, feature matrix, migration plan]
```

**Minute 5: The Close**
```
"Three scenarios. Three detailed proposals. Total time: 3 minutes.

With Gemini:
- No live cluster access
- No real-time pricing
- No feature comparison matrix
- Generic migration advice

With this workflow:
- Queries actual clusters
- Fetches current pricing
- Validates against best practices
- Generates customer-ready deliverables

Which one helps you hit quota?"
```

## Sample Inputs

### Scenario 1 Sample Input

```
Discovery Call Notes - Acme Financial Services

Date: 2026-05-21
Company: Acme Financial (Fortune 500)
Attendees: CTO, VP Engineering, Lead Architect

Current State:
- Running 30 Java microservices on VMware vSphere
- 80 VMs total (various sizes)
- PostgreSQL on bare metal (1.5TB database)
- Jenkins for CI/CD
- F5 load balancers
- Palo Alto firewalls

Business Drivers:
- Datacenter exit by Q4 2026 (lease ending)
- Need to reduce infrastructure costs by 30%
- Faster application deployment (currently 2-week release cycles)
- Better disaster recovery (current RPO: 24hrs, want <1hr)

Technical Requirements:
- Multi-AZ deployment (99.95% uptime SLA)
- PCI-DSS compliance (credit card processing)
- Integration with existing Active Directory
- Support for Windows containers (2 .NET apps)
- GitOps workflow preferred
- Service mesh for canary deployments
- Observability (currently using Splunk, want to consolidate)

Scale:
- Peak: 10,000 concurrent users
- Average: 3,000 concurrent users
- Transaction volume: 500,000/day
- Data growth: 200GB/month

Budget:
- Infrastructure: ~$80k/month approved
- Migration services: $200k one-time budget
- Training: $50k

Timeline:
- POC: 30 days
- Pilot (5 apps): 60 days
- Full migration: 6 months
- Datacenter exit: October 2026

Concerns:
- Team has K8s experience but not OpenShift
- Worried about vendor lock-in
- Need 24/7 support (global operations)
- Integration with ServiceNow for ticketing

Competition:
- Also evaluating EKS and AKS
- Leaning towards AWS (already using S3, RDS)
```

### Scenario 2 Sample Input

```
Cluster Optimization Request

Customer: TechCorp
Cluster: production-rosa-east
Access: Full read access available

Request:
"We've been running this ROSA cluster for 6 months. It works but costs 
are higher than expected and we're seeing occasional performance issues. 
Can you review our setup and recommend optimizations?"

Known Issues:
- Some pods occasionally get OOMKilled
- Deployments without resource limits
- Running older OpenShift version (4.12.x)
- No quotas configured
- Multiple namespaces with admin access
- Using default storage class for everything
- No backup strategy implemented

Goals:
- Reduce costs by 20-30% if possible
- Improve reliability
- Better security posture
- Prepare for audit (SOC2)
```

### Scenario 3 Sample Input

```
EKS to ROSA Migration Analysis

Customer: RetailCo
Current Platform: AWS EKS

Current EKS Setup:
- Region: us-east-1
- EKS version: 1.28
- Node groups:
  * app-nodes: 15 × m5.2xlarge (8 vCPU, 32GB RAM)
  * db-nodes: 5 × r5.xlarge (4 vCPU, 32GB RAM)
- Storage: EBS gp3 volumes (5TB total)
- Add-ons:
  * AWS Load Balancer Controller
  * EBS CSI Driver
  * CoreDNS
  * kube-proxy
  * VPC CNI
- External tools:
  * Istio (self-managed via Helm)
  * Prometheus + Grafana (self-managed)
  * Flux CD for GitOps
  * Vault for secrets
  * Datadog for observability

Current Monthly Costs:
- EKS control plane: $216 (3 clusters × $72)
- EC2 instances: $4,320
- EBS storage: $500
- Data transfer: $800
- AWS Support (Business): $1,200
- Datadog: $2,500
- Total: ~$9,536/month

Operational Burden:
- 2 platform engineers (50% time on cluster management)
- Monthly patching: 16 hours
- Quarterly upgrades: 40 hours
- Incident response: ~30 hours/month average

Pain Points:
- Complex upgrade process (requires careful planning)
- Istio maintenance burden (version compatibility issues)
- No integrated developer portal
- Separate tools for monitoring, logging, registry
- Manual certificate management
- No built-in cluster management for multi-cluster

Why Considering ROSA:
- Heard about integrated features (operators, console, registry)
- Want to reduce operational overhead
- Interested in Red Hat support model
- Considering multi-cluster management (ACM)

Questions:
- How does cost compare?
- What's the migration effort?
- Do we lose any EKS features?
- What's the operational overhead reduction?
- Support model comparison?
```

## Technical Implementation Notes

### Pricing Data Sources

**ROSA Pricing:**
- API: Can scrape https://aws.amazon.com/rosa/pricing/
- Or hardcode common instance types (m5.xlarge, etc.)
- Update monthly or use AWS Pricing API

**EKS Pricing:**
- AWS Pricing API
- Or hardcode ($0.10/hour per cluster + EC2 costs)

**Comparison Logic:**
```javascript
// In n8n Function node
const eksMonthly = {
  controlPlane: 72 * numClusters,
  ec2Instances: calculateEC2Cost(nodeGroups),
  storage: calculateEBSCost(volumes),
  dataTransfer: estimateDataTransfer(scale),
  support: supportTier === 'business' ? 1200 : 0
};

const rosaMonthly = {
  controlPlane: 360, // ~$0.50/hr
  workerNodes: calculateWorkerCost(nodeGroups),
  storage: calculateStorageCost(volumes),
  dataTransfer: estimateDataTransfer(scale),
  subscription: calculateROSASubscription(nodes)
};

return {
  eks: Object.values(eksMonthly).reduce((a,b) => a+b, 0),
  rosa: Object.values(rosaMonthly).reduce((a,b) => a+b, 0),
  difference: rosa - eks,
  percentChange: ((rosa - eks) / eks * 100).toFixed(1)
};
```

### MCP Integration for Scenario 2

**Queries to run:**
```javascript
// Get cluster version
kubectl version --short

// Resource usage
kubectl top nodes
kubectl top pods --all-namespaces

// Find pods without resource limits
kubectl get pods --all-namespaces -o json | 
  jq '.items[] | select(.spec.containers[].resources.limits == null)'

// Check for quotas
kubectl get resourcequotas --all-namespaces

// Security checks
kubectl get pods --all-namespaces -o json |
  jq '.items[] | select(.spec.securityContext.runAsUser == 0)'

// Storage analysis
kubectl get pvc --all-namespaces
```

### Output Format Options

**Markdown (default):**
- Easy to copy-paste into Confluence, Notion
- Renders well in n8n chat
- Can be version controlled

**PDF (future enhancement):**
- Use n8n HTTP node to call markdown-to-pdf service
- Professional deliverable for customers

**Confluence (integration):**
- POST to Confluence REST API
- Auto-create page in customer space

**Jira (integration):**
- Create epic with recommendations as stories
- Assign to implementation team

## Success Metrics

**For Black Belts:**
- Time savings: 2-3 days → 5 minutes (99% reduction)
- Consistency: 100% proposals follow best practices
- Quality: All proposals include cost analysis, architecture, plan
- Adoption: Track how many SAs use this vs. manual

**For Customers:**
- Faster sales cycles (proposal turnaround)
- Higher quality proposals (standardized)
- Better post-sales experience (optimization reports)

## Next Steps

1. Build workflow in n8n (3 hours)
2. Test with sample inputs (1 hour)
3. Create demo script (1 hour)
4. Practice demo (30 min)
5. Present to Black Belts (15 min)
6. Iterate based on feedback (ongoing)
