# Architecture Diagrams

Visual comparison of the two n8n workflow architectures.

---

## Vertex AI Workflow (No API Keys)

```mermaid
graph TB
    subgraph "n8n Workflow"
        Chat[Chat Trigger<br/>Webhook Interface]
        Agent[AI Agent<br/>Orchestrator]
        Memory[Pricing Context<br/>Memory Buffer]
    end
    
    subgraph "Google Cloud"
        VertexAI[Vertex AI<br/>Claude 3.5 Sonnet]
        IAM[Google Cloud IAM<br/>Service Account Auth]
    end
    
    subgraph "Data Sources"
        MCP[MCP Client<br/>Kubernetes/OpenShift]
        ROSA[AWS ROSA Pricing API<br/>Real-time pricing]
        Parser[Pricing Parser<br/>Code Node]
    end
    
    Chat --> Agent
    Agent --> VertexAI
    VertexAI --> IAM
    Agent --> MCP
    Agent --> Memory
    ROSA --> Parser
    Parser --> Memory
    
    style VertexAI fill:#4285f4,color:#fff
    style IAM fill:#34a853,color:#fff
    style MCP fill:#ff6b6b,color:#fff
    style ROSA fill:#f39c12,color:#fff
```

### Key Features:
- ✅ **No API keys** - Uses Google Cloud IAM
- ✅ **Real-time ROSA pricing** - AWS Pricing API integration
- ✅ **Live cluster data** - MCP client for Kubernetes
- ✅ **Pricing context** - Memory buffer with current costs
- ✅ **Claude 3.5 Sonnet** - Best for architecture reasoning

---

## OpenAI Workflow (API Key Auth)

```mermaid
graph TB
    subgraph "n8n Workflow"
        Chat[Chat Trigger<br/>Webhook Interface]
        Agent[AI Agent<br/>Orchestrator]
    end
    
    subgraph "External APIs"
        OpenAI[OpenAI API<br/>GPT-4o]
        APIKey[API Key Auth]
    end
    
    subgraph "Data Sources"
        MCP[MCP Client<br/>Kubernetes/OpenShift]
    end
    
    Chat --> Agent
    Agent --> OpenAI
    OpenAI --> APIKey
    Agent --> MCP
    
    style OpenAI fill:#10a37f,color:#fff
    style APIKey fill:#e74c3c,color:#fff
    style MCP fill:#ff6b6b,color:#fff
```

### Key Features:
- ⚡ **Fast setup** - Just paste API key
- ✅ **Live cluster data** - MCP client for Kubernetes
- ✅ **GPT-4o** - Fast and capable
- ❌ **No real-time pricing** - Relies on model knowledge
- ❌ **API key management** - Need to rotate keys

---

## Data Flow Comparison

### Vertex AI: Pre-Sales Discovery Flow

```mermaid
sequenceDiagram
    participant User
    participant n8n
    participant VertexAI as Vertex AI<br/>(Claude)
    participant ROSA as AWS ROSA<br/>Pricing API
    participant Memory
    
    User->>n8n: Discovery notes input
    n8n->>ROSA: Fetch latest pricing
    ROSA-->>Memory: Instance pricing data
    n8n->>VertexAI: Analyze requirements +<br/>pricing context
    VertexAI->>Memory: Read pricing data
    VertexAI-->>n8n: Complete proposal with<br/>exact costs
    n8n-->>User: Architecture + diagram +<br/>accurate pricing
    
    Note over VertexAI,Memory: Uses Google Cloud IAM<br/>No API keys!
```

---

### OpenAI: Pre-Sales Discovery Flow

```mermaid
sequenceDiagram
    participant User
    participant n8n
    participant OpenAI as OpenAI API<br/>(GPT-4o)
    
    User->>n8n: Discovery notes input
    n8n->>OpenAI: Analyze requirements<br/>(API key auth)
    OpenAI-->>n8n: Proposal with<br/>estimated costs
    n8n-->>User: Architecture + diagram +<br/>estimated pricing
    
    Note over OpenAI: Uses model knowledge<br/>for pricing (may be outdated)
```

---

## Live Cluster Optimization Flow

**Both workflows use MCP for live cluster data:**

