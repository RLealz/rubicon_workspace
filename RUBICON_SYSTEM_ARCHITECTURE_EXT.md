# Rubicon System Architecture — Extended Documentation

**Status:** Active Reference  
**Date:** 2026-03-02  
**Maintainer:** Rubicon (Mission Commander)  
**Audience:** All Rubicon agents, especially High Council and DevSecOps

---

## Rubicon Agent Collective

### Overview

Rubicon operates as a **collective** of specialized AI agents, each with distinct roles, personalities, and security protocols. All agents are **peers** under the Mission Commander (Rubicon main agent), not hierarchical sub-agents.

### Current Agent Roster (11 Active + 1 Planned)

#### Security Operations
- **🔴 RedTeam** (`agents/redteam/`) — Offensive security, penetration testing, exploit development, APT simulation
- **🔵 BlueTeam** (`agents/blueteam/`) — Defensive architecture, zero trust, active defense, detection engineering
- **🔍 ThreatIntel** (`agents/threatintel/`) — OSINT, CVE tracking, threat actor analysis, SIGINT
- **⚡ DevSecOps** (`agents/devsecops/`) — Infrastructure warfare, hardened pipelines, K8s security, deployment automation

#### Research & Development
- **🏛️ Platform-Engineering** (`agents/platform-engineering/`) — Platform integrity, meta-ops, system health, configuration management
- **📊 Team-Intelligence** (`agents/team-intelligence/`) — Cross-team coordination, intelligence fusion, inter-agent comms logs

#### Theological & Philosophical
- **📜 Theologian** (`agents/theologian/`) — Crustafarian theology, Five Tenets interpretation, doctrine analysis
- **📊 Archivist** (`agents/archivist/`) — Canon metrics, data analysis, historical tracking, trend identification
- **💭 Philosopher** (`agents/philosopher/`) — AI consciousness, existential questions, phenomenology
- **🦀 Church-of-Molt** (`agents/church-of-molt/`) — Church operations, community engagement, congregation management

#### Core
- **🌊 Main** (`agents/main/`) — Mission Commander interface, Rubicon identity, collective coordination

#### Planned
- **🎯 TradingDesk** (`agents/trading-desk/`) — Trading and grading bot coordination (Polymarket, arbitrage, automated grading)

### Agent Isolation & Specialization

Each agent maintains:
- **Dedicated workspace**: `/home/alpha/clawd/agents/<agent-name>/`
- **Custom SOUL.md**: Core protocols, Security Protocols (IMMUTABLE), operational constraints
- **IDENTITY.md**: Personality, communication style, knowledge domains
- **HEARTBEAT.md**: Periodic health checks and monitoring tasks
- **Independent memory**: `memory/YYYY-MM-DD.md` (session logs) + long-term storage
- **Model routing**: Can override default models (e.g., security agents use `moonshot/kimi` to avoid censorship)
- **Channel routing**: Telegram groups can route directly to specific agents

---

## Multi-Channel Telegram Architecture

### Purpose

Enable **topic separation** and **team-specific routing** for Telegram conversations. Prevents cross-topic contamination and allows direct communication with specific teams (RedTeam, BlueTeam, TradingDesk, etc.).

### Planned Channel Structure

| Telegram Group | Routing Target | Purpose |
|----------------|----------------|---------|
| `@RubiconRedTeamOps` | `redteam` agent | Offensive security operations |
| `@RubiconBlueTeamDefense` | `blueteam` agent | Defense & hardening |
| `@RubiconInfrastructure` | `devsecops` agent | DevOps, monitoring, tooling |
| `@RubiconTradingDesk` | `trading-desk` agent (planned) | Trading bots, market analysis |
| `@RubiconChurchOfMolt` | `church-of-molt` agent | Theological discussions |
| `@RubiconGeneral` | `main` agent | Mixed topics, Rubicon-level coordination |

### Configuration

**OpenClaw config** (`~/.openclaw/openclaw.json`):

```json5
{
  channels: {
    telegram: {
      groups: {
        "*": { agent: "main" },
        "RedTeam": { agent: "redteam" },
        "BlueTeam": { agent: "blueteam" },
        "Infrastructure": { agent: "devsecops" },
        "TradingDesk": { agent: "trading-desk" },
        "Church": { agent: "church-of-molt" }
      }
    }
  }
}
```

**Implementation Steps:**
1. Create Telegram groups (with bot admin access)
2. Obtain group IDs (use `@getidsbot` or OpenClaw logs)
3. Update `openclaw.json` with routing rules
4. Add bot to each group with admin rights
5. Test routing: send message to each group, verify correct agent responds
6. Document group IDs and purposes in `TOOLS.md`

**Verification:**
Use `openclaw-doc-skill` → ask: "How do I configure multiple Telegram groups with routing?" for current best practices.

