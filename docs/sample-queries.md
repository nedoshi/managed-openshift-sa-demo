# Sample Queries for Live Demos

Copy-paste these queries during customer demos. Organized by use case and difficulty level.

---

## Health Check Assistant (Demo 1)

### Basic Health Checks

**Quick cluster overview:**
```
How many nodes are in the cluster and what's their status?
```

**Namespace health:**
```
Check the health of the openshift-monitoring namespace
```

**Find problems:**
```
Are there any pods in CrashLoopBackOff or ImagePullBackOff status?
```

**Resource usage:**
```
Which pods in openshift-monitoring are using the most memory?
```

---

### Troubleshooting Scenarios

**Performance investigation:**
```
Analyze the production-app namespace for performance issues. 
Check pod restarts, resource constraints, and recent errors.
```

**Network debugging:**
```
I can't reach my application at route myapp-production.apps.example.com
Help me debug the ingress/route configuration for namespace production-app
```

**Storage issues:**
```
Check for any PersistentVolumeClaim problems in the database namespace
```

**Probe failures:**
```
Show me all pods with failing readiness or liveness probes and explain why
```

**Event analysis:**
```
What warning or error events have happened in the last hour across all namespaces?
```

**Operator issues:**
```
Check if all operators in openshift-operators namespace are healthy
```

---

### OpenShift-Specific Queries

**Routes and ingress:**
```
List all Routes in the production namespace and check if they're reachable
```

**Project/namespace management:**
```
Show me all projects/namespaces and their resource quotas
```

**Cluster operators:**
```
What's the status of cluster operators? Are any degraded or progressing?
```

**Node capacity:**
```
Show me node capacity vs actual usage. Are we running out of resources?
```

**Security context constraints:**
```
Which pods are running with privileged access?
```

---

### Advanced Debugging

**Multi-pod analysis:**
```
Compare the configuration of pods in deployment webapp-production.
Are they all running the same image version?
```

**Log investigation:**
```
Show me error logs from the last 100 lines of pods in namespace api-gateway
```

**Service endpoint debugging:**
```
Service frontend-service has no endpoints. Help me debug why.
```

**ConfigMap/Secret references:**
```
Check if all ConfigMaps and Secrets referenced by deployments in app-namespace exist
```

---

## Discovery Architect (Demo 2)

### Simple Architecture Requests

**Basic migration:**
```
Customer wants to migrate from VMs to OpenShift.
Current setup: 5 Java Spring Boot apps, PostgreSQL database, 200 concurrent users.
Design a ROSA architecture.
```

**Microservices architecture:**
```
Design an OpenShift architecture for:
- 12 microservices (Node.js + Python)
- Redis for caching
- MongoDB for data
- Need 99.9% uptime
- Expected load: 1000 requests/second
```

---

### Complex Discovery Scenarios

**Enterprise migration (copy-paste this):**
```
Discovery Notes - Acme Financial Corp

Current State:
- 25 applications (Java, .NET, Python mix)
- Running on VMware vSphere
- Oracle RAC database (2TB)
- F5 load balancers
- Active Directory authentication
- Weekly batch jobs (Informatica)

Requirements:
- Migrate to cloud (AWS preferred)
- Must maintain PCI-DSS compliance
- Zero downtime during migration
- Multi-region DR capability
- Keep existing CI/CD (Jenkins)
- 5000 concurrent users during business hours
- Budget: $50k/month infrastructure

Constraints:
- Cannot change database (must use Oracle)
- Need private connectivity to on-prem AD
- Some apps require Windows containers
- Must complete migration in 6 months

Design a ROSA architecture with migration plan.
```

**High-scale e-commerce:**
```
Discovery Notes - RetailCo

Business Context:
- E-commerce platform
- Black Friday traffic: 50,000 concurrent users
- Normal traffic: 2,000 concurrent users
- Revenue loss: $10k per minute of downtime

Technical Stack:
- Frontend: React (3 apps)
- Backend: 8 microservices (Go + Node.js)
- Database: PostgreSQL (read replicas needed)
- Search: Elasticsearch cluster
- Cache: Redis cluster
- Message queue: RabbitMQ
- CDN: CloudFront
- Payment processing: Stripe webhook integration

Requirements:
- Auto-scale for traffic spikes
- Sub-100ms API response time
- Multi-AZ deployment
- Blue-green deployment capability
- Real-time monitoring
- Cost optimization (peak vs off-peak)

Design ARO architecture with Azure-native integrations.
```

