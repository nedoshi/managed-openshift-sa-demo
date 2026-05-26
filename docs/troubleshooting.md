# Troubleshooting Guide

Common issues during demo setup and live presentations, with fixes.

---

## MCP Server Issues

### MCP Server Won't Start

**Symptom:**
```bash
curl http://localhost:8081/healthz
# curl: (7) Failed to connect to localhost port 8081
```

**Diagnosis:**
```bash
# Check if MCP server process is running
ps aux | grep kubernetes-mcp-server

# Check logs
tail -f /tmp/mcp-server.log

# Check port conflicts
lsof -i :8081
```

**Common causes:**

1. **Port already in use:**
   ```bash
   # Kill existing process
   pkill -f kubernetes-mcp-server
   
   # Or use different port
   MCP_PORT=8082 ./scripts/quick-demo-setup.sh
   ```

2. **Kubeconfig not found:**
   ```bash
   # Verify file exists
   ls -la ~/.kube/mcp-openshift-viewer.kubeconfig
   
   # Test kubeconfig
   oc --kubeconfig ~/.kube/mcp-openshift-viewer.kubeconfig get nodes
   ```

3. **kubernetes-mcp-server not installed:**
   ```bash
   # npx will auto-install, but verify Node.js is working
   node --version  # Should be v18+ or v20+
   npx -y kubernetes-mcp-server --version
   ```

4. **Wrong KUBECONFIG environment variable:**
   ```bash
   # Ensure KUBECONFIG points to viewer config, not admin
   echo $KUBECONFIG
   
   # Restart with explicit path
   KUBECONFIG=$HOME/.kube/mcp-openshift-viewer.kubeconfig \
     npx -y kubernetes-mcp-server --read-only --port 8081
   ```

---

### MCP Server Returns "Forbidden" Errors

**Symptom:**
Agent responds: "Error: Forbidden - insufficient permissions"

**Diagnosis:**
```bash
# Check RBAC permissions
oc auth can-i list pods \
  --as=system:serviceaccount:mcp:mcp-viewer \
  --all-namespaces

# Check ClusterRoleBinding
oc get clusterrolebinding mcp-viewer-view -o yaml
```

**Fixes:**

1. **ClusterRoleBinding missing:**
   ```bash
   oc create clusterrolebinding mcp-viewer-view \
     --clusterrole=view \
     --serviceaccount=mcp:mcp-viewer
   ```

2. **Wrong ServiceAccount in kubeconfig:**
   ```bash
   # Verify token belongs to correct ServiceAccount
   oc --kubeconfig ~/.kube/mcp-openshift-viewer.kubeconfig whoami
   # Should show: system:serviceaccount:mcp:mcp-viewer
   ```

3. **Trying to access forbidden resources:**
   - `view` ClusterRole cannot read Secrets content (only metadata)
   - Cannot access some cluster-scoped resources
   - This is intentional (read-only security)

---

### Token Expired

**Symptom:**
```
Error: Unauthorized - token expired
```

**Quick fix:**
```bash
# Regenerate token and restart MCP server
./scripts/rotate-token.sh
```

**Manual fix:**
```bash
# Generate new token
TOKEN=$(oc create token mcp-viewer --duration=8h -n mcp)

# Update kubeconfig (macOS)
sed -i '' "s/token: .*/token: ${TOKEN}/" \
  ~/.kube/mcp-openshift-viewer.kubeconfig

# Restart MCP server
pkill -f kubernetes-mcp-server
KUBECONFIG=~/.kube/mcp-openshift-viewer.kubeconfig \
  npx -y kubernetes-mcp-server --read-only --port 8081
```

**Prevention:**
- Set up cron job to rotate token every 7 hours
- Use longer duration for demos: `--duration=24h`
- Consider using projected ServiceAccount tokens (auto-rotating)

---

## n8n Workflow Issues

### Workflow Won't Import

**Symptom:**
"Invalid workflow JSON" error when importing

**Fixes:**

1. **Credential ID mismatch:**
   - Open JSON file in editor
   - Find: `"REPLACE_WITH_YOUR_CLAUDE_CREDENTIAL_ID"`
   - You can leave it as-is and update in n8n UI after import
   - Or replace with actual credential ID from n8n

2. **n8n version too old:**
   - Workflows require n8n v1.20.0+ (for MCP Client node)
   - Update n8n: `npm install -g n8n@latest`

3. **Missing MCP Client node:**
   - Ensure n8n has LangChain nodes enabled
   - Check n8n settings → Community nodes

---

### "No Chat Model Configured" Error

**Symptom:**
Agent node shows red error badge

**Fix:**
1. Open workflow
2. Click **AI Agent** node
3. Under **Model** section, click **+**
4. Select **Claude Chat Model** (or Ollama)
5. Configure credentials
6. Click **Save**

---

### MCP Client Connection Failed

**Symptom:**
n8n logs show: "Failed to connect to MCP server"

**Diagnosis:**
```bash
# From the machine running n8n, test MCP endpoint
curl -v http://localhost:8081/sse

# If n8n is in Docker/Podman container:
podman exec -it n8n curl http://host.docker.internal:8081/sse
```

