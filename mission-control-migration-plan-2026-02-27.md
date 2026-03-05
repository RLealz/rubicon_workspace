# Mission Control Migration Plan: Fork & Adopt External Dashboard

**Date:** 2026-02-27
**Author:** Rubicon (Mission Commander)
**Target:** Migrate from internal Node.js dashboard to forked `abhi1693/openclaw-mission-control`

---

## 1. Architecture Overview & Integration Points

### External System (abhi1693)
```
┌─────────────────┐    ┌──────────────┐    ┌─────────────┐
│   Next.js 16    │◄──►│   FastAPI    │◄──►│ PostgreSQL  │
│   Frontend      │    │   Backend    │    │   + Redis   │
└─────────────────┘    └──────────────┘    └─────────────┘
         │                       │
         │ SSE/HTTP              │ OpenClaw Gateway API
         ▼                       ▼
┌─────────────────┐    ┌─────────────────────────┐
│   Rubicon Users │    │  OpenClaw Gateway      │
│   (Tailscale)   │    │  (agent spawning,      │
└─────────────────┘    │   session management)  │
                        └─────────────────────────┘
```

### Our Current Stack
```
┌─────────────────┐    ┌──────────────┐    ┌─────────────┐
│   React + Vite  │◄──►│   Node.js    │◄──►│   SQLite    │
│   Tailwind      │    │   Express    │    │   (file)    │
└─────────────────┘    └──────────────┘    └─────────────┘
         │                       │
         └───────────────────────┘
              (loose integration)
```

**Integration Points to Build:**
1. **Authentication:** Replace Clerk with OpenClaw session validation
2. **Agent Lifecycle:** Connect to gateway `/agent` endpoints for provisioning/status
3. **Missions Sync:** Map our internal "missions" to external "boards" + "tasks"
4. **Tool Integration:** PentestOPS webhook → create board/task; ACP → skill assignment
5. **Metrics:** Pull agent metrics from gateway `/metrics` or subagent status API

---

## 2. Customization Checklist

### 2.1 Authentication Overhaul
- [ ] Remove Clerk dependencies (frontend & backend)
- [ ] Implement OpenClaw session cookie validation:
  - Backend: Read `openclaw.session` cookie, verify via gateway `/session/verify` or shared secret
  - Frontend: Drop Clerk provider, use OpenClaw session state
- [ ] Add Tailscale network check (optional: restrict to `100.127.*.*`)

### 2.2 Data Model Adjustments
- [ ] Add `agent_type` enum: `redteam`, `blueteam`, `threatintel`, `devsecops`, `platform-engineering`, `church-of-molt`
- [ ] Add `mission_priority` enum: `critical`, `high`, `medium`, `low`
- [ ] Add `team` foreign key to boards (instead of generic orgs)
- [ ] Add `skills` relationship to agents (many-to-many, from OpenClaw registry)
- [ ] Add `iterative_loop_config` to tasks:
  ```json
  {
    "loop_enabled": true,
    "max_iterations": 10,
    "completion_predicate": "string_match|test_pass|no_new_findings",
    "backoff_strategy": "linear|exponential"
  }
  ```

### 2.3 Rubicon Branding
- [ ] Update name/logo: "Rubicon Mission Control"
- [ ] Color scheme: teal/black (matching Rubicon identity)
- [ ] Terminology: "Board" → "Mission Portfolio", "Task" → "Operation"
- [ ] Add footer: "Classified Rubicon Collective Asset"

### 2.4 External Integrations
- [ ] **PentestOPS sync:**
  - Webhook endpoint `/api/integrations/pentestops/project`
  - On project creation: auto-create board, initial task
  - Sync status updates (PendRunnCompl → task status)
- [ ] **ACP Marketplace:**
  - `/api/skills/marketplace` → list available skills from ACP
  - Agent skill assignment UI with ACP wallet check
- [ ] **CAI linking:**
  - Quick-launch button to spawn CAI subagent from task
  - Pass task context (title, description, expected outcome)
- [ ] **Lynis audit viewer:**
  - `/api/audits/lynis` → list audit files
  - Render markdown reports in UI with syntax highlighting

### 2.5 Iterative Loop Feature (Ralph Wiggum)
- [ ] Backend: `POST /api/tasks/{id}/loop/start`
- [ ] Loop engine: spawn subagent with retry until completion predicate satisfied
- [ ] UI: Loop status panel (iterations, last result, logs)
- [ ] Resource quotas: max iterations, time limit, API credit budget

---

## 3. Infrastructure Requirements

