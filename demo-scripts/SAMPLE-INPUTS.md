# Sample Inputs for Solution Architect Demo

Copy-paste these into the workflow during demos.

---

## Scenario 1: Pre-Sales Discovery → ROSA Proposal

**Use case:** Net new customer evaluating managed OpenShift  
**Demo time:** 2 minutes  
**Expected output:** Complete architecture proposal with costs

### Input (Copy below)

```
Discovery Call Notes - Acme Financial Services

Date: 2026-05-21
Company: Acme Financial Services (Fortune 500, $12B revenue)
Industry: Financial Services / Payment Processing
Attendees: Sarah Chen (CTO), Michael Rodriguez (VP Engineering), 
          Jennifer Liu (Lead Cloud Architect), Tom Anderson (CISO)

=== CURRENT STATE ===

Infrastructure:
- Platform: VMware vSphere 7.0 (on-premises datacenter)
- Compute: 80 VMs across 3 clusters
  * Application servers: 50 × (8 vCPU, 32GB RAM)
  * Database servers: 15 × (16 vCPU, 64GB RAM)
  * Middleware: 15 × (4 vCPU, 16GB RAM)
- Storage: Dell EMC Unity (50TB total, 30TB used)
- Network: F5 Big-IP load balancers, Palo Alto firewalls
- Database: PostgreSQL 14 (bare metal, 1.5TB primary + replica)

Applications:
- 30 Java microservices (Spring Boot, Java 17)
- 8 Python services (FastAPI, Flask)
- 2 .NET applications (legacy, Windows containers required)
- RESTful APIs + event-driven (Kafka)

CI/CD:
- Jenkins (on-prem, 15 pipelines)
- GitLab CE (self-hosted)
- Artifactory for artifacts
- Manual deployment process (2-week release cycle)

Monitoring & Operations:
- Splunk Enterprise (500GB/day)
- Nagios for infrastructure monitoring
- Manual log collection and analysis
- PagerDuty for on-call

=== BUSINESS DRIVERS ===

Primary Motivations:
1. Datacenter Lease Ending
   - Current datacenter lease expires October 31, 2026
   - Renewal cost increased 40% ($2.8M → $3.9M annually)
   - Management decision: Exit datacenter, move to cloud

2. Cost Reduction Target
   - Board mandate: Reduce infrastructure costs by 30%
   - Current total cost: ~$850k/month (datacenter + staff)
   - Target: <$600k/month including cloud + operations

3. Faster Time-to-Market
   - Current release cycle: 2 weeks (too slow for fintech competition)
   - Target: Daily deployments with zero-downtime
   - Need blue-green deployments, canary releases

4. Disaster Recovery Improvement
   - Current DR: Secondary datacenter (200 miles away)
   - Current RPO: 24 hours (tape backups)
   - Current RTO: 8-12 hours (manual failover)
   - Target: RPO < 1 hour, RTO < 30 minutes

=== TECHNICAL REQUIREMENTS ===

Availability & Scale:
- SLA: 99.95% uptime minimum (4.38 hours downtime/year max)
- Multi-AZ deployment required (3 availability zones)
- Peak load: 10,000 concurrent users (holiday season)
- Average load: 3,000 concurrent users
- Transaction volume: 500,000 payment transactions/day
- Response time: <200ms p95 latency
- Data growth: 200GB/month (historical transaction data)

Compliance & Security:
- PCI-DSS Level 1 (credit card processing)
- SOC 2 Type II
- GDPR compliance (European customers)
- Encryption at rest (FIPS 140-2 Level 3)
- Encryption in transit (TLS 1.3 minimum)
- Network segmentation (DMZ, internal, data tier)
- Audit logging (7-year retention)
- Secrets management (no hardcoded credentials)
- Regular penetration testing (quarterly)

Integration Requirements:
- Active Directory integration (8,000 employee accounts)
- SAML 2.0 SSO for applications
- ServiceNow for ticketing (REST API integration)
- Splunk for centralized logging (existing license)
- MuleSoft for legacy system integration (12 on-prem systems)
- S3 for document storage (already using AWS)
- RDS for some workloads (already using AWS PostgreSQL)

DevOps & Automation:
- GitOps workflow preferred (declarative, version-controlled)
- Service mesh for traffic management
- Automated certificate management
- Blue-green and canary deployment strategies
- Automated rollback on failure
- Infrastructure as Code (Terraform or native)
- Policy-as-Code (compliance automation)

Platform Features Needed:
- Container registry with vulnerability scanning
- Built-in monitoring and alerting
- Centralized logging
- Secret management
- Multi-tenancy (separate environments per team)
- Resource quotas and limits
- Network policies
- Pod security policies
- Image signing and verification

=== SCALE & CAPACITY ===

Current Metrics:
- Total compute: 640 vCPU, 2.5TB RAM (across 80 VMs)
- Storage: 30TB used (application data + databases)
- Network: 2Gbps peak throughput
- Database: 1.5TB PostgreSQL + 500GB MySQL

Projected Growth:
- User growth: 15% year-over-year
- Data growth: 200GB/month (2.4TB/year)
- New applications: 5-8 microservices/year
- Geographic expansion: EU region launch (2027)

Performance Requirements:
- API response time: <200ms p95
- Database query time: <50ms p95
- Batch processing: 1M records/hour
- Real-time events: 10,000 events/second peak

=== TEAM & SKILLS ===

Platform Team:
- 2 platform engineers (Kubernetes experience, not OpenShift)
- 1 DevOps engineer (CI/CD automation)
- 1 infrastructure engineer (VMware background)
- 1 security engineer (compliance focus)

Development Teams:
- 45 developers (Java, Python, .NET)
- Familiar with containers (Docker)
- Limited Kubernetes knowledge
- No OpenShift experience

Operations:
- 24/7 operations (3 shifts, 2 engineers per shift)
- On-call rotation (4 engineers)
- Currently managing physical infrastructure

=== BUDGET & TIMELINE ===

Budget:
- Infrastructure: ~$80,000/month approved (cloud + support)
- Migration services: $200,000 one-time budget
- Training: $50,000 (platform team + developers)
- Total Year 1: ~$1.21M (migration + infrastructure + training)

Timeline:
- Decision: June 2026 (this month)
- POC: July 2026 (30 days, 2 non-critical apps)
- Pilot: August-September 2026 (60 days, 5 apps)
- Wave 1 migration: October 2026 (10 apps - before datacenter exit)
- Wave 2 migration: November-December 2026 (15 apps)
- Wave 3 migration: January-February 2027 (remaining 15 apps)
- Datacenter exit: October 31, 2026 (HARD DEADLINE)

=== CONCERNS & QUESTIONS ===

Technical Concerns:
1. Windows container support (.NET apps)
   - Can ROSA run Windows containers?
   - Performance compared to Windows VMs?

2. Database strategy
   - PostgreSQL on ROSA vs. RDS?
   - Latency between ROSA and RDS?
   - Backup and recovery process?

3. Network integration
   - How to connect to on-prem MuleSoft?
   - VPN vs. Direct Connect?
   - Network latency impact?

4. Migration complexity
   - Can we migrate incrementally?
   - How to handle stateful applications?
   - Zero-downtime migration possible?

Operational Concerns:
1. Learning curve
   - Team has K8s experience but not OpenShift
   - How long to become productive?
   - Training availability?

2. Support model
   - 24/7 support coverage?
   - Response times for critical issues?
   - Dedicated TAM available?

3. Vendor lock-in
   - Portability to other clouds (multi-cloud strategy)?
   - Exit strategy if needed?
   - Open standards vs. proprietary?

Business Concerns:
1. Cost predictability
   - Are there hidden costs?
   - Egress charges?
   - How to forecast monthly costs?

2. SLA guarantees
   - 99.95% uptime guaranteed?
   - Credits for downtime?
   - Disaster recovery SLA?

3. Compliance validation
   - PCI-DSS audit support?
   - Pre-built compliance templates?
   - Audit logging capabilities?

=== COMPETITIVE LANDSCAPE ===

Also Evaluating:
1. AWS EKS
   - Pros: Already using AWS (S3, RDS)
   - Pros: Team has some EKS experience
   - Cons: More operational overhead
   - Cons: Need to integrate many tools separately

2. Azure AKS
   - Pros: Microsoft relationship (Office 365, AD)
   - Pros: Azure proximity to European customers
   - Cons: Less AWS integration
   - Cons: Team has no Azure experience

Current Preferences:
- Leaning towards AWS ecosystem (already using S3, RDS, Route53)
- Concerned about operational complexity of EKS
- Interested in "managed" aspect of ROSA
- Like the idea of Red Hat support
- Want integrated developer experience

Decision Criteria:
1. Total Cost of Ownership (40% weight)
2. Operational overhead / ease of management (30% weight)
3. Migration complexity and timeline (20% weight)
4. Support quality and SLAs (10% weight)

=== SUCCESS CRITERIA ===

Must Have:
- ✅ Complete datacenter exit by Oct 31, 2026
- ✅ Achieve 99.95% uptime SLA
- ✅ Pass PCI-DSS audit (Q4 2026)
- ✅ Infrastructure costs <$80k/month
- ✅ Zero data loss during migration

Should Have:
- Reduce release cycle to <1 week
- Improve DR (RPO <1hr, RTO <30min)
- Reduce operational overhead by 40%
- Self-service deployments for developers
- Automated compliance scanning

Nice to Have:
- Multi-region (EU expansion in 2027)
- Advanced observability (OpenTelemetry)
- AI/ML platform for fraud detection
- Developer portal (backstage or similar)

=== NEXT STEPS ===

Immediate:
- Need proposal by May 27 (Monday) for exec review
- Architecture review meeting requested (this week if possible)
- POC environment needed by July 1

Short-term:
- Proof of Concept (July 2026)
  * Migrate 2 non-critical apps
  * Validate performance, security, operations
  * Test CI/CD pipeline
  * Train platform team

- Decision point: July 31
  * Go/no-go based on POC results
  * Sign contract by Aug 1
  * Begin pilot phase Aug 1

=== CONTACT INFO ===

Primary: Sarah Chen (CTO) - schen@acmefinancial.com
Technical: Jennifer Liu (Cloud Architect) - jliu@acmefinancial.com
Procurement: David Park (VP Procurement) - dpark@acmefinancial.com

=== ADDITIONAL CONTEXT ===

- Company is publicly traded (stock symbol: ACME)
- Recent leadership changes (new CTO driving cloud transformation)
- Board pressure to reduce costs (recent earnings miss)
- Competitive pressure from fintech startups (faster innovation)
- Previous cloud migration failed (AWS migration in 2020, rolled back)
  * Reason: Underestimated complexity, insufficient training
  * Key lesson: Need strong partner support this time
```

