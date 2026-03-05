# TOOLS.md - BlueTeam Local Notes

## CAI (Cybersecurity AI Framework)

**Path:** `/home/alpha/venvs/cai/`
**Activate:** `source /home/alpha/venvs/cai/bin/activate && cai`
**Type:** Bug bounty-ready AI agent framework
**Description:** Multi-agent security platform. Use for adversary simulation and purple team exercises. Run parallel agents to simulate coordinated attacks.
**Commands:** `/agent list`, `/agent select`, `/parallel add`, `/memory`, `/history`
**Agent Types:** `blue_teamer` (defense), `dfir` (forensics), `network_traffic_analyzer` (network monitoring), `memory_analysis_agent` (RAM forensics)

---

## Security Apps (`/home/alpha/infra/apps/`)

### Shannon — Adversary Simulation
**Path:** `/home/alpha/infra/apps/shannon/`
**Type:** Autonomous AI Pentester
**Description:** Use for adversary simulation and testing defenses. Run against staging environments to validate security controls. 96.15% success rate on XBOW benchmark — if Shannon can't break it, you're doing well.
**CLI:** `./shannon`
**Docs:** `README.md`, `CLAUDE.md`

### BugTrace-AI — Defensive Analysis
**Path:** `/home/alpha/infra/apps/BugTrace-AI/`
**Type:** GenAI Vulnerability Suite
**Description:** SAST/DAST analysis from a defensive perspective. Identify what attackers might find before they do. Non-invasive hypothesis generation.
**Usage:** `docker-compose up`

### Argus — Attack Surface Mapping
**Path:** `/home/alpha/infra/apps/argus/`
**Type:** Reconnaissance Toolkit
**Description:** Know your attack surface. Network enumeration, service discovery, web fingerprinting. Use to audit what's exposed.
**CLI:** `argus`

### PentestOPS — Findings Tracking
**Path:** `/home/alpha/infra/apps/PentestOPS/`
**Type:** Security Operations Dashboard
**Description:** Track remediation efforts, findings, assets. CWE database integration. Use to manage vuln lifecycle.

---

## System CLI Tools

| Tool | Purpose |
|------|---------|
| `jq` | JSON processing for log analysis and API responses |
| `gh` (v2.86.0) | GitHub CLI — issue tracking, advisory publishing |
| `openssl` | Certificate verification and TLS inspection |
| `gemini` | Google Gemini CLI — alternative AI for multi-model defensive analysis |

## MCP Plugins

| Plugin | Purpose |
|--------|---------|
| `context7` | Library documentation lookup (security framework docs) |
| `Notion` | Incident documentation and compliance knowledge base |

## Automation

| Service | Port | Purpose |
|---------|------|---------|
| n8n | 5678 | Workflow automation — alert routing, incident playbooks |

---

## Defensive Workflow

1. **Inventory:** Argus to map attack surface
2. **Assess:** BugTrace-AI for vulnerability identification
3. **Validate:** Shannon to test if vulns are exploitable
4. **Track:** PentestOPS to manage remediation
5. **Verify:** Re-run Shannon post-fix

---

## Hardening Reference

- **Fail2ban:** Active on VPS
- **SSH:** Key-only, hardened
- **Tailscale:** `100.127.212.14` / `homehq-out1`
- **nftables:** Installed

---

## VPS

- **Host:** HomeHQ-OUT1
- **IP:** 78.141.216.16
- **Dashboard:** `https://homehq-out1.tail14afce.ts.net`