**Regulated industry (healthcare):**
```
Discovery Notes - HealthTech Startup

Application:
- Telemedicine platform
- Video conferencing (WebRTC)
- Electronic health records (EHR)
- Appointment scheduling
- Prescription management

Stack:
- Frontend: Next.js
- Backend: Django (Python)
- Database: PostgreSQL
- File storage: S3 (medical images, PDFs)
- Real-time: WebSockets for chat/video

Compliance:
- HIPAA required
- Data encryption at rest and in transit
- Audit logging for all PHI access
- Business associate agreement (BAA) needed
- PHI cannot leave US region
- Backup retention: 7 years

Scale:
- 500 providers
- 10,000 patients
- 200 concurrent video sessions (peak)
- 2TB medical images storage

Design ROSA architecture with HIPAA compliance controls.
```

---

### Architecture Comparison Requests

**Multi-cloud comparison:**
```
Compare ROSA (AWS) vs ARO (Azure) architecture for:
- Microservices app (10 services)
- Moderate scale (1000 users)
- PostgreSQL database
- File storage needs

Include cost estimate for both.
```

**Sizing optimization:**
```
I have an existing OpenShift cluster with:
- 6 worker nodes (m5.2xlarge)
- Average CPU usage: 30%
- Average memory usage: 45%

Recommend optimized node sizing and count.
```

---

### Discovery Note Templates

Use these to generate realistic demos on the fly:

**Template 1: SaaS Migration**
```
Customer: [Company Name]
Industry: [SaaS/Fintech/Healthcare/Retail]
Current: [VM/Heroku/ECS/other]
Apps: [count] x [language/framework]
Database: [PostgreSQL/MySQL/MongoDB]
Scale: [concurrent users]
Budget: [$/month]
Compliance: [HIPAA/PCI/SOC2/FedRAMP/none]

Design [ROSA/ARO] architecture.
```

**Template 2: Lift-and-Shift**
```
Migrating from: [on-prem VMware/AWS EC2/Azure VMs]
Applications: [count and types]
Database: [type and size]
Traffic: [requests/day or concurrent users]
HA requirement: [99.9%/99.99%/multi-region]
Timeline: [months]

Design migration strategy and target OpenShift architecture.
```

---

## Demo Tips

### For Health Check Demos

1. **Start simple:** "List all namespaces" → builds confidence
2. **Show real problems:** Deploy a crashing pod beforehand
3. **Demonstrate speed:** Time the manual troubleshooting vs AI agent
4. **Show evidence:** Agent provides logs/events, not just guesses

### For Discovery Demos

1. **Use realistic scenarios:** Based on actual customer conversations
2. **Show the diagram:** Mermaid renders in n8n chat (sometimes) or copy to diagrams.net
3. **Highlight cost estimates:** Customers care about TCO
4. **Emphasize compliance:** Especially for regulated industries

### Common Demo Mistakes to Avoid

- ❌ Don't ask vague questions: "Tell me about the cluster"
- ❌ Don't show failures without explanation
- ❌ Don't skip the "time savings" pitch
- ✅ Do prepare the cluster state beforehand
- ✅ Do have backup queries ready
- ✅ Do explain what the agent is doing in real-time

---

## Quick Demo Setup Checklist

Before starting demo:
- [ ] MCP server running: `curl http://localhost:8081/healthz`
- [ ] n8n accessible: `http://localhost:5678`
- [ ] Workflows imported and credentials configured
- [ ] Test query works: "List all namespaces"
- [ ] Demo namespace exists with sample workload
- [ ] Token hasn't expired (check logs)
- [ ] Have 2-3 queries queued in clipboard

---

## Emergency Queries (When Demo Goes Wrong)

If MCP connection fails:
```
Explain how you would troubleshoot a pod in CrashLoopBackOff status
(tests if Claude works without MCP)
```

If response is slow:
```
List namespaces
(simple query, fast response)
```

If customer asks something you didn't prepare:
```
Let me show you a different capability - [switch to prepared query]
```

---

## After the Demo

Share with customer:
1. Export workflow JSON (redact credentials)
2. This sample-queries.md file
3. DEMO-README.md for their team
4. Offer to run it against their cluster (with approval)

Follow-up questions to ask:
- "Which use case resonates most with your team?"
- "What other troubleshooting scenarios would you automate?"
- "Do you have internal runbooks we could integrate?"
- "What's your current mean-time-to-resolution for incidents?"
