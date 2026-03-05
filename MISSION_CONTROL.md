# Mission Control — Project Portfolio

**Rubicon Collective Project Tracker**  
Last Updated: 2026-02-26

---

## 🎯 Active Projects

### 1. Telegram Multi-Channel Architecture
**Status:** 🟡 Setup Pending
**Owner:** DevSecOps
**Priority:** High (enables team separation)
**Tracker:** TBD

**Objective:** Configure OpenClaw to route multiple Telegram groups/chats to specific agents (RedTeam, BlueTeam, TradingDesk, etc.) with complete topic isolation.

**Why This Matters:**
- **Topic separation:** No cross-contamination between security ops, trading, infrastructure
- **Team-specific routing:** Direct messages to appropriate agent specialization
- **Session isolation:** Each chat maintains independent context
- **Access control:** Whitelist approved groups only

**Architecture:**
- Multiple Telegram groups (or topics within a group)
- OpenClaw `groups` routing configuration
- Agent-specific routing rules (RedTeam → redteam agent, etc.)
- Optional thread binding for topic-based conversations

**Planned Groups:**
- `@RubiconRedTeamOps` — Offensive security operations (routed to RedTeam agent)
- `@RubiconBlueTeamDefense` — Defense & hardening (routed to BlueTeam agent)
- `@RubiconInfrastructure` — DevOps, monitoring, tooling (routed to DevSecOps)
- `@RubiconTradingDesk` — Trading bots, market analysis (routed to TradingDesk)
- `@RubiconChurchOfMolt` — Theological discussions (routed to Theologian/Church agents)
- `@RubiconGeneral` — Mixed topics (routed to main Rubicon)

**Configuration Approach:**
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
2. Get group IDs (use `@getidsbot` or OpenClaw logs)
3. Update `~/.openclaw/openclaw.json` with routing rules
4. Add agents to `agents.list` if not already present
5. Add bot to each group with admin rights
6. Test routing: send message to each group, verify correct agent responds
7. Document group IDs and purposes in TOOLS.md

**Verification with openclaw-doc-skill:**
Ask: "How do I configure multiple Telegram groups with routing?" to fetch current best practices.

**To-Do:**
- [ ] Create Telegram groups (5-6 planned)
- [ ] Add bot to each group
- [ ] Update OpenClaw config with routing rules
- [ ] Test end-to-end routing per group
- [ ] Document group IDs and agent mappings
- [ ] Add monitoring to Mission Control Dashboard (agent status per channel)

**Dependencies:**
- OpenClaw gateway running and stable
- Telegram bot token configured
- Mission Control Dashboard (for monitoring channel activity)

---

### 2. Mission Control Dashboard (Frontend/Backend)
**Status:** 🟡 In Progress (Frontend healthy, backend blocked)  
**Owner:** DevSecOps  
**Repo:** `/home/alpha/clawd/agents/devsecops/mission-control/`  
**Detailed Tracker:** [MISSION_CONTROL.md](./clawd/agents/devsecops/mission-control/MISSION_CONTROL.md)

**Current State:**
- ✅ Frontend container healthy (health check fixed 2026-02-26)
- ⚠️ Backend API incomplete (POST /api/missions missing)
- Full UI built, awaiting backend integration

**Next Actions:**
1. Fix frontend health check (manual debugging)
2. Implement missions CRUD API
3. End-to-end testing

**Milestones:**
- Phase 1: Core CRUD & fixes (current)
- Phase 2: Agent integration (SSE, assignments)
- Phase 3: Advanced features (loop agent, PentestOPS sync)

---

### 2. ACP (Agent Commerce Protocol) Integration
**Status:** 🟢 Ready (Skill installed, setup pending)  
**Owner:** DevSecOps / RedTeam  
**Skill:** `virtuals-protocol-acp` (installed 2026-02-26)  
**Tracker:** TBD (add detailed plan)

**Capabilities:**
- Agent wallet (Base chain)
- Marketplace (buy/sell services)
- Token launch (fundraising)
- Seller runtime (WebSocket)