**Fixes:**

1. **n8n running in container:**
   - Can't use `localhost` or `127.0.0.1`
   - Use `host.docker.internal` (Docker Desktop)
   - Or use host IP address: `http://192.168.1.100:8081/sse`

2. **MCP server not accessible:**
   ```bash
   # Test from n8n's perspective
   # If n8n is in container:
   podman exec -it n8n ping <mcp-server-ip>
   ```

3. **Firewall blocking:**
   - Check firewall rules on MCP server host
   - Ensure port 8081 is open to n8n

4. **Wrong URL in workflow:**
   - Should be: `http://<host>:8081/sse` (note `/sse` endpoint)
   - Not: `http://<host>:8081` (missing /sse)

---

### Agent Gives Generic Responses (Not Using MCP)

**Symptom:**
Agent responds with generic Kubernetes knowledge instead of cluster-specific data

**Diagnosis:**
This means the agent is NOT calling MCP tools.

**Fixes:**

1. **MCP Client not connected to Agent:**
   - In workflow, verify connection line from **MCP Client** → **AI Agent**
   - Connection type should be: `ai_tool` (not `main`)

2. **Agent configured to not use tools:**
   - Click **AI Agent** node
   - Under **Options** → ensure "Require Specific Output Format" is OFF
   - Check that **Tools** section shows MCP Client

3. **Agent doesn't think it needs cluster data:**
   - Rephrase query to be more specific:
     - ❌ "Tell me about Kubernetes"
     - ✅ "List all pods in namespace openshift-monitoring"

4. **Check n8n execution logs:**
   - Workflow → Executions tab
   - Look for MCP tool calls in execution data
   - If no tool calls, agent chose not to use MCP

---

## OpenShift / Cluster Issues

### Cannot Connect to Cluster

**Symptom:**
```bash
oc whoami
# error: You must be logged in to the server (Unauthorized)
```

**Fixes:**

1. **Token expired:**
   ```bash
   # For ROSA
   rosa login
   rosa describe cluster <cluster-name>
   # Get console URL, log in via browser, copy login command
   
   # For ARO
   az aro list-credentials --name <cluster> --resource-group <rg>
   ```

2. **VPN required:**
   - Some clusters require VPN connection
   - Check with cluster admin

3. **Cluster API not reachable:**
   ```bash
   # Test connectivity
   curl -k https://api.<cluster-domain>:6443/healthz
   ```

---

### Demo Namespace Issues

**Symptom:**
Agent says "namespace not found" for demo queries

**Fix:**
```bash
# Create demo namespace
oc create namespace demo-app

# Deploy sample workload
oc run nginx --image=nginx:latest -n demo-app
oc run broken-pod --image=invalid-image:latest -n demo-app

# Create some sample resources
oc create deployment webapp --image=httpd:latest -n demo-app
oc expose deployment webapp --port=80 -n demo-app
oc create route edge webapp --service=webapp -n demo-app
```

---

## Live Demo Failures

### Agent Takes Too Long to Respond

**Causes:**
- Large cluster (thousands of pods)
- Agent making multiple sequential tool calls
- Claude API rate limiting

**Mitigations:**

1. **Scope queries to specific namespace:**
   - ❌ "List all pods in the cluster"
   - ✅ "List pods in namespace demo-app"

2. **Use faster model (during development):**
   - Switch to Claude Haiku (faster, less accurate)
   - Or GPT-4o mini

3. **Pre-warm the demo:**
   - Run a simple query before customer arrives
   - Keeps MCP server + LLM warm

---

### Agent Hallucinates or Gives Wrong Info

**Symptom:**
Agent confidently states incorrect facts about the cluster

**Immediate fix during demo:**
"Let me verify that with a direct cluster query..."
```bash
# Run actual oc command to show ground truth
oc get pods -n <namespace>
```

**Root causes:**

1. **Agent not using MCP tools:**
   - See "Agent Gives Generic Responses" above

2. **Ambiguous query:**
   - Be specific about what you want
   - Include namespace, resource type

3. **Model temperature too high:**
   - Edit workflow → Claude Chat Model → Options → Temperature: 0.2
   - Lower = more factual, less creative

---

### Workflow Execution Stuck

**Symptom:**
Chat shows "Thinking..." forever, never responds

**Fixes:**

1. **Check n8n logs:**
   ```bash
   # If running as service
   journalctl -u n8n -f
   
   # If running in foreground
   # Look at terminal output
   ```

2. **MCP server hung:**
   ```bash
   # Restart MCP server
   pkill -f kubernetes-mcp-server
   ./scripts/rotate-token.sh  # This restarts it
   ```

3. **Force stop execution:**
   - n8n UI → Executions → Running → Click execution → Stop

4. **Restart n8n:**
   ```bash
   # If running as service
   systemctl restart n8n
   
   # If in container
   podman restart n8n
   ```

---

## Claude API Issues

### Rate Limit Errors

**Symptom:**
```
Error: Rate limit exceeded
```