```mermaid
sequenceDiagram
    participant User
    participant n8n
    participant AI as AI Model<br/>(Claude or GPT-4o)
    participant MCP as MCP Server
    participant K8s as OpenShift Cluster
    
    User->>n8n: "Optimize my cluster"
    n8n->>AI: Request optimization analysis
    AI->>MCP: Query cluster resources
    MCP->>K8s: kubectl/oc commands
    K8s-->>MCP: Current state (pods, nodes, usage)
    MCP-->>AI: Structured cluster data
    AI->>MCP: Check for unused resources
    MCP->>K8s: Query PVCs, ConfigMaps, etc.
    K8s-->>MCP: Resource inventory
    MCP-->>AI: Complete inventory
    AI-->>n8n: Optimization recommendations +<br/>cost savings + action items
    n8n-->>User: Detailed audit report
    
    Note over MCP,K8s: Requires MCP server deployed<br/>in or with access to cluster
```

---

## Authentication Comparison

### Vertex AI: Google Cloud IAM

```mermaid
graph LR
    A[n8n] --> B{Service Account<br/>or ADC?}
    B -->|Service Account| C[JSON Key File]
    B -->|ADC| D[gcloud auth]
    C --> E[Google Cloud IAM]
    D --> E
    E --> F[Vertex AI API]
    F --> G[Claude Models]
    
    style E fill:#34a853,color:#fff
    style F fill:#4285f4,color:#fff
    style G fill:#7c3aed,color:#fff
```

**Benefits:**
- No secrets in n8n database
- Centralized IAM management
- Audit trails in Cloud Logging
- Automatic key rotation (ADC)

---

### OpenAI: API Key

```mermaid
graph LR
    A[n8n] --> B[API Key<br/>in Credentials]
    B --> C[OpenAI API]
    C --> D[GPT-4o]
    
    style B fill:#e74c3c,color:#fff
    style C fill:#10a37f,color:#fff
    style D fill:#10a37f,color:#fff
```

**Considerations:**
- API key stored in n8n database
- Manual key rotation needed
- No built-in audit trail
- Simple setup

---

## Deployment Architectures

### Production Deployment: Vertex AI

```mermaid
graph TB
    subgraph "OpenShift Cluster"
        subgraph "n8n Namespace"
            N8N[n8n Pod<br/>StatefulSet]
            PVC[Persistent Volume<br/>Workflow Storage]
        end
        
        subgraph "MCP Namespace"
            MCP[MCP Server Pod<br/>Deployment]
            SA[Service Account<br/>cluster-reader]
        end
        
        N8N --> PVC
        N8N --> MCP
        MCP --> SA
    end
    
    subgraph "Google Cloud"
        N8N --> WorkloadIdentity[Workload Identity]
        WorkloadIdentity --> GSA[Google Service Account]
        GSA --> VertexAI[Vertex AI API]
    end
    
    subgraph "External"
        N8N --> AWS[AWS ROSA<br/>Pricing API]
    end
    
    style VertexAI fill:#4285f4,color:#fff
    style WorkloadIdentity fill:#34a853,color:#fff
    style MCP fill:#ff6b6b,color:#fff
```

**Features:**
- Workload Identity for seamless auth
- No secrets in pods
- HA with StatefulSet
- Persistent workflow storage

---

### Development Deployment: Docker Compose

```mermaid
graph TB
    subgraph "Docker Compose"
        N8N[n8n Container<br/>Port 5678]
        Vol[Volume Mount<br/>~/.n8n]
        Env[Environment<br/>GOOGLE_APPLICATION_CREDENTIALS]
    end
    
    subgraph "Local System"
        Key[Service Account Key<br/>~/vertex-ai-key.json]
        GCloud[gcloud CLI]
    end
    
    N8N --> Vol
    N8N --> Env
    Env --> Key
    N8N -.Optional.-> GCloud
    
    style N8N fill:#2d9cdb,color:#fff
    style Key fill:#f39c12,color:#fff
```

---

## Cost Comparison Architecture

### Vertex AI: Usage-Based + GCP Billing