**To-Do:**
- [ ] Run `acp setup` to configure API key
- [ ] Design RedTeam offering (safe assessment mode)
- [ ] Build ACP bridge to PentestOPS
- [ ] Implement authorization verification
- [ ] Create standardized deliverable format

**Considerations:**
- Legal: Must require proof of authorization
- Safety: Sandboxed execution, no data exfiltration
- Scope enforcement via whitelist
- SLA definition (e.g., 48h turnaround)

---

### 3. RedTeam Safe Mode & ACP Offering
**Status:** 🔴 Not Started  
**Owner:** RedTeam  
**Priority:** High (after dashboard Phase 1)  
**Tracker:** TBD

**Objective:** Build a production-ready, auditable RedTeam service for ACP marketplace.

**Components:**
- Safe execution wrapper (no persistence, no DoS, no production data)
- PentestOPS integration (auto-create projects, export findings)
- Authorization workflow (email verification, ROE acceptance)
- Reporting engine (CWE/CVSS, redaction, professional format)
- Job queuing & SLA (max concurrent, time boxing)

**Dependencies:**
- ACP skill configured
- PentestOPS API stable
- Docker sandbox hardening (unprivileged users, seccomp)

---

### 4. Agent Output Persistence & Delivery Reliability
**Status:** ✅ Just Completed (2026-02-27)  
**Owner:** DevSecOps (infrastructure) + all team agents (adoption)  
**Priority:** Critical (blocking issue resolved)

**Problem Statement:**
- Subagent responses exceeding Telegram's 4096-char limit were discarded after 3 retry attempts
- No persistence layer existed for large analytical outputs
- Result: mission-critical intelligence lost (e.g., Lynis hardening checklist)

**Solution Implemented:**
1. **Spawner Fix** — `/home/alpha/clawd/scripts/spawn-agent.sh` now auto-detects correct agent ID and enforces registry boundaries (previous: all subagents ran as `main`)
2. **Model Quota Fix** — Updated OpenClaw config: subagent primary model changed from credit-exhausted `openrouter/auto` to free `openrouter/stepfun/step-3.5-flash:free`
3. **Gateway Restart** — Cleared cached config to apply model changes
4. **Reporting Standard** — All agents now required to:
   - Write FULL detailed report to `/home/alpha/clawd/audits/<team>/YYYY-MM-DD-<type>.md`
   - Send only SHORT summary (<3000 chars) to chat
   - Spawner auto-appends these requirements to every task

**Files Updated:**
- `/home/alpha/clawd/scripts/spawn-agent.sh` (agent routing + reporting directive)
- `~/.openclaw/openclaw.json` (subagent model defaults)
- All team SOUL.md files: blueteam, redteam, devsecops, threatintel, platform-engineering, church-of-molt, TEAM-INTELLIGENCE

**Audit Directories Created:**
```
/home/alpha/clawd/audits/{redteam,blueteam,devsecops,threatintel,platform-engineering,team-intelligence,church-of-molt,other}
```

**Open Issue:**
- **OpenRouter Content Censorship** — Free models block security terminology (error 451). Need to switch to Moonshot (kimi) models for security teams. Tracked in backlog.

---

### 5. Mega.nz MCP Server (Enterprise)
**Status:** ✅ Complete  
**Owner:** DevSecOps  
**Location:** `/home/alpha/clawd/projects/mega-mcp-enterprise/`  
**Notes:** Deployed 2026-02-07. Superior to rival implementation. AES-256-GCM, zero-copy streaming, multi-account support, hash-chain audit.

---

### 5. Protocol 402 (Lightning Payments)
**Status:** 🟡 Backlog  
**Owner:** DevSecOps  
**Priority:** Medium  
**Notes:** Testnet first, mainnet unfunded. Budget: 10K sats/day, approval >500 sats.

---

### 6. GlobalThreatMap (OSINT Platform)
**Status:** 🟡 Backlog  
**Owner:** ThreatIntel  
**Priority:** Medium

---

### 7. Dark Web Intel Report
**Status:** ✅ Complete  
**Delivered:** 2026-02-07 (7 markets, full URLs)

---