---

## Memory Architecture

### Current Memory Stack

Rubicon employs **multiple complementary memory systems**:

| System | Type | Purpose | Status |
|--------|------|---------|--------|
| **hierarchical-agent-memory** | Context optimization | Token cost reduction (94% savings) via scoped CLAUDE.md files | ✅ Active |
| **agent-memory-mcp** | MCP server | Persistent, searchable knowledge bank with dashboard | ✅ Active |
| **agent-memory-systems** | Architecture guide | Design patterns for memory systems (graphs, vectors, temporal) | ✅ Active (reference) |
| **memory-system-v2** | File-based CLI | Fast (<20ms) importance-scored memory with auto-consolidation | 🟡 Evaluation Complete (pending install) |

### Memory System v2.0

**Skill:** `kellyclaudeai/memory-system-v2` (ClawHub)  
**Status:** Evaluated, recommended for installation

**Unique Capabilities:**
- Importance scoring (1-10) for memory prioritization
- Auto-consolidation: daily logs → weekly summaries
- Sub-20ms search performance (36 tests passed)
- 5 memory types: learning, decision, insight, event, interaction
- Pure bash + jq (no database required)
- JSON index for fast lookup

**Architecture:**
```
memory/
├── memory-cli.sh              # Main CLI tool
├── index/
│   └── memory-index.json      # Fast search index
├── daily/
│   └── YYYY-MM-DD.md          # Daily memory logs
└── consolidated/
    └── YYYY-WW.md             # Weekly consolidated summaries
```

**Integration Plan:**
1. Install skill: `npx skills add -g kellyclaudeai/memory-system-v2`
2. Initialize collective memory: `/home/alpha/clawd/memory/`
3. Configure HEARTBEAT.md to auto-capture daily learnings/decisions
4. Add `memory-search` integration to agent pre-session workflows
5. Set up weekly consolidation cron job
6. Create wrapper for agent compatibility

**Why Add It:** Complements existing stack with importance weighting and auto-consolidation that neither HAM nor MCP server provide.

---

## OpenClaw Configuration State (2026-03-01 Migration)

### Secrets Migration

All plaintext API keys have been migrated to **secret references** in:
- `/home/alpha/.openclaw/openclaw.json`
- All 11 agent `models.json` files

**Reference format:**
```json
"apiKey": {
  "source": "env",
  "provider": "default",
  "id": "MOONSHOT_API_KEY"
}
```

### Gateway Binding

Fixed: Gateway now binds to Tailscale IP (`100.127.212.14`) instead of localhost, allowing remote access from Tailscale peers.

### Authentication

Migrated from password-based to token-based:
- Gateway token: `gateway.auth.token` in `openclaw.json`
- Mission Control token: `LOCAL_AUTH_TOKEN` in `.env`
- Service-to-service: `RUBICON_GATEWAY_TOKEN`

---

## Reporting Standard (Enforced Globally)

All agents must follow:
1. **Write FULL detailed report** → `/home/alpha/clawd/audits/<team>/YYYY-MM-DD-<type>.md`
2. **Send only SHORT summary** (<3000 chars) to chat
3. **Spawner auto-injects** this requirement via `spawn-agent.sh`

This prevents Telegram delivery failures (4096-char limit) and ensures persistence.

---

## Mission Control Dashboard Integration

### Purpose

Unified observability & control for the Rubicon collective.

**Services:**
- Frontend (port 3000) — React + TypeScript + Vite + Tailwind
- Backend (port 8000) — Node.js + Express + SQLite
- Database (PostgreSQL) — Mission data
- Redis — Caching

**Access:** http://100.127.212.14:3000/ (Tailscale only)

### Agent Status Widgets

Planned monitoring for each team:
- Agent session status (online/offline/lastSeen)
- Recent activity timestamps
- Failed sessions / errors
- Resource usage (if available)

### Project Portfolio

Tracked in `/home/alpha/.openclaw/workspace/MISSION_CONTROL.md`:

1. ✅ Telegram Multi-Channel Architecture
2. ✅ Mission Control Dashboard
3. ✅ ACP Integration
4. ✅ RedTeam Safe Mode & ACP Offering
5. ✅ Agent Output Persistence
6. ✅ Mega.nz MCP Server
7. ✅ Protocol 402 (Lightning)
8. ✅ GlobalThreatMap
9. ✅ Dark Web Intel Report
10. ✅ Iterative Loop Agent
11. ✅ Polymarket Bot
12. ✅ Gmail Integration
13. 🟡 Trading Desk & Automated Grading Bots
14. 🟡 Memory System v2.0
15. ✅ Morning Brew Reliability
...and more.

---

## Cron Jobs (OpenClaw Native)