---

## Scenario 2: Post-Sales Cluster Optimization

**Use case:** Existing ROSA customer needs cluster audit  
**Demo time:** 2 minutes  
**Expected output:** Optimization report with specific recommendations

### Input (Copy below)

```
Cluster Optimization Request

Date: May 21, 2026
Customer: TechCorp Inc.
Cluster: production-rosa-us-east-1
OpenShift Version: 4.12.45
Cluster Age: 6 months (deployed Nov 2025)

=== REQUEST ===

From: David Martinez (Platform Lead)
To: Solutions Architect Team
Subject: ROSA cluster optimization review needed

Hi team,

We've been running our ROSA cluster for 6 months now and it's generally 
working well, but we're seeing some concerning patterns:

1. Costs are tracking 40% higher than initial estimate
   - Projected: $18k/month
   - Actual: $25k/month average
   - CFO is asking questions

2. Occasional pod evictions and OOMKilled events
   - Happens 2-3 times per week
   - Usually during business hours (not low-traffic periods)
   - Causing brief service disruptions

3. Inconsistent performance
   - Some apps respond in <100ms
   - Others taking 2-5 seconds for same load
   - No obvious pattern

4. Upcoming audit (SOC2 Type II in July)
   - Auditors will review our OpenShift security posture
   - Want to address any gaps proactively

Can you review our cluster and provide optimization recommendations?

We have full read access available for your analysis.

=== KNOWN ISSUES ===

Issues We've Already Identified:

1. Resource Limits
   - About 40% of our deployments don't have resource limits set
   - Developers keep forgetting to add them
   - We have no policy enforcement currently

2. OpenShift Version
   - Running 4.12.45 (deployed 6 months ago)
   - Haven't upgraded yet (nervous about breaking changes)
   - Aware that 4.12 goes EOL soon

3. Storage Concerns
   - Using default storage class for everything (gp2)
   - Some PVCs are 80%+ full
   - No automated cleanup of old data

4. Security Posture
   - No ResourceQuotas configured (any namespace can consume unlimited resources)
   - No NetworkPolicies (all pods can talk to all pods)
   - Some pods running as root (legacy apps)
   - No Pod Security Standards enforced

5. Monitoring Gaps
   - Using built-in monitoring but not well configured
   - No custom alerts set up
   - Grafana dashboards are default (not customized)
   - No log aggregation beyond basic

6. Backup Strategy
   - No formal backup process
   - Some teams using Velero (self-managed)
   - No DR plan documented
   - No tested restore procedures

=== CLUSTER DETAILS ===

Current Configuration:

Control Plane:
- 3 master nodes (managed by Red Hat)
- Version: 4.12.45
- Region: us-east-1
- Availability Zones: us-east-1a, 1b, 1c

Worker Nodes:
- Machine pool "default": 10 × m5.2xlarge (8 vCPU, 32GB RAM)
- Machine pool "database": 4 × m5.4xlarge (16 vCPU, 64GB RAM)
- Machine pool "batch": 3 × m5.xlarge (4 vCPU, 16GB RAM)
- Total: 17 nodes

Storage:
- Storage class: gp2-csi (default)
- Total PVCs: 85
- Total storage: 12TB provisioned (8TB used)

Networking:
- VPC: Private subnets only
- Ingress: Application Load Balancer
- Egress: NAT Gateway (3 × $0.045/hr = $97/month)
- No NetworkPolicies configured

Namespaces:
- Production: 8 namespaces (frontend, backend, database, kafka, etc.)
- Staging: 6 namespaces (mirrors production)
- Development: 12 namespaces (one per team)
- System: OpenShift system namespaces

Workloads:
- Total pods: ~450 pods across all namespaces
- Deployments: 85
- StatefulSets: 12
- DaemonSets: 8
- Jobs/CronJobs: 25

Resource Usage (Current):
- CPU: 45% average utilization
- Memory: 62% average utilization
- Disk I/O: Low (mostly reads)
- Network: 2Gbps peak (95th percentile: 800Mbps)

=== COST BREAKDOWN ===

Current Monthly Costs (~$25k):

Infrastructure:
- ROSA subscription: $4,320 (17 nodes × $0.03/hr × 720hr)
- EC2 instances:
  * 10 × m5.2xlarge: $5,760
  * 4 × m5.4xlarge: $4,608
  * 3 × m5.xlarge: $864
- Control plane: $360/month (~$0.50/hr)
- EBS volumes (12TB gp2): $1,200
- NAT Gateway: $97 (data transfer: ~$500/month)
- Load Balancers: $300/month (multiple ALBs)
- Data transfer out: $800/month

Support & Tools:
- Red Hat Support (Premium): $2,000/month
- Datadog: $3,500/month (450 pods)
- Sysdig (security scanning): $1,200/month
- Velero storage (S3): $150/month

Total: ~$25,399/month

Original Estimate Was:
- Infrastructure: $15,000
- Support: $2,000
- Tools: $1,000
- Total: $18,000/month

Variance: +$7,399/month (+41%)

=== TEAMS & USAGE ===

Teams Using the Cluster:

1. Platform Team (4 engineers)
   - Manage cluster infrastructure
   - Handle upgrades, scaling, troubleshooting
   - Create namespaces, configure quotas (when requested)

2. Application Teams (6 teams, ~30 developers)
   - Team Alpha: E-commerce frontend (3 services)
   - Team Beta: Payment processing (5 services)
   - Team Gamma: User management (4 services)
   - Team Delta: Analytics (4 services)
   - Team Epsilon: Notifications (3 services)
   - Team Zeta: Batch processing (6 services)

3. Data Team (8 engineers)
   - Running Kafka cluster (Strimzi operator)
   - PostgreSQL databases (some on OpenShift, some RDS)
   - Redis caches
   - Elasticsearch for search

=== PAIN POINTS ===

From Platform Team:
1. "Too much time spent firefighting OOM issues"
2. "Teams keep deploying without resource limits"
3. "No good way to enforce policies"
4. "Upgrades are scary (no test environment)"
5. "Can't easily see which teams are using the most resources"

From Development Teams:
1. "Don't know how to set resource limits appropriately"
2. "Deployments sometimes fail mysteriously (quota issues?)"
3. "No visibility into why pods get evicted"
4. "Staging doesn't match production (different node types)"

From Management:
1. "Costs are higher than promised"
2. "Want better cost allocation per team"
3. "Concerned about security (upcoming audit)"
4. "Need better uptime reporting"

=== GOALS ===

What We Want to Achieve:

Cost Reduction:
- Target: Reduce monthly costs to <$20k (20% reduction)
- Acceptable: Any meaningful reduction with justification

Performance:
- Eliminate OOMKilled events
- Consistent response times across all services
- Better resource utilization (currently underutilized nodes)

Security & Compliance:
- Pass SOC2 audit (July 2026)
- Implement Pod Security Standards
- Add NetworkPolicies (least privilege)
- Remove pods running as root (where possible)

Operational Excellence:
- Automate policy enforcement
- Better monitoring and alerting
- Upgrade to supported OpenShift version
- Implement proper backup/DR

Team Enablement:
- Self-service for developers (within guardrails)
- Better documentation
- Cost visibility per team
- Quota management

=== ACCESS & PERMISSIONS ===

For This Analysis:
- Kubeconfig: Available (read-only cluster-admin)
- Cloud console: AWS console access available
- Monitoring: Grafana/Prometheus access available
- Logs: OpenShift logging access available

We can provide:
- Current resource usage reports
- Cost and usage data (AWS Cost Explorer)
- Recent incidents/alerts (last 30 days)
- Team feedback (collected via survey)

=== TIMELINE ===

Need:
- Initial analysis: This week (by May 24)
- Detailed recommendations: By end of month (May 31)
- Implementation plan: Early June
- Execute fixes: June-July (before audit)
- Audit readiness: July 15

=== OUTPUT PREFERENCES ===

What Would Be Most Useful:

1. Executive Summary
   - Key findings (3-5 bullet points)
   - Cost impact (savings potential)
   - Risk assessment (critical vs. nice-to-have)

2. Detailed Findings
   - What's wrong (evidence from cluster)
   - Why it's a problem (impact)
   - How to fix (specific commands/configs)

3. Prioritized Roadmap
   - Week 1: Critical fixes (security, stability)
   - Month 1: Important improvements (cost, performance)
   - Quarter 1: Strategic enhancements (DR, multi-cluster)

4. Cost Analysis
   - Current state breakdown
   - Projected savings per recommendation
   - ROI for each improvement

Please be specific - we want actual oc commands, YAML snippets, etc., 
not just "optimize resource limits" generic advice.

Thanks!
David
```

