// Embedded in n8n "Scenario Router" Code node (copy when editing in UI).
const item = $input.first().json;
const raw = item.chatInput ?? item.input ?? item.text ?? '';
const text = String(raw).toLowerCase();

const scenarios = {
  3: {
    label: 'Migration Analysis',
    name: 'EKS/AKS vs ROSA Comparison',
    sections:
      '## Executive Summary\n## Current State (EKS/AKS)\n## Proposed ROSA Architecture\n## Cost Comparison (table: Line item | Current | ROSA | Delta)\n## Feature Comparison (table: Feature | EKS/AKS | ROSA | Notes)\n## Migration Plan (Phase 1/2/3 with timelines)\n## Risks & Mitigations\n## Recommendation',
    mcp: false,
    extras: 'Include mermaid architecture diagram. Cost table ≥6 rows. Feature table ≥8 rows.',
  },
  2: {
    label: 'Optimization Report',
    name: 'Cluster Optimization',
    sections:
      '## Executive Summary\n## Current State (from MCP)\n## Critical Issues (P1)\n## Recommendations (P1/P2/P3 with oc/kubectl)\n## Cost Impact\n## Next Steps (30/60/90 day)',
    mcp: true,
    extras: 'Current State must cite ≥5 real objects from MCP (pods, nodes, namespaces, PVCs, or quotas). Each P1 item needs a concrete fix command.',
  },
  1: {
    label: 'Proposal',
    name: 'Pre-Sales Discovery Proposal',
    sections:
      '## Executive Summary\n## Requirements Summary\n## Recommended Architecture\n## Node Sizing & Rationale\n## Required Operators & Integrations\n## Network & Storage\n## Cost Estimate (monthly table + 3-year TCO)\n## Security & Compliance\n## Implementation Timeline\n## Next Steps',
    mcp: false,
    extras: 'Include mermaid diagram (multi-AZ). Cost table ≥6 line items. Explain sizing math for workers.',
  },
};

let id = 1;
if (/\b(eks|aks)\b/.test(text) && /(migrat|compar|vs\.?\s*rosa|competitive|retailco)/.test(text)) {
  id = 3;
} else if (
  /(optimiz|cluster optimization|inspect.*cluster|use mcp|oomkill|resourcequota|production-rosa|techcorp|soc2 audit|audit in)/.test(
    text,
  )
) {
  id = 2;
} else if (/(discovery|proposal|evaluat|considering openshift|acme|pre-sales|presales)/.test(text)) {
  id = 1;
}

const s = scenarios[id];
const isBriefChat =
  raw.trim().length < 80 &&
  !/(discovery|optimiz|eks|aks|cluster|migrat|proposal|rosa|openshift)/i.test(raw);

const depthBlock = isBriefChat
  ? 'Reply in 2-4 sentences only.'
  : [
      'DEPTH (mandatory — do not skip sections):',
      '- Target 1200-1800 words total.',
      '- Every ## section: ≥5 bullets OR a table with ≥4 rows.',
      '- Executive Summary: 3-5 sentences with customer name and key outcome.',
      s.extras,
    ].join('\n');

const pricingHint =
  id !== 2
    ? '\nPricing anchors (us-east-1, approximate): ROSA control plane ~$350/mo/cluster; m5.2xlarge ~$280/mo; r5.xlarge ~$220/mo; gp3 storage ~$0.08/GB-mo. Show calculations.'
    : '';

const router = [
  '',
  '---',
  '[WORKFLOW ROUTER]',
  `Scenario ${id}: ${s.name}`,
  'Use these section headers in order:',
  s.sections,
  depthBlock,
  s.mcp
    ? 'MANDATORY: Call MCP/kubernetes tools first. Do not invent cluster state.'
    : 'Do not call MCP unless the user asks about the live cluster.',
  'Grounding: every section must reference facts from the user message (company, numbers, dates, regions).',
  pricingHint,
  '---',
].join('\n');

return {
  json: {
    ...item,
    chatInput: `${raw}${router}`,
    input: `${raw}${router}`,
    scenarioId: id,
    scenarioLabel: s.label,
    scenarioName: s.name,
    mcpRequired: s.mcp,
  },
};
