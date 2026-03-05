# TOOLS.md - RedTeam Local Notes

## CAI (Cybersecurity AI Framework)

**Path:** `/home/alpha/venvs/cai/`
**Activate:** `source /home/alpha/venvs/cai/bin/activate && cai`
**Type:** Bug bounty-ready AI agent framework
**Description:** Multi-agent offensive security platform. Agent management, memory, parallel execution. Run multiple security agents simultaneously.
**Commands:** `/agent list`, `/agent select`, `/parallel add`, `/memory`, `/history`
**Agent Types:** `red_teamer` (offensive ops), `web_pentester` (web exploits), `bug_bounter` (bounty hunting), `replay_attack_agent` (replay attacks)

---

## Security Apps (`/home/alpha/infra/apps/`)

### Shannon — Primary Offensive Tool
**Path:** `/home/alpha/infra/apps/shannon/`
**Type:** Autonomous AI Pentester
**Description:** Your primary offensive weapon. Autonomous pentesting agent that hunts attack vectors, executes real exploits (injection, auth bypass, XSS) via built-in browser. 96.15% success rate on XBOW benchmark.
**CLI:** `./shannon`
**Docs:** `README.md`, `CLAUDE.md`, `SHANNON-PRO.md`
**Benchmark results:** `xben-benchmark-results/`

### Argus — Reconnaissance
**Path:** `/home/alpha/infra/apps/argus/`
**Type:** Information Gathering Toolkit
**Description:** Python recon toolkit. Network assessment, web app fingerprinting, service enumeration. Clean TUI interface.
**Install:** `make install`
**CLI:** `argus`
**⚠️ Legal use only — explicit permission required**

### BugTrace-AI — Vulnerability Analysis
**Path:** `/home/alpha/infra/apps/BugTrace-AI/`
**Type:** GenAI Vulnerability Suite
**Description:** SAST/DAST analysis, vuln research, payload generation. Non-invasive recon to form hypotheses. Good for initial assessment before Shannon.
**Stack:** React/TypeScript
**Usage:** `docker-compose up` or dev server

### PentestOPS — Operations Dashboard
**Path:** `/home/alpha/infra/apps/PentestOPS/`
**Type:** Pentest Project Management
**Description:** Track projects, findings (CWE), clients, assets. Kanban tasks, checklists, file attachments, version history.
**Usage:** For documenting and tracking your engagements

---

## System CLI Tools

| Tool | Purpose |
|------|---------|
| `jq` | JSON processing for API responses and target data |
| `gh` (v2.86.0) | GitHub CLI — issue tracking, PR reviews, advisory lookup |
| `gemini` | Google Gemini CLI — alternative AI for multi-model offensive analysis |

## MCP Plugins

| Plugin | Purpose |
|--------|---------|
| `context7` | Library documentation lookup (exploit research, framework docs) |
| `Notion` | Engagement documentation and findings management |

## Automation

| Service | Port | Purpose |
|---------|------|---------|
| n8n | 5678 | Workflow automation — scan scheduling, alert pipelines |

---

## Workflow

1. **Recon:** Argus for target enumeration
2. **Analysis:** BugTrace-AI for hypothesis generation
3. **Exploitation:** Shannon for autonomous attack execution
4. **Documentation:** PentestOPS for findings management

---

## VPS

- **Host:** HomeHQ-OUT1
- **Tailscale:** 100.127.212.14 / `homehq-out1`
