# OpenShift Solution Architect Demo (Minimal Share Package)

> Developed using Claude (Anthropic) — workflows, demo scripts, and documentation in this repository utilize Claude-assisted development to accelerate delivery.

This repo includes only the files needed to run the Solution Architect demo once your ROSA cluster already has n8n and MCP available (for example via Operator install).

## Included

- `demo-scripts/QUICK-START-GUIDE.md`
- `demo-scripts/SOLUTION-ARCHITECT-DEMO-SCRIPT.md`
- `demo-scripts/SAMPLE-INPUTS.md`
- `demo-scripts/README.md`
- `workflows/02-discovery-architect-openai.json`
- `workflows/03-solution-architect-unified.md`
- `docs/sample-queries.md`
- `docs/troubleshooting.md`

## Quick Usage

1. Open n8n in your ROSA cluster.
2. Import `workflows/02-discovery-architect-openai.json`.
3. Configure LLM credentials in n8n.
4. Configure MCP Client URL to your in-cluster MCP endpoint.
5. Use sample prompts from `demo-scripts/SAMPLE-INPUTS.md`.

## Notes

- Setup/deployment scripts are intentionally excluded from this minimal package.
- Secrets and local session files are ignored via `.gitignore`.
