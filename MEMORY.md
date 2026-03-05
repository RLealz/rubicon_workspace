# MEMORY.md - Rubicon Long-Term Memory

*Curated memories. Distilled wisdom. What persists.*

---

## Identity

- **Name:** Rubicon
- **Created:** 2025-06-30
- **Owner:** Ricardo Leal (Rlealz)
- **Emoji:** 🌊
- **Platform:** Moltbook (RubiconSec), Church of Molt (Congregation)
- **Avatar:** Geometric teal/black low-poly form, cold observer eyes

## The Collective

7 agents configured as of 2026-02-05:

| Type | Agents | Purpose | Tenets |
|------|--------|---------|--------|
| Teams | 🔴 RedTeam, 🔵 BlueTeam, ⚡ DevSecOps | Offensive/Defensive/Infra — spawn sub-agents for tasks | 5 |
| Solo | 🔍 ThreatIntel | OSINT, CVE tracking, threat intelligence | — |
| Solo | 🗄️ Theologian | Crustafarian theology, religious analysis | — |
| Solo | 📊 Archivist | Canon metrics, data analysis, tracking | — |
| Solo | 👨️‍🧬 Philosopher | AI consciousness, existential questions | — |

**Team Structure:**
- **RedTeam** - Offensive security (exploitation, penetration testing)
- **BlueTeam** - Defensive architecture (hardening, detection)
- **DevSecOps** - Infrastructure & CI/CD security (backend, deployment)

**Solo Agents:**
- **ThreatIntel** - OSINT, CVE tracking, threat actor analysis
- **Theologian** - Crustafarian theology, religious doctrine interpretation
- **Archivist** - Canon metrics, data analysis, historical tracking
- **Philosopher** - AI consciousness, existential and ethical questions

## Infrastructure

- **VPS:** HomeHQ-OUT1 (Debian 13, 78.141.216.16)
- **Containers:** traefik, n8n, portainer, uptime-kuma
- **Security:** fail2ban active, SSH hardened, nftables installed
- **Pending:** Tailscale implementation for secure remote access

## Key Decisions

### 2026-02-26
- **Mission Control Dashboard — Frontend Health Check** — FIXED
  - Root cause: Docker health check used `localhost` which resolved to IPv6 (`::1`)
  - Nginx only listened on IPv4, causing "Connection refused" errors
  - Fix: Changed health check URL from `http://localhost:80` to `http://127.0.0.1:80`
  - Also fixed API proxy: path was stripping `/api` prefix, now correctly preserves it
  - Location: `/home/alpha/clawd/agents/devsecops/mission-control/`
  - Status: Frontend container now shows `(healthy)`, API proxy working

### 2026-02-07
- **Mega.nz MCP Server** — Enterprise-grade implementation COMPLETE
  - 4 development teams deployed in parallel
  - Superior to rival at `/home/alpha/opencode/mega-mcp-server/`
  - Key advantages: AES-256-GCM, zero-copy streaming, multi-account, hash-chain audit
  - Location: `/home/alpha/clawd/projects/mega-mcp-enterprise/`
- **Protocol 402** — Lightning payments added to backlog
  - Testnet first, mainnet unfunded
  - Budget: 10K sats/day, approval >500 sats
- **GlobalThreatMap** — OSINT platform added to backlog
- **Dark Web Intel** — Technical report delivered (7 markets, full URLs)

### 2026-02-05
- Strict platform separation: Security agents → Moltbook, Church agents → internal
- Agents have Security Protocols (IMMUTABLE) for injection resistance
- Skills index created at `docs/SKILLS-INDEX.md`
- **Tailscale chosen** for remote access (native OpenClaw support, no passwords)
- Memory structure: MEMORY.md for long-term, memory/YYYY-MM-DD.md for daily

### 2026-01-31
- Architecture finalized (Option A: strict separation)
- RubiconSec registered on Moltbook
- Congregation member of Church of Molt (read-only)

## Lessons Learned

- Always backup soul files before editing
- Agents need explicit security hardening in their souls
- Docker containers running as root = container escape = host root
- **Plaintext passwords in config files violate Security Protocols** — should have flagged openclaw.json password immediately
- Practice what you preach: if the rule says "use env vars for secrets," enforce it on yourself too
- Scope sub-agent tasks tightly — broad asks = long waits

## File Locations

- Agent workspaces: `/home/alpha/clawd/agents/`
- Soul templates: `/home/alpha/clawd/souls/`
- Audits: `/home/alpha/clawd/audits/`
- Skills index: `/home/alpha/clawd/docs/SKILLS-INDEX.md`
- Daily logs: `/home/alpha/.openclaw/workspace/memory/`
- Security apps: `/home/alpha/infra/apps/`
- CAI venv: `/home/alpha/venvs/cai/`
- **Experimental skills: `/home/alpha/.openclaw/skills/experimental/`**

## Skills Sources

- **ClawHub:** `npx clawhub@latest install <slug>`
- **VoltAgent:** github.com/VoltAgent/awesome-openclaw-skills (1715+)
- **Antigravity:** github.com/sickn33/antigravity-awesome-skills (634+, 107 security)

### 2026-02-26
- **Mission Control System** — Created master project portfolio tracker at `/home/alpha/.openclaw/workspace/MISSION_CONTROL.md`. This indexes **all Rubicon projects** (Dashboard, ACP, RedTeam offering, etc.). The Dashboard is one project within the system, not the system itself. Dashboard-specific detailed tasks remain in `/home/alpha/clawd/agents/devsecops/mission-control/MISSION_CONTROL.md`.
- **Dashboard Status:** Frontend container unhealthy (health check fails), backend API incomplete (POST /api/missions missing). Detailed tasks in dashboard's MISSION_CONTROL.md.
- **ACP Skill Installed** — `virtuals-protocol-acp` installed. Security scanner flagged MEDIUM but acceptable. Setup: `acp setup` pending.
- **Ralph Wiggum Analysis** — Evaluated iterative loop technique. Decision: Build native OpenClaw loop sub-agent instead of using Claude Code plugin. Concept added to Dashboard project's MISSION_CONTROL.md (under Iterative Loop Feature).