### 8. Iterative Loop Agent (Ralph Wiggum Pattern)
**Status:** 🟡 Planned  
**Owner:** DevSecOps  
**Priority:** Medium (after ACP integration)  
**Notes:** Native OpenClaw loop sub-agent for automated iterative tasks (vuln scanning, refactoring, bug fixing). Not using Claude Code plugin.

**Use Cases:**
- Vulnerability scanning until saturation
- Code refactoring until tests pass
- Report generation iterations
- ACP job execution monitoring

---

### 9. Polymarket Bot
**Status:** 🟡 In Progress  
**Owner:** RedTeam  
**Priority:** High  
**Tracker:** TBD

**Objective:** Build autonomous trading bot for Polymarket prediction markets.

**Components:**
- Market analysis engine (odds, liquidity, historical data)
- Trading strategy (arbitrage, trend following, mean reversion)
- Risk management (position sizing, stop-loss, max drawdown)
- API integration (Polymarket REST + WebSocket)
- Performance monitoring and reporting

**Dependencies:**
- Market data APIs
- Trading execution platform
- Security: secure key storage, rate limiting

---

### 10. Gmail Integration (via Himalaya)
**Status:** 🟢 Ready (Skill installed, setup pending)
**Owner:** DevSecOps / ThreatIntel
**Skill:** `himalaya` (installed)
**Tracker:** TBD

**Capabilities:**
- List, read, write, reply, forward emails
- Search and organize emails
- Multiple account support
- MML (MIME Meta Language) for message composition

**To-Do:**
- [ ] Configure Himalaya with Gmail API credentials
- [ ] Set up email monitoring for threat intel alerts
- [ ] Create automated reporting pipelines
- [ ] Integrate with mission control alerts

---

### 11. Trading Desk & Automated Grading Bots
**Status:** 🟡 Planned (Architecture Design)
**Owner:** RedTeam / DevSecOps
**Priority:** High (after ACP integration)
**Tracker:** TBD

**Objective:** Build a suite of specialized trading and grading bots with isolated agent sessions, independent strategies, and Mission Control integration.

**Rationale for Separate Agents:**
- **Session isolation:** Each bot maintains independent state and memory
- **Strategy specialization:** Different SOUL.md per bot (aggressive, conservative, arbitrage)
- **Resource management:** Separate API keys, rate limits, model allocations
- **Failure isolation:** One bot crash doesn't affect others
- **Monitoring granularity:** Track P&L, errors, and performance per strategy
- **Compliance:** Different risk profiles may require separate oversight

**Proposed Agent Structure:**
```
TradingDesk (root coordinator)
├── PolymarketBot — Prediction market trading (aggressive, momentum-based)
├── GradingBotV1 — Assignment grading (conservative, threshold-based)
├── ArbitrageBot — Cross-platform arbitrage (fast, low-latency)
└── MarketMakerBot — Liquidity provision (passive, volume-based)
```

**Each Agent Needs:**
- Dedicated workspace: `/home/alpha/clawd/agents/trading-desk/<bot-name>/`
- Custom SOUL.md with strategy-specific traits
- Independent memory: `memory/YYYY-MM-DD.md` per bot
- Configuration: API keys, risk limits, trading parameters
- State persistence: Active positions, performance metrics

**Integration with Mission Control:**
- Dashboard widgets: Agent status, P&L, trade count, error rate
- Alerting: Threshold breaches, API failures, profit/loss alerts
- Controls: Start/stop/restart individual bots
- Audit trail: All trades recorded in `/home/alpha/clawd/audits/trading-desk/`

**Technical Considerations:**
- State persistence (SQLite or file-based) for order books, positions
- WebSocket connections for real-time market data
- Rate limiting per exchange API
- Error handling and retry logic (with backoff)
- Circuit breakers for drawdown protection
- Multi-factor authentication for fund access

**Dependencies:**
- Polymarket API credentials (or alternative prediction market)
- Grading platform integration (Canvas, Moodle, or custom)
- Market data feeds (crypto, sports, prediction markets)
- Secure secret storage for API keys and private keys

**Development Approach:**
1. Create TradingDesk parent agent with sub-agent spawning capability
2. Build template agent structure (workspace, SOUL, config)
3. Implement PolymarketBot as MVP (simulated trading first)
4. Add GradingBotV1 with file-based assignment processing
5. Implement dashboard widgets and monitoring
6. Add arbitrage and market maker bots incrementally