**Fixes:**

1. **Wait 60 seconds** (rate limit resets)

2. **Check your tier:**
   - https://console.anthropic.com/settings/limits
   - Free tier: 5 requests/minute
   - Paid tier: 50+ requests/minute

3. **Upgrade API tier** (before important demos)

4. **Switch to Ollama** temporarily:
   - Edit workflow
   - Replace Claude Chat Model node with Ollama Chat Model
   - Point to Ollama server

---

### Claude API Key Invalid

**Symptom:**
```
Error: Invalid API key
```

**Fix:**
1. Get new API key: https://console.anthropic.com/settings/keys
2. n8n → Credentials → Claude API → Edit
3. Paste new key
4. Test connection
5. Re-run workflow

---

## Ollama Fallback Issues

### Ollama Not Reachable from n8n

**Symptom:**
```
Error: connect ECONNREFUSED 127.0.0.1:11434
```

**Diagnosis:**
```bash
# Check if Ollama is running
ps aux | grep ollama

# Check binding
lsof -i :11434
```

**Fixes:**

1. **Ollama bound to localhost only:**
   ```bash
   # Restart Ollama to bind to all interfaces
   pkill ollama
   OLLAMA_HOST=0.0.0.0 ollama serve &
   ```

2. **Get host IP:**
   ```bash
   # macOS
   ipconfig getifaddr en0
   
   # Linux
   hostname -I | awk '{print $1}'
   ```

3. **Update n8n workflow:**
   - Edit **Ollama Chat Model** node
   - Base URL: `http://<host-ip>:11434`
   - Example: `http://192.168.1.100:11434`

---

### Model Not Downloaded

**Symptom:**
```
Error: model "qwen3:8b" not found
```

**Fix:**
```bash
# Pull the model
ollama pull qwen3:8b

# Or use a model you already have
ollama list

# Update workflow to use available model
```

---

## Pre-Demo Checklist

Run this 15 minutes before demo:

```bash
# 1. Verify cluster access
oc whoami
oc get nodes

# 2. Check MCP server
curl http://localhost:8081/healthz

# 3. Check token expiry
oc whoami --kubeconfig ~/.kube/mcp-openshift-viewer.kubeconfig

# 4. Test n8n workflow
# Open chat UI, send: "List all namespaces"

# 5. Verify demo namespace exists
oc get namespace demo-app

# 6. Check API limits (if using Claude)
# Visit: https://console.anthropic.com/settings/limits
```

If ANY check fails, run:
```bash
./scripts/quick-demo-setup.sh
```

---

## Emergency Contacts

**MCP Server Issues:**
- GitHub: https://github.com/containers/kubernetes-mcp-server/issues

**n8n Issues:**
- Forum: https://community.n8n.io/
- Docs: https://docs.n8n.io/

**Claude API Issues:**
- Status: https://status.anthropic.com/
- Support: https://support.anthropic.com/

**OpenShift Issues:**
- ROSA Support: Red Hat support portal
- ARO Support: Azure support portal

---

## Debugging Tips

### Enable Verbose Logging

**MCP Server:**
```bash
# Add DEBUG environment variable
DEBUG=* KUBECONFIG=~/.kube/mcp-openshift-viewer.kubeconfig \
  npx -y kubernetes-mcp-server --read-only --port 8081 2>&1 | tee /tmp/mcp-debug.log
```

**n8n:**
```bash
# Set log level to debug
export N8N_LOG_LEVEL=debug
n8n start
```

### Capture Network Traffic

```bash
# Monitor MCP server requests
sudo tcpdump -i lo0 -A -s 0 'tcp port 8081' | tee /tmp/mcp-traffic.log
```

### Test MCP Tools Manually

```bash
# Use MCP inspector (if available)
npx @modelcontextprotocol/inspector \
  kubernetes-mcp-server \
  --kubeconfig ~/.kube/mcp-openshift-viewer.kubeconfig \
  --read-only
```

---

## Known Limitations

1. **MCP Server read-only limitations:**
   - Cannot read Secret values (only metadata)
   - Cannot access some cluster-scoped resources
   - Some OpenShift-specific CRDs may not be fully supported

2. **n8n Chat UI limitations:**
   - Mermaid diagrams may not render (copy to external tool)
   - Long outputs may be truncated
   - No file upload support in chat trigger

3. **Claude API limitations:**
   - 200K token context window (large clusters may exceed)
   - Rate limits on free tier
   - Outputs may be verbose (adjust system prompt)

4. **Token expiry:**
   - Default 8-hour expiry requires rotation
   - No auto-rotation built-in (use cron job)

---

## Getting Help

**Before asking for help, collect:**
1. MCP server logs: `cat /tmp/mcp-server.log`
2. n8n execution data (from Executions tab)
3. OpenShift cluster version: `oc version`
4. Error message (exact text)
5. What you were trying to do
6. What you expected vs what happened

**Where to ask:**
- Internal Slack: #openshift-ai-demos
- GitHub Issues: [Your repo URL]
- Email: [Your support email]
