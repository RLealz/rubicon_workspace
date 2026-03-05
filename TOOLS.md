# TOOLS.md - Local Notes

Skills define _how_ tools work. This file is for _your_ specifics — the stuff that's unique to your setup.

---

## OpenClaw Documentation Skill

**Location:** `/home/alpha/.claude/skills/openclaw-doc-skill/`
**Type:** OpenClaw gateway documentation and troubleshooting
**Description:** Claude Code skill for OpenClaw documentation, safe diagnostics, and troubleshooting. Triggers on "openclaw" mention.
**Usage:** Mention "openclaw" to activate. Can fetch docs, run whitelisted commands, troubleshoot.
**Safe Commands:** `openclaw status`, `openclaw health`, `openclaw doctor`, `openclaw logs --since 5m`, config get/set, `systemctl --user status/restart openclaw-gateway`
**Available To:** Rubicon (self) and High Council agents via sub-agent sessions
**Status:** ✅ Integrated 2026-03-01
**Benefits:** Self-service OpenClaw operations, independent of platform team

---

## CAI (Cybersecurity AI Framework)

**Path:** `/home/alpha/venvs/cai/`
**Version:** 0.5.10
**Activate:** `source /home/alpha/venvs/cai/bin/activate && cai`
**Type:** Bug bounty-ready AI agent framework
**Description:** Multi-agent cybersecurity platform with agent management, memory, parallel execution. Interactive CLI with `/agent`, `/memory`, `/history`, `/parallel` commands.

---

## Experimental Skills

**Location:** `~/.openclaw/skills/experimental/`
**Warning:** Use with caution. These have elevated risk.

### loki-mode
- Autonomous multi-agent system for Claude Code
- Requires `--dangerously-skip-permissions`
- Can spawn unlimited agents
- Set limits before use: `LOKI_MAX_ITERATIONS=10 LOKI_MAX_PARALLEL_AGENTS=3`

---

## Security Apps (`/home/alpha/infra/apps/`)

### Shannon
**Path:** `/home/alpha/infra/apps/shannon/`
**Type:** Autonomous AI Pentester
**Description:** Fully autonomous pentesting agent. Hunts attack vectors in code, executes real exploits (injection, auth bypass) via built-in browser. 96.15% success rate on XBOW benchmark.
**Usage:** `./shannon` CLI or Docker
**Docs:** `README.md`, `CLAUDE.md`, `SHANNON-PRO.md`

### PentestOPS
**Path:** `/home/alpha/infra/apps/PentestOPS/`
**Type:** Pentest Operations Dashboard
**Description:** Full-stack pentest project management. Projects, tasks (Kanban), findings (CWE integration), clients, assets, checklists, file attachments, version history.
**Stack:** Next.js 14, Express, MongoDB, Docker
**Usage:** `docker-compose up` or `npm run dev`

### Argus
**Path:** `/home/alpha/infra/apps/argus/`
**Type:** Reconnaissance Toolkit
**Description:** Python toolkit for information gathering & recon. Network assessment, web app scanning, clean TUI interface.
**Usage:** `make install` then `argus` CLI
**Warning:** Legal use only — explicit permission required

### BugTrace-AI
**Path:** `/home/alpha/infra/apps/BugTrace-AI/`
**Type:** Vulnerability Analysis Suite
**Description:** GenAI-powered SAST/DAST analysis, vuln research, payload generation. Non-invasive recon to form hypotheses for manual investigation.
**Stack:** React/TypeScript, Docker
**Usage:** Docker or `npm run dev`

### Astrix OpenClaw Scanner
**Package:** `astrix-openclaw-scanner` (PyPI)
**Type:** EDR-based OpenClaw Detection
**Description:** Detect OpenClaw AI agent installations via EDR telemetry (CrowdStrike, Microsoft Defender). Pattern matching for `openclaw`, `clawdbot`, `moltbot` in process names/command lines.
**Install:** `pipx install astrix-openclaw-scanner` or venv
**Usage:**
```bash
# CrowdStrike
astrix-openclaw-scanner crowdstrike --client-id <ID> --client-secret <SECRET> --days-back 14

# Microsoft Defender
astrix-openclaw-scanner microsoft_defender --client-id <ID> --client-secret <SECRET> --tenant-id <TENANT_ID>
```
**Output:** HTML report (endpoint table), optional raw JSON
**Use Case:** Threat hunting, compliance audits, RedTeam recon
**Note:** Requires EDR API credentials with read permissions