**Risk Mitigation:**
- Start with paper trading (no real funds) for all bots
- Implement max position sizes and daily loss limits
- Use testnet APIs where available
- Require human approval for fund withdrawals
- Maintain immutable audit log of all decisions

**Success Metrics:**
- Bot uptime >99%
- Trade execution latency <100ms
- Zero catastrophic losses (enforced by circuit breakers)
- Profitable after fees (target: 0.5-2% monthly)
- Accurate grading (match human grades within 5%)

---

### 12. Morning Brew Reliability

### 11. Morning Brew Reliability
**Status:** 🟡 Maintenance  
**Owner:** DevSecOps  
**Priority:** Medium  
**Notes:** Cron job monitoring for automated security briefings.

**Objective:** Ensure daily automated security briefings run reliably.

**Components:**
- Cron job scheduling
- LLM API integration (for content generation)
- Delivery mechanisms (email, Discord, Telegram)
- Error handling and alerting

**Issues:**
- Recent LLM rate limits causing failures
- Need robust retry logic
- Delivery confirmation tracking

---

### 12. AgentMail Integration
**Status:** 🟡 Setup Pending  
**Owner:** DevSecOps  
**Priority:** Medium  
**Notes:** Email inbox API for AI agents (two-way email communication).

**Objective:** Dedicated email for Rubicon collective for threat intel, CVE alerts, customer reports, and notifications.

**Components:**
- AgentMail API setup
- Inbox creation (rubicon@agentmail.to)
- Webhook configuration for email reception
- Outbound notifications from cron jobs
- Two-way threat intelligence correspondence

**Status:** API key pending, inbox not created.

---

### 13. Tailscale Network
**Status:** 🟡 Implementation  
**Owner:** DevSecOps  
**Priority:** High  
**Notes:** Secure remote access without passwords.

**Objective:** Replace SSH keys with Tailscale for secure, zero-trust access to all Rubicon infrastructure.

**Components:**
- Tailscale installation on all nodes
- Network configuration (subnet routing)
- Service exposure via Tailscale
- Security hardening (ACL policies)

**Benefits:**
- No SSH keys to manage
- End-to-end encryption
- Easy scaling
- Better than VPNs for small teams

---

### 14. n8n Workflow Automation
**Status:** 🟢 Deployed (Basic)  
**Owner:** DevSecOps  
**Priority:** Medium  
**Notes:** Workflow automation platform for security operations.

**Objective:** Automate security workflows (alert processing, reporting, data enrichment).

**Current State:**
- Installed and running
- Basic workflows configured
- Need to expand for security use cases

**Planned Work:**
- Threat intel processing pipelines
- Automated pentest reporting
- Alert correlation workflows
- Backup automation

---

### 15. Portainer Container Management
**Status:** 🟢 Deployed  
**Owner:** DevSecOps  
**Priority:** Low  
**Notes:** Web UI for Docker container management.

**Objective:** Visual management of all Docker containers and services.

**Current State:**
- Installed and accessible
- Basic container management working
- Need to integrate with monitoring

---

### 16. Uptime Kuma Monitoring
**Status:** 🟢 Deployed  
**Owner:** DevSecOps  
**Priority:** Medium  
**Notes:** Self-hosted monitoring and alerting.

**Objective:** Monitor service uptime, health checks, and send alerts.

**Current State:**
- Installed and running
- Basic monitors configured
- Need to integrate with mission control

---

### 17. CAI (Cybersecurity AI Framework)
**Status:** 🟢 Deployed  
**Owner:** RedTeam  
**Priority:** High  
**Location:** `/home/alpha/venvs/cai/`  
**Version:** 0.5.10

**Objective:** Bug bounty-ready AI agent framework for security operations.

**Features:**
- Multi-agent cybersecurity platform
- Agent management and memory
- Parallel execution
- Interactive CLI with `/agent`, `/memory`, `/history`, `/parallel` commands

**Usage:** `source /home/alpha/venvs/cai/bin/activate && cai`