```mermaid
graph LR
    A[User Query] --> B[n8n Workflow]
    B --> C[Vertex AI API]
    C --> D{Tokens Used}
    D --> E[Input: $3/1M tokens]
    D --> F[Output: $15/1M tokens]
    E --> G[Google Cloud Bill]
    F --> G
    
    G --> H[Consolidated Billing<br/>with other GCP services]
    
    style C fill:#4285f4,color:#fff
    style G fill:#34a853,color:#fff
```

**Typical Cost per Query:**
- Simple query (2K in, 1K out): $0.021
- Complex proposal (10K in, 5K out): $0.12
- **100 queries/month: ~$10-15**

---

### OpenAI: Usage-Based + Separate Billing

```mermaid
graph LR
    A[User Query] --> B[n8n Workflow]
    B --> C[OpenAI API]
    C --> D{Tokens Used}
    D --> E[Input: $2.50/1M tokens]
    D --> F[Output: $10/1M tokens]
    E --> G[OpenAI Bill]
    F --> G
    
    style C fill:#10a37f,color:#fff
    style G fill:#e74c3c,color:#fff
```

**Typical Cost per Query:**
- Simple query (2K in, 1K out): $0.015
- Complex proposal (10K in, 5K out): $0.09
- **100 queries/month: ~$8-12**

---

## Integration Points

### What Both Workflows Connect To

```mermaid
graph TB
    subgraph "Core Workflow"
        N8N[n8n Workflow Engine]
    end
    
    subgraph "AI Layer"
        Vertex[Vertex AI<br/>Claude 3.5 Sonnet]
        OpenAI[OpenAI API<br/>GPT-4o]
    end
    
    subgraph "Data Sources"
        MCP[MCP Server<br/>Live cluster data]
        ROSA[AWS ROSA Pricing<br/>Real-time costs]
        Docs[Red Hat Docs<br/>Best practices]
    end
    
    subgraph "Outputs"
        Chat[Chat UI<br/>Interactive demos]
        Webhook[Webhook<br/>API integration]
        Export[Export<br/>PDF/Markdown]
    end
    
    N8N --> Vertex
    N8N --> OpenAI
    N8N --> MCP
    N8N --> ROSA
    N8N -.Future.-> Docs
    N8N --> Chat
    N8N --> Webhook
    N8N -.Future.-> Export
    
    style Vertex fill:#4285f4,color:#fff
    style OpenAI fill:#10a37f,color:#fff
    style MCP fill:#ff6b6b,color:#fff
    style ROSA fill:#f39c12,color:#fff
```

---

## Future Enhancements

### Planned Architecture Additions

```mermaid
graph TB
    subgraph "Current"
        N8N[n8n Workflow]
        AI[AI Model]
        MCP[MCP Server]
    end
    
    subgraph "Future Additions"
        Cache[Redis Cache<br/>For repeated queries]
        Queue[Message Queue<br/>Async processing]
        Monitor[Prometheus<br/>Usage metrics]
        Slack[Slack Integration<br/>Notifications]
        PDF[PDF Generator<br/>Proposal export]
    end
    
    N8N --> Cache
    N8N --> Queue
    N8N --> Monitor
    N8N -.-> Slack
    N8N -.-> PDF
    
    style Cache fill:#dc143c,color:#fff
    style Queue fill:#9b59b6,color:#fff
    style Monitor fill:#e67e22,color:#fff
    style Slack fill:#4a154b,color:#fff
    style PDF fill:#c0392b,color:#fff
```

---

## Summary

| Aspect | Vertex AI Workflow | OpenAI Workflow |
|--------|-------------------|-----------------|
| **Complexity** | Medium (5 nodes) | Simple (3 nodes) |
| **Auth Flow** | Google Cloud IAM → Vertex AI | API Key → OpenAI |
| **Data Sources** | MCP + AWS Pricing API | MCP only |
| **Best For** | Production, enterprise | Quick demos, testing |
| **Scalability** | High (GCP quotas) | Medium (OpenAI limits) |
| **Cost Tracking** | GCP billing dashboard | Separate OpenAI dashboard |

**Choose based on:**
- **Your cloud provider:** GCP → Vertex AI, Other → OpenAI
- **Your requirements:** Production → Vertex AI, Demo → OpenAI
- **Your preference:** No API keys → Vertex AI, Simple → OpenAI
