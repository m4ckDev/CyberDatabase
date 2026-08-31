# AI and LLM Security

CyberDatabase tracks AI as both a security target and a security toolchain. The synchronized HackTricks AI section currently covers LLM architecture, prompts, MCP servers, AI-assisted fuzzing, model/data preparation, risk frameworks, model-loading risks, and AI-assisted web/security tooling.

## Security review areas

### Model and data lifecycle

Review:

- data provenance and handling;
- training/evaluation data separation;
- sensitive-data exposure;
- model artifact provenance;
- integrity verification for downloaded models;
- serialization/deserialization risks;
- dependency and supply-chain controls;
- access controls around model registries and storage.

Model files should be treated as potentially untrusted artifacts. Load unknown models only in isolated environments and understand the serialization format before execution.

### Prompt and instruction boundaries

AI systems should distinguish trusted system/developer instructions from untrusted user, web, document, email, and tool output.

Test for:

- direct prompt injection;
- indirect prompt injection through retrieved content;
- instruction hierarchy confusion;
- hidden or encoded instructions;
- data exfiltration through model output;
- unauthorized tool invocation;
- cross-user or cross-session data exposure.

### Agents and tool use

Agent security depends heavily on what tools the model can invoke. Review:

- tool permissions;
- filesystem scope;
- network access;
- credential availability;
- command execution boundaries;
- connector/app permissions;
- approval requirements for writes or destructive actions;
- validation of tool output before it is reused as instructions.

Use least privilege. A model that can read the internet should not automatically receive permission to write to production systems.

### MCP and external tool servers

For Model Context Protocol or similar tool servers, document:

- server origin and trust level;
- transport and authentication;
- available functions;
- secrets or tokens exposed to the server;
- filesystem/network permissions;
- whether tool descriptions or returned content can influence subsequent model behavior;
- logging and auditability.

Treat third-party MCP servers as software dependencies, not as harmless prompt extensions.

### AI-assisted security testing

AI can assist with code review, fuzzing, test-case generation, log triage, detection engineering, and vulnerability research. Human validation remains required for scanner findings, exploitability claims, severity, and remediation recommendations.

Do not allow an AI agent to expand testing scope merely because it discovered another target.

### AI risk frameworks

Maintain a risk model that covers:

- confidentiality;
- integrity;
- availability;
- safety and misuse;
- privacy;
- supply chain;
- authorization;
- auditability;
- model/data provenance;
- agent/tool permissions.

Map controls to the actual system architecture rather than treating "AI" as one component.

## CyberDatabase AI layout

- `../../AI/` — AI tools, skills, agent material, and AI-focused projects.
- `../../AI/Claude-Skills/` — synchronized Claude Skills collection.
- `../../imports/multi-llm-router/` — multi-provider LLM routing infrastructure.
- `../ai-security/` — CyberDatabase-authored AI security notes and defensive guidance.
- `../../references/hacktricks-upstream/src/AI/` — synchronized HackTricks AI source.

## Current HackTricks AI source topics

The current upstream AI tree includes material covering:

- AI-assisted fuzzing and vulnerability discovery;
- Burp/MCP integration;
- deep-learning concepts;
- MCP servers;
- model data preparation and evaluation;
- model-loading/RCE risk research;
- prompts;
- reinforcement, supervised, and unsupervised learning concepts;
- AI risk frameworks;
- LLM architecture;
- AI-assisted web pentesting tooling.

Use the generated HackTricks index for the current complete list.

## Defensive checklist

```text
[ ] Identify every model, agent, tool, connector, and data source
[ ] Classify trusted vs untrusted input channels
[ ] Minimize tool and connector permissions
[ ] Isolate untrusted model artifacts
[ ] Protect API keys and service credentials
[ ] Log tool calls and consequential actions
[ ] Validate retrieved content before reuse
[ ] Test direct and indirect prompt injection
[ ] Test data leakage and cross-user isolation
[ ] Review dependency/model supply chain
[ ] Define human approval points
[ ] Document incident response for AI-specific failures
```

## Source relationship

The complete synchronized HackTricks AI material is maintained at `../../references/hacktricks-upstream/src/AI/`.