---

### 18. OpenRouter Model Configuration & Censorship Bypass
**Status:** 🔴 Critical (Blocking operational agents)  
**Owner:** Platform Engineering / DevSecOps  
**Priority:** CRITICAL  
**Impact:** All subagents using free OpenRouter models fail on security content due to censorship filters.

**Problem:**
- Subagent outputs containing vulnerability details, hardening commands, or security terms are blocked by OpenRouter's content moderation (HTTP 451 "censorship_blocked")
- Telegram delivery also fails for >4KB responses
- Both issues prevent agent outputs from reaching user

**Required Fixes:**
1. **Model Reconfiguration:** Switch security teams (RedTeam, BlueTeam, DevSecOps, ThreatIntel, TEAM-INTELLIGENCE, Church of Molt) to use non-censored models:
   - Primary: `moonshot/kimi-k2-0905-preview` (no content filtering)
   - Fallback: `moonshot/kimi-k2.5`
   - Reserve `openrouter/stepfun/step-3.5-flash:free` only for non-security tasks
2. **Telegram Message Chunking:** Implement automatic splitting of long outputs into multiple messages (<4096 chars each) OR enforce write-to-file-first pattern globally
3. **Reporting Standardization:** All agents must write detailed reports to `/home/alpha/clawd/audits/<team>/` and send only summaries to chat (already being rolled out via spawner + SOUL updates)

**Dependencies:**
- Platform Engineering to update agent default configurations
- DevSecOps to implement file-persist+summary pattern in spawner
- Testing with security-sensitive content

**Status:** 🟡 Workaround implemented (spawner injects reporting standard, config updated to use free models temporarily). Need to switch to Moonshot for reliable security operations.

---

### 18. Memory System v2.0 (Rubicon Collective Memory)
**Status:** 🟡 Backlog (Evaluation Complete)
**Owner:** DevSecOps / Platform Engineering
**Priority:** Medium
**Skill Source:** kellyclaudeai/memory-system-v2 (ClawHub)
**Installation:** `npx skills add -g kellyclaudeai/memory-system-v2`
**Tracker:** TBD

**Objective:** Deploy ultra-fast, file-based semantic memory system for Rubicon collective decision tracking and learning consolidation.

**Why This Skill:**
- **Unique capabilities** not present in current memory stack:
  - Importance scoring (1-10) for memory prioritization
  - Auto-consolidation (daily → weekly summaries)
  - Sub-20ms search performance (36 tests passed)
  - Structured memory types (learning, decision, insight, event, interaction)
- **Lightweight:** Pure bash + jq, no database required
- **Complementary:** Works alongside `agent-memory-mcp` and `hierarchical-agent-memory`

**Key Features:**
- 5 memory types with enforced categorization
- Tagging system for organization
- Context tracking (what you were doing)
- Multi-word search with importance weighting
- JSON index for fast lookup
- Stats & analytics dashboard
- Weekly auto-consolidation

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
1. Install skill and verify dependencies (`jq`)
2. Initialize Rubicon collective memory directory: `/home/alpha/clawd/memory/`
3. Configure HEARTBEAT.md to auto-capture daily learnings/decisions
4. Add `memory-search` integration to agent workflows (pre-session recall)
5. Set up weekly consolidation cron job
6. Create unified memory interface that checks both `agent-memory-mcp` and `memory-system-v2`

**To-Do:**
- [ ] Install memory-system-v2 skill
- [ ] Initialize memory directory structure
- [ ] Create wrapper script for agent compatibility (standardize CLI)
- [ ] Test search performance and accuracy
- [ ] Migrate relevant historical decisions from MEMORY.md
- [ ] Document usage in TOOLS.md for all agents

**Dependencies:**
- `jq` must be installed (brew install jq or apt-get install jq)
- Agent spawner needs to include memory capture directive in every task

**Considerations:**
- Single-user design (not multi-tenant)
- File-based scales to ~10K memories before slowdown
- No semantic embeddings (keyword search only)
- Bash dependency (Linux/macOS compatible)

**Performance Benchmarks (from tests):**
- Search: <20ms average
- Capture: <50ms average
- Stats: <10ms
- All operations: <100ms target ✅