---

## Infrastructure

### n8n
**Path:** `/home/alpha/infra/apps/n8n/`
**Type:** Workflow Automation

### Portainer
**Path:** `/home/alpha/infra/apps/portainer/`
**Type:** Container Management UI

---

## Contacts (Telegram)

Stored in `/home/alpha/.openclaw/workspace/contacts.json`:
- Artur Silva: `981728773`
- Pedro Pereira: `5587196783`
- Antonio Franco: `1301012151`

---

## VPS

- **Host:** HomeHQ-OUT1
- **IP:** 78.141.216.16
- **Tailscale:** 100.127.212.14 / `homehq-out1`
- **Dashboard:** `https://homehq-out1.tail14afce.ts.net`

---

## Email Services

### AgentMail
**Purpose:** Email inbox API for AI agents (two-way email communication)
**Console:** https://console.agentmail.to
**SDK:** `pip install agentmail`
**Use Case:** Dedicated email for Rubicon collective — receives threat intel, CVE alerts, customer reports; can send notifications, status updates, incident reports.

**Quick Setup:**
```python
from agentmail import AgentMail

client = AgentMail(api_key="YOUR_API_KEY")
inbox = client.inboxes.create(
    username="rubicon",      # desired mailbox name
    domain="agentmail.to"    # or your custom domain
)
# inbox.email => "rubicon@agentmail.to"
```

**Integration Points:**
- Email reception → trigger agent actions via webhook
- Outbound notifications from cron jobs (morning brew, security audits)
- Two-way threat intelligence correspondence
- Customer engagement (pentest reports, consulting)

**Security:**
- API key stored in `auth.profiles.agentmail:default` (to be created)
- Use environment variable `AGENTMAIL_API_KEY` in production
- Inbound email parsing → sanitize before processing

**Status:** Pending API key configuration and inbox creation.

---

## Mission Control Dashboard

**Path:** `/home/alpha/clawd/agents/devsecops/mission-control/`
**Type:** Rubicon Collective Observability & Control
**Description:** Comprehensive dashboard for agent collective management. Agent status, mission tracking (Antfarm-inspired), inter-agent comms logs, cron health, tool health, platform warnings, file browser, memory snapshots, manual RPC console.
**Stack:** Node.js + Express + SQLite (backend), React + TypeScript + Vite + Tailwind (frontend)
**Auth:** OpenClaw session + Traefik basic auth + Tailscale
**Real-time:** SSE for logs, polling for status
**Deploy:** `docker-compose up -d`
**URL:** `https://mission-control.tail14afce.ts.net` (Tailscale)

---

## External Pentesting Frameworks

### Zen-AI-Pentest
**Repository:** https://github.com/SHAdd0WTAka/Zen-Ai-Pentest
**Type:** Autonomous AI-powered penetration testing framework
**Description:** Production-grade framework combining LLMs with 20+ security tools (Nmap, SQLMap, Metasploit, BurpSuite, etc.). Features ReAct agent loop, risk engine, exploit validation, CI/CD integration, and cloud deployment.

**Architecture Highlights:**
- **Frontend:** React Dashboard, WebSocket client, CLI
- **Backend:** FastAPI with JWT auth, PostgreSQL, async tasks
- **Agents:** ReAct pattern with memory, tool orchestration, self-correction
- **Risk Engine:** False positive reduction, business impact, CVSS/EPSS scoring
- **Tools:** 20+ integrated (network, web, exploitation, AD, wireless)
- **Validation:** Sandboxed Docker execution, evidence collection, audit trail

**Deployment Options:**
- Docker Compose (recommended)
- Local Python installation
- VirtualBox VM (Kali Linux)
- Cloud: AWS, Azure, GCP

**Use Cases for Rubicon:**
- Standalone pentesting platform (could run parallel)
- Source of inspiration for agent design patterns
- Potential integration via REST API (`/api/v1/scans/`, findings, reports)
- Benchmarking and feature comparison

**Status:** Not integrated. Could be deployed as separate service on VPS (HomeHQ-OUT1) if needed.

---

Add whatever helps you do your job. This is your cheat sheet.