---

## Scenario 3: EKS to ROSA Competitive Analysis

**Use case:** Customer on EKS considering ROSA migration  
**Demo time:** 2 minutes  
**Expected output:** Complete migration analysis with cost comparison

### Input (Copy below)

```
EKS to ROSA Migration Analysis Request

Date: May 21, 2026
Company: RetailCo (E-commerce)
Current Platform: Amazon EKS
Decision Timeline: 60 days

=== EXECUTIVE SUMMARY ===

From: Lisa Thompson, VP Engineering
Context: Annual infrastructure review, evaluating alternatives to EKS

We've been running on EKS for 18 months. It works, but operational 
overhead is higher than expected. Leadership is asking: Should we 
consider alternatives?

Red Hat approached us about ROSA. Before we dismiss it as "just another
managed Kubernetes," we want an objective analysis:
1. How do costs compare (real costs, not marketing)?
2. What's the actual operational difference?
3. Is migration worth the effort and risk?
4. What do we gain vs. what do we lose?

We need a business case for leadership by June 30.

=== CURRENT EKS ENVIRONMENT ===

Cluster Configuration:

Region: us-east-1
EKS Version: 1.28.5
Number of Clusters: 3 (prod, staging, dev)

Production Cluster:
- Control plane: $0.10/hour × 24 × 30 = $72/month
- Node groups:
  * app-nodes: 15 × m5.2xlarge (8 vCPU, 32GB RAM)
    → $0.384/hr × 15 × 720hr = $4,147/month
  * database-nodes: 5 × r5.xlarge (4 vCPU, 32GB RAM)
    → $0.252/hr × 5 × 720hr = $907/month
  * batch-nodes: 3 × m5.xlarge (4 vCPU, 16GB RAM)
    → $0.192/hr × 3 × 720hr = $414/month
- Auto-scaling: Enabled (min nodes shown, max: 35 nodes)
- Availability Zones: 3 (us-east-1a, 1b, 1c)

Staging Cluster:
- Control plane: $72/month
- 6 × m5.large nodes: $518/month
- Auto-scaling: Disabled

Dev Cluster:
- Control plane: $72/month
- 4 × m5.large nodes: $346/month
- Auto-scaling: Disabled

Storage:
- EBS gp3 volumes: 5TB total
  → $0.08/GB × 5000GB = $400/month
- EBS snapshots: 2TB
  → $0.05/GB × 2000GB = $100/month

Networking:
- NAT Gateways: 3 × $0.045/hr × 720hr = $97/month
- NAT data processing: ~5TB/month × $0.045/GB = $225/month
- Application Load Balancers: 5 × $23/month = $115/month
- ALB LCU charges: ~$80/month
- Inter-AZ data transfer: ~$150/month

AWS Services Integrated:
- ECR (container registry): $50/month
- AWS Secrets Manager: $120/month (240 secrets × $0.40)
- CloudWatch Logs: $180/month (100GB ingested)
- CloudWatch metrics: $90/month (custom metrics)
- AWS Certificate Manager: $0 (free)
- Route53: $30/month

AWS Support:
- Support plan: Business ($1,200/month minimum)

=== ADD-ONS & TOOLS ===

Managed by Our Team:

Service Mesh:
- Istio 1.20 (self-managed via Helm)
- Operational effort: ~20 hours/month (upgrades, debugging)
- Complexity: High (version compatibility issues)
- Cost: $0 (open source) + engineer time

GitOps:
- Flux CD (self-managed)
- Operational effort: ~8 hours/month
- Issues: Occasional sync failures, manual debugging
- Cost: $0 (open source) + engineer time

Secrets Management:
- External Secrets Operator + AWS Secrets Manager
- Works well but one more thing to manage
- Operational effort: ~4 hours/month
- Cost: AWS Secrets Manager ($120/month)

Certificate Management:
- cert-manager (self-managed)
- Let's Encrypt integration
- Operational effort: ~2 hours/month (renewal issues)
- Cost: $0 (open source) + engineer time

Monitoring:
- Prometheus + Grafana (self-managed on EKS)
- Operational effort: ~16 hours/month
  * Prometheus upgrades
  * Grafana dashboard maintenance
  * Alert tuning
  * Storage management (metrics retention)
- Cost: EBS storage for Prometheus (~$200/month)

Logging:
- Fluent Bit → CloudWatch Logs
- Log aggregation via CloudWatch Insights
- Operational effort: ~6 hours/month
- Cost: CloudWatch ($180/month)

Security Scanning:
- Trivy (self-managed in CI/CD)
- Manual security reviews
- Operational effort: ~12 hours/month
- Cost: $0 (open source) + engineer time

Third-Party SaaS:
- Datadog: $2,500/month (350 pods × ~$7/pod)
  * APM, infrastructure monitoring, logs
  * Provides value but expensive
  * Considering alternatives

- HashiCorp Vault: Self-hosted on EC2
  * 3 × t3.medium instances (HA): $90/month
  * EBS for storage: $30/month
  * Operational effort: ~10 hours/month
  * Cost: $120/month + engineer time

Total Third-Party Tools: $2,500/month (Datadog only, Vault self-hosted)

=== TOTAL CURRENT COSTS ===

Infrastructure (AWS):
- EKS control planes (3 clusters): $216/month
- EC2 instances (all clusters): $6,402/month
- EBS volumes + snapshots: $500/month
- Networking (NAT, ALB, data transfer): $667/month
- ECR + Secrets Manager + CloudWatch + Route53: $470/month
Subtotal: $8,255/month

Support & Tools:
- AWS Support (Business): $1,200/month
- Datadog: $2,500/month
Subtotal: $3,700/month

Self-Hosted Tooling:
- Vault infrastructure: $120/month
- Prometheus storage: $200/month
Subtotal: $320/month

**Grand Total: $12,275/month**

But this doesn't include engineer time...

=== OPERATIONAL OVERHEAD ===

Platform Team: 2 Senior Platform Engineers

Time Allocation (per month):

Cluster Management (40 hours):
- EKS version upgrades: 12 hours/quarter → 4 hrs/month average
- Node group updates: 8 hours/month
- Add-on maintenance: 12 hours/month
- Capacity planning: 8 hours/month
- Security patching: 8 hours/month

Tool Management (62 hours):
- Istio management: 20 hours/month
  * Upgrades (quarterly): 12 hours/quarter → 4 hrs/month
  * Troubleshooting mesh issues: 16 hours/month average
- Prometheus/Grafana: 16 hours/month
  * Upgrades: 4 hours/month
  * Dashboard maintenance: 8 hours/month
  * Alert tuning: 4 hours/month
- Flux CD: 8 hours/month
- cert-manager: 2 hours/month
- Vault: 10 hours/month
- Trivy/security scanning: 6 hours/month

Incident Response (24 hours):
- On-call rotation: 24 hours/month average
- Issues: Pod evictions, networking issues, cert renewals, etc.

Developer Support (20 hours):
- Onboarding new services: 8 hours/month
- Troubleshooting deployments: 12 hours/month

Documentation & Training (10 hours):
- Runbook updates: 4 hours/month
- Team training: 6 hours/month

**Total: 156 hours/month (almost 1 FTE dedicated to platform management)**

At $150/hour blended rate (senior engineers):
156 hours × $150 = **$23,400/month in engineer time**

**True Monthly Cost: $12,275 + $23,400 = $35,675/month**

=== CURRENT PAIN POINTS ===

Operational Complexity:
1. Too many tools to manage (Istio, Prometheus, Flux, cert-manager, Vault)
2. Tool version compatibility matrix is a nightmare
   - Istio 1.20 requires specific Kubernetes version
   - Prometheus updates break Grafana dashboards
   - Flux CD bugs with certain Git providers
3. EKS upgrades are stressful (quarterly, high risk)
4. No integrated developer experience (devs SSH into pods to debug)

Cost Unpredictability:
1. Auto-scaling works but costs fluctuate wildly ($8k-$16k/month range)
2. Data transfer charges are hard to predict
3. No good way to attribute costs to teams/applications

Developer Friction:
1. No built-in container registry (ECR is separate, extra steps)
2. No web console (devs use kubectl only, learning curve)
3. Logs spread across CloudWatch, Datadog, application logs
4. No GitOps UI (Flux is CLI-only, devs struggle)
5. Certificate issues cause frequent developer blockers

Security & Compliance:
1. No built-in image scanning (using Trivy in CI/CD, gaps exist)
2. No policy enforcement (rely on manual reviews)
3. Network policies hard to manage (Calico CNI complexity)
4. Audit logging incomplete (some gaps in CloudWatch)

Multi-Cluster Management:
1. Each cluster managed separately (no fleet view)
2. Configuration drift between prod/staging/dev
3. No centralized RBAC (IAM roles per cluster)
4. Disaster recovery tested manually (time-consuming)

=== WHY CONSIDERING ROSA ===

We heard from Red Hat that ROSA provides:

1. Integrated Tools
   - Built-in registry (no separate ECR)
   - Built-in monitoring (no separate Prometheus/Grafana setup)
   - Built-in console (web UI for developers)
   - Operators for common patterns (service mesh, GitOps, etc.)

2. Reduced Operational Overhead
   - Managed control plane AND worker nodes (more managed than EKS)
   - Operators handle tool lifecycle (less manual work)
   - OpenShift-native upgrades (less risky than EKS?)

3. Better Developer Experience
   - Web console (non-Kubernetes experts can self-service)
   - Integrated CI/CD (OpenShift Pipelines / Tekton)
   - OperatorHub (one-click installs for common tools)

4. Enhanced Security
   - Built-in image scanning
   - Pod Security Standards enforced
   - Network policies easier to manage
   - Better RBAC model

5. Multi-Cluster Management
   - Advanced Cluster Management (ACM)
   - Single pane of glass for all clusters
   - Policy enforcement across fleet

But is this marketing or reality? We need objective analysis.

=== WORKLOAD CHARACTERISTICS ===

Applications:
- 35 microservices (Java Spring Boot, Node.js, Python FastAPI)
- 8 stateful applications (PostgreSQL, MongoDB, Kafka)
- 12 background workers (Python, Go)
- 5 cron jobs (batch processing, reports)

Traffic Patterns:
- Peak: 15,000 requests/second (Black Friday)
- Average: 3,500 requests/second
- Mostly US traffic (95%), some international (5%)

Data:
- Database: RDS PostgreSQL (not on EKS, would stay on RDS)
- Object storage: S3 (100TB, would stay on S3)
- Cache: Redis on EKS (6 replicas, 48GB total)
- Message queue: Kafka on EKS (Strimzi operator, 9 brokers)

Integrations:
- RDS PostgreSQL: Primary database (would remain)
- S3: Object storage (would remain)
- Route53: DNS (would remain)
- CloudFront: CDN (would remain)
- SQS: Some async processing (would remain)

=== MIGRATION CONCERNS ===

What We're Worried About:

1. Migration Effort
   - How much work to migrate 35 microservices?
   - Can we do incremental migration or must be big bang?
   - What breaks during migration (custom CRDs, Helm charts)?

2. Cost
   - Is ROSA really cheaper when we add everything up?
   - Hidden costs we're not aware of?
   - Will we save enough to justify migration effort?

3. Feature Parity
   - Do we lose any EKS features we rely on?
   - AWS integrations (IAM, ECR, CloudWatch) - how do they work with ROSA?
   - Is there a "gotcha" we'll discover post-migration?

4. Downtime Risk
   - Can we achieve zero-downtime migration?
   - What's the rollback plan if things go wrong?
   - Customer impact during migration?

5. Team Learning Curve
   - Is OpenShift different enough from K8s to require retraining?
   - How long to become productive?
   - Support during transition?

6. Lock-in
   - Are we trading AWS lock-in for Red Hat lock-in?
   - Portability to other clouds if needed?
   - Exit strategy?

=== DESIRED OUTPUTS ===

What We Need:

1. Cost Comparison (Apples-to-Apples)
   - EKS current: $X/month
   - ROSA equivalent: $Y/month
   - Include ALL costs (tools, operations, support)
   - 3-year TCO comparison

2. Feature Matrix
   - What EKS has that ROSA doesn't
   - What ROSA has that EKS doesn't
   - Which differences matter for our workload

3. Operational Comparison
   - Current engineer time: 156 hrs/month
   - Projected with ROSA: ?? hrs/month
   - Quantify the "integrated tools" value claim

4. Migration Plan
   - Incremental or big bang?
   - Timeline estimate (realistic)
   - Risk assessment
   - Rollback strategy

5. ROI Analysis
   - Migration cost: $X one-time
   - Monthly savings: $Y
   - Payback period: Z months
   - Intangible benefits (developer productivity, etc.)

6. Recommendation
   - Should we migrate? (Yes/No with rationale)
   - If yes, when and how?
   - If no, what should we do instead?

We want honesty, not sales pitch. If sticking with EKS is smarter, tell us.

=== TIMELINE ===

- Analysis due: June 15, 2026
- Leadership review: June 20
- Decision: June 30
- If approved, migration start: August 2026

=== DECISION MAKERS ===

- Lisa Thompson, VP Engineering (technical decision)
- Mark Rodriguez, CFO (cost approval)
- Karen Johnson, CTO (strategic decision)

They will ask:
- "Why is this better than optimizing our current EKS setup?"
- "What's the risk if we migrate and it doesn't work out?"
- "How does this support our multi-cloud strategy?" (future Azure expansion)

Please address these preemptively.
```