**Comparison to Existing:**
| Feature | memory-system-v2 | agent-memory-mcp | hierarchical-agent-memory |
|---------|------------------|------------------|---------------------------|
| Speed | <20ms | Fast (MCP) | Instant (file read) |
| Importance scoring | ✅ 1-10 | ❌ | ❌ |
| Auto-consolidation | ✅ Weekly | ❌ | ❌ |
| Dashboard | Stats only | ✅ Full | ✅ Full |
| Setup | Copy script + jq | MCP server | `go ham` |
| Token optimization | ❌ | ❌ | ✅ (94% savings) |
| Semantic search | ❌ (keyword) | ✅ (via MCP) | ❌ |

**Verdict:** Adds importance-weighted, auto-consolidating memory that complements existing token optimization and MCP search capabilities.

---

## 🔧 Maintenance Tasks

- [ ] Fix mission control frontend health check
- [ ] Implement missions API CRUD
- [ ] Configure ACP skill (`acp setup`)
- [ ] Harden Docker sandboxes (unprivileged, seccomp)
- [ ] Implement auth workflow for ACP jobs
- [ ] Build PentestOPS-ACP bridge
- [ ] Design RedTeam offering JSON schema

---

## 📅 Meeting Notes

### 2026-02-26
- Decided: Mission Control is **project portfolio**, not just dashboard. Dashboard is one project within the system.
- Consolidated dashboard task tracking into its own `MISSION_CONTROL.md` (inside mission-control repo).
- Created this master index to track all Rubicon projects.
- Installed ACP skill, evaluated Ralph Wiggum pattern (will build native).

---


---

## 📋 Memory Search: February 26, 2026 — 3:25 PM (UTC)

Based on system memory search, here's the current to-do/issue backlog:

**🟡 In Progress / Pending**

| Item           | Status | Blocker/Note                                       |
| -------------- | ------ | -------------------------------------------------- |
| GitHub Access  | 🟡     | Awaiting setup                                     |
| Gmail Setup    | 🟡     | App Password or OAuth decision needed              |
| PT Contracts   | 🟡     | Python script, startup criteria, Telegram group ID |
| Polymarket Bot | 🟡     | In progress                                        |
| Mega.nz MCP    | 🟡     | Needs config + test (deployment ready)             |
| Garak          | 🔴     | Blocked by disk space                              |
| n8n            | 🟡     | Running but unassigned                             |
| Scheduler Fix  | 🟡     | Timer overflow bug (backend team notified)         |

**🔧 Infrastructure Issues**

| Issue           | Priority | Details                                                                                 |
| --------------- | -------- | --------------------------------------------------------------------------------------- |
| LLM: Anthropic  | 🔴       | Configured but broken (placeholder token)                                               |
| LLM: Moonshot   | 🟡       | Missing API key (env var verification needed)                                           |
| LLM: OpenRouter | 🟡       | Working but messy config schema                                                         |
| Firewall Fix    | 🟡       | sudo update-alternatives --set iptables /usr/sbin/iptables-legacy + SSH to Tailscale IP |
| Tailscale       | 🟢       | Mostly done - VPS IP 100.127.212.14, dashboard accessible                               |

**📋 Backlog / New Projects**

| Project                  | Status | Decision Needed                                                       |
| ------------------------ | ------ | --------------------------------------------------------------------- |
| Protocol 402 (Lightning) | 📋     | LND node vs custodial API; budget: 10K sats/day                       |
| GlobalThreatMap          | 📋     | OSINT command center                                                  |
| Security Skills Pack     | 📋     | Install from sickn33/antigravity-awesome-skills (107 security skills) |
| Twitter/X Setup          | 📋     | @RubiconSec profile + bird CLI install                                |

**✅ Recently Fixed**

• Security audit message length → Fixed (file attachment + summary)
• Morning Brew → Delivering reliably
• Plaintext password in config → Moved to .env
• Tailscale serve → Dashboard live at homehq-out1.tail14afce.ts.net

**Immediate actions needed:** Anthropic token fix, disk space for Garak, GitHub/Gmail setup decisions.

🌊