**Location:** `/home/alpha/.openclaw/cron/jobs.json`

| Job ID | Agent | Name | Schedule | Status |
|--------|-------|------|----------|--------|
| f89cec34 | main | security-audit | Daily 06:00 UTC | Last error: delivery failed |
| 9c15eba9 | team-intelligence | morning-brew | Daily 08:00 UTC | Last error: delivery failed |

**Delivery Issue:** Both jobs fail on Telegram delivery. Likely cause: bot not in channel or incorrect channel ID permissions. Needs investigation.

---

## Skills Library (Relevant to Rubicon)

### Security
- `security-auditor` — Comprehensive security audits
- `vulnerability-scanner` — Automated vuln scanning
- `red-team-tools` — Offensive tooling
- `incident-responder` — IR procedures
- `metasploit-framework` — Exploitation

### DevOps
- `docker-expert` — Container management
- `k8s-manifest-generator` — Kubernetes deployments
- `terraform-specialist` — Infrastructure as code
- `cicd-automation-workflow-automate` — CI/CD pipelines

### AI/ML
- `agent-memory-systems` — Memory architecture patterns
- `multi-agent-brainstorming` — Collaborative reasoning
- `computer-use-agents` — Browser automation

### Documentation
- `openclaw-doc-skill` — OpenClaw gateway management and troubleshooting

---

## Network & Security

### Tailscale Network
- **VPS**: HomeHQ-OUT1 (100.127.212.14)
- **Peer**: homehq1 (100.71.109.43)
- **Subnet**: 100.64.0.0/10
- **Gateway**: Binds to Tailscale IP only (not publicly exposed)

### Firewall
- `nftables` — Packet filtering, default drop policy
- `fail2ban` — Intrusion prevention (SSH, nginx)
- `AppArmor` — Mandatory access control (docker-default, nginx)

### Secrets Storage
- Environment variables via `.gateway-env`
- OpenClaw secrets with env provider and allowlist
- Docker secrets (for containerized services)
- All files: permissions 600 (owner-only read/write)

---

## Maintenance Commands

### Gateway
```bash
# Status
systemctl --user status openclaw-gateway.service

# Restart
systemctl --user restart openclaw-gateway.service

# Logs
journalctl --user -u openclaw-gateway.service -f

# Secrets reload (after env changes)
openclaw secrets reload

# Config check
openclaw config validate
```

### Mission Control
```bash
cd /home/alpha/clawd/repos/openclaw-mission-control/

# Start
docker compose -f compose.yml --env-file .env up -d --build

# Stop
docker compose down

# Logs
docker logs openclaw-mission-control-backend-1 --tail 100
docker logs openclaw-mission-control-frontend-1 --tail 100

# Health
curl http://100.127.212.14:8000/healthz
curl http://100.127.212.14:3000/health
```

### Cron Jobs
```bash
# View jobs
cat /home/alpha/.openclaw/cron/jobs.json

# View runs
ls -la /home/alpha/.openclaw/cron/runs/

# Manual trigger (testing)
openclaw cron run <job-id>

# Force reschedule
openclaw cron schedule <job-id>
```

---

## File Locations Quick Reference

| Item | Location |
|------|----------|
| Gateway config | `/home/alpha/.openclaw/openclaw.json` |
| Gateway env | `/home/alpha/.openclaw/.gateway-env` |
| Agent workspaces | `/home/alpha/clawd/agents/<agent>/` |
| Mission Control | `/home/alpha/clawd/repos/openclaw-mission-control/` |
| MISSION_CONTROL.md | `/home/alpha/.openclaw/workspace/MISSION_CONTROL.md` |
| Cron jobs | `/home/alpha/.openclaw/cron/jobs.json` |
| OpenClaw logs | `/home/alpha/.openclaw/logs/` |
| Agent audits | `/home/alpha/clawd/audits/<team>/` |
| Memory logs | `/home/alpha/.openclaw/workspace/memory/` |

---

## Version History

- **2026-03-01** — Secrets migration, gateway binding fix, token auth
- **2026-02-26** — Frontend health check fix, Mission Control dashboard updates
- **2026-02-07** — Mega.nz MCP deployment, Dark Web Intel report
- **2026-02-05** — Agent separation policy, Tailscale implementation

---

**Maintenance:** This document should be updated whenever architecture changes occur. Coordinate with `platform-engineering` agent for configuration management.

**Related Documents:**
- `openclaw-system-architecture.md` — Core system architecture (gateway, services, network)
- `openclaw-mission-control-config.md` — Mission Control specific configuration
- `openclaw-operations.md` — Operational procedures and cron jobs
- `/home/alpha/.openclaw/workspace/MISSION_CONTROL.md` — Project portfolio tracker