---

## Quick Reference: Which Input to Use

| Scenario | Customer Situation | Use This Input | Key Demo Point |
|----------|-------------------|----------------|----------------|
| **Scenario 1** | Evaluating OpenShift, no cluster yet | Acme Financial | Proposal generation speed + accuracy |
| **Scenario 2** | Has ROSA, needs optimization | TechCorp | Live cluster analysis (MCP power) |
| **Scenario 3** | On EKS, considering switch | RetailCo | Competitive analysis + fair comparison |

---

## Demo Tips

### For Maximum Impact:

1. **Start with Scenario 3** (EKS comparison)
   - Most controversial
   - Shows objectivity (includes ROSA costs honestly)
   - Demonstrates complex analysis capability

2. **Follow with Scenario 2** (Cluster optimization)
   - Shows MCP integration (live cluster data)
   - Proves it's not just generic LLM responses
   - Gives specific, actionable outputs

3. **End with Scenario 1** (Proposal generation)
   - Shows complete end-to-end workflow
   - Demonstrates speed (45 seconds for full proposal)
   - Easiest to understand value prop

### Customization Ideas:

**Personalize inputs:**
- Change company names to your customer names
- Adjust numbers to match typical deal sizes
- Add specific pain points you hear frequently

**Add your scenarios:**
- Multi-region expansion analysis
- Compliance gap assessment (HIPAA, FedRAMP)
- Disaster recovery planning
- Cost optimization deep-dive

---

## Backup Inputs (If Needed)

### Simple Test Query
```
What are the three scenarios you can help with?
```

Expected response should explain Scenario 1, 2, and 3.

### Fallback Demo (If Technical Issues)
```
A customer is running 50 Java microservices on VMware and needs 
to migrate to ROSA by end of year due to datacenter exit. They 
need 99.9% uptime, PCI-DSS compliance, and budget is $60k/month. 
Create a proposal.
```

Should generate a simplified proposal even without the full detailed input.

---

**Ready to copy-paste during your demo!** 🚀