### 3.1 Services on HomeHQ-OUT1 (VPS)
```yaml
# docker-compose.yml additions
services:
  postgres:
    image: postgres:16-alpine
    environment:
      POSTGRES_PASSWORD: ${POSTGRES_PASSWORD}
      POSTGRES_DB: mission_control
    volumes:
      - postgres_data:/var/lib/postgresql/data
    networks: [traefik_public]

  redis:
    image: redis:7-alpine
    command: redis-server --appendonly yes
    volumes:
      - redis_data:/data
    networks: [traefik_public]

  mission-control-backend:
    build: ./backend
    environment:
      DATABASE_URL: postgresql+psycopg://postgres:${POSTGRES_PASSWORD}@postgres:5432/mission_control
      REDIS_URL: redis://redis:6379
      OPENCLAW_GATEWAY_URL: http://openclaw-gateway:18789
    volumes:
      - ./backend:/app
    networks: [traefik_public]
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.mc-backend.rule=Host(`mission-control.tail14afce.ts.net`)"
      - "traefik.http.routers.mc-backend.service=mc-backend"
      - "traefik.http.services.mc-backend.loadbalancer.server.port=8000"

  mission-control-frontend:
    build: ./frontend
    environment:
      NEXT_PUBLIC_API_URL: https://mission-control.tail14afce.ts.net/api
    networks: [traefik_public]
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.mc-frontend.rule=Host(`mission-control.tail14afce.ts.net`)"
      - "traefik.http.routers.mc-frontend.service=mc-frontend"
      - "traefik.http.services.mc-frontend.loadbalancer.server.port=3000"
```

### 3.2 Secrets Management
- Store `POSTGRES_PASSWORD`, `OPENCLAW_GATEWAY_TOKEN` in 1Password
- Inject via environment variables or Docker secrets
- Use `claw-skill-guard` to audit all config files

### 3.3 Migration from SQLite
- Export current internal DB (`missions.db`) to JSON
- Transform to external schema (boards → missions, tasks → operations)
- Import into PostgreSQL
- Verify data integrity; keep SQLite backup for rollback

---

## 4. Implementation Roadmap

### Phase 1: Fork & Basic Customization (5 days)
- [ ] Fork external repo to RubiconSec organization
- [ ] Clone and set up dev environment (Python 3.12, Node 20, Postgres, Redis)
- [ ] Remove Clerk auth (backend & frontend)
- [ ] Implement OpenClaw session validation middleware
- [ ] Update branding (name, colors, logo)
- [ ] Deploy to staging (separate Traefik entry: `mc-staging.tail14afce.ts.net`)
- [ ] Basic smoke test: login, view empty dashboard

**Effort:** 40 hours

### Phase 2: Core Rubicon Integrations (7 days)
- [ ] Add agent_type field & seeding for our 8 agents
- [ ] Implement agent provisioning API (POST /api/agents → gateway call)
- [ ] Build agent status polling from gateway `/sessions`
- [ ] Add skills assignment UI (pull from OpenClaw registry `/skills`)
- [ ] Implement PentestOPS webhook receiver
- [ ] Build ACP skills marketplace integration
- [ ] Add Lynis audit viewer (markdown rendering)
- [ ] E2E test: create board, assign RedTeam agent, spawn subagent

**Effort:** 60 hours

### Phase 3: Advanced Features (5 days)
- [ ] Implement iterative loop engine (backend service + UI)
- [ ] Add metrics dashboard (agent uptime, task completion rate, API usage)
- [ ] Build activity logs & audit trail (who did what, when)
- [ ] Add email notifications (via Gmail skill) for mission assignments
- [ ] Implement backup strategy (Postgres dumps to S3 or local)
- [ ] Performance tuning (query indexes, Redis caching)

**Effort:** 40 hours

### Phase 4: Migration & Sunset (3 days)
- [ ] Export internal dashboard data (missions, logs)
- [ ] Transform to new schema
- [ ] Import and verify
- [ ] Update agent SOULs to use new Mission Control API for reporting
- [ ] Decommission internal backend (`/home/alpha/clawd/agents/devsecops/mission-control/`)
- [ ] Archive old Docker containers and volumes
- [ ] Update documentation (MISSION_CONTROL.md, READMEs)

**Effort:** 24 hours

**Total:** ~164 hours (4-5 weeks with concurrent work)

---

## 5. Risk Assessment & Mitigation

| Risk | Probability | Impact | Mitigation |
|------|-------------|--------|------------|
| External repo changes/breaks our fork | Low | Medium | Keep fork up-to-date; review upstream weekly; pin commits |
| PostgreSQL/Redis not available on VPS | Medium | High | Install via Docker; allocate dedicated resources; test restore |
| OpenClaw session validation complexity | Medium | Medium | Prototype early; fallback to basic auth if needed |
| Data migration corruption | Low | High | Dry-run on copy; keep SQLite backup; rollback plan |
| Feature gaps vs internal customizations | Medium | Medium | Document missing features; implement as extensions in Phase 3 |
| Team learning curve (FastAPI/Python) | Medium | Low | Dedicate 2 days for learning; use existing docs |

---

## 6. Rollback Strategy

1. **Keep internal dashboard running** during migration (do not shut down until Phase 4)
2. **Dual-write** during transition: new system writes, old system reads (or vice versa)
3. **Feature flag** in gateway to switch agent reporting endpoints
4. **Rollback procedure:**
   - Stop new dashboard containers
   - Restore old Docker compose (`docker-compose up -d` in old dir)
   - Redirect Traefik labels back to old services
   - Verify old system operational
   - Investigate root cause

---

## 7. Success Criteria

- ✅ All agents visible with correct types and status
- ✅ Can create mission (board) and assign to agent
- ✅ Can spawn subagent from mission with single click
- ✅ PentestOPS projects auto-create missions
- ✅ Iterative loop agent runs and stops on completion
- ✅ Audit logs capture all actions
- ✅ 99% uptime, <2s page loads
- ✅ Team training completed (2 sessions)

---

**Next Action:** Fork repository and begin Phase 1.

🌊
