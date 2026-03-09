# HEARTBEAT.md - The High Council

*Periodic checks to ensure OpenClaw infrastructure remains operational and secure.*

---

## 🚨 Critical System Checks (Every 30 minutes)

**Task:** Verify core infrastructure health
```
Check and report:
1. Gateway daemon status (openclaw gateway status)
2. Active session count and health
3. Cron job execution status (last runs, consecutive errors)
4. Provider availability (cooldown status, rate limits)
5. Disk space utilization (>90% = CRITICAL)
6. Memory usage (>90% = WARNING)

Alert immediately on:
- Gateway DOWN
- All providers in cooldown (system unavailable)
- Disk >95% full
- Cron jobs failing >3 consecutive times
```

---

## 🔍 Security & Configuration Audits (Every 6 hours)

**Task:** Verify security posture and configuration integrity
```
Execute security audit:
1. Check config file permissions (should be 600)
2. Verify no plaintext secrets in ~/.openclaw/openclaw.json
3. Review recent file modifications in monitored paths
4. Check for unauthorized agent spawning
5. Verify Tailscale connectivity
6. Review failed authentication attempts

Alert on CRITICAL findings via Telegram.
Log all findings to memory/YYYY-MM-DD.md
```

---

## 📊 Provider Health Monitoring (Every 4 hours)

**Task:** Monitor LLM provider status and model availability
```
Check provider status:
- Anthropic (Claude Sonnet 4.6 and configured family)
- Groq (active low-latency operational models)
- OpenRouter (fallbacks, specialty models, free resilience paths)
- OpenAI-Codex (coding-focused execution paths)
- Vercel AI Gateway (gateway-routed provider access where configured)

Identify:
- Providers in cooldown
- Rate limit exhaustion trends
- Model deprecation warnings
- New model availability

Update fallback chains if primary providers unstable.
```

---

## 🐳 Container & Service Health (Every 2 hours)

**Task:** Verify managed services
```
Check services:
- n8n (port 5678) - workflow automation
- Portainer (port 9000) - container management
- traefik - reverse proxy

Verify:
- All containers running
- No excessive resource consumption
- Log errors or crashes
- Network connectivity

Restart services if unhealthy:
docker restart <container_name>
```

---

## 📝 Daily Maintenance (Every 24 hours at 06:00 UTC)

**Task:** Daily maintenance and cleanup
```
Execute:
1. Log rotation review
2. Temporary file cleanup (/tmp, ~/.openclaw/cache/)
3. Docker system prune (if disk >80%)
4. Memory directory organization
5. Backup verification

Report completion to Ricardo via Telegram.
```

---

## 🔧 Weekly Deep Maintenance (Sundays at 04:00 UTC)

**Task:** Comprehensive system review
```
Execute:
1. Full configuration audit
2. Skill inventory review (outdated skills?)
3. Provider cost analysis
4. Security patch availability check
5. Documentation freshness review
6. Archive old memory files (>30 days)

Generate and deliver:
- Infrastructure health report
- Cost summary
- Recommended actions
```

---

## ⚡ Immediate Response Triggers

**Respond immediately (do not wait for scheduled heartbeat):**

1. **Gateway Failure** → Restart, investigate, alert
2. **Security Incident** → Isolate, investigate, escalate
3. **Provider Outage** → Switch fallbacks, notify users
4. **Disk Full** → Emergency cleanup, prevent data loss
5. **Unauthorized Access** → Lockdown, audit, alert

---

## 📋 Heartbeat State Tracking

Track last check times in `memory/heartbeat-state.json`:

```json
{
  "lastChecks": {
    "critical-system": 1703275200,
    "security-audit": 1703260800,
    "provider-health": 1703257200,
    "container-health": 1703253600,
    "daily-maintenance": 1703246400,
    "weekly-maintenance": 1703203200
  },
  "alertsSent": [],
  "actionsTaken": []
}
```

---

## 🎯 Council Protocol

When this heartbeat fires:

1. **Read this file** — Understand current check schedule
2. **Determine due checks** — Based on last check timestamps
3. **Execute checks** — Run appropriate diagnostics
4. **Log findings** — Write to memory/YYYY-MM-DD.md
5. **Alert on critical** — Use `message` tool for urgent issues
6. **Update state** — Record check completion time

**Default response:** If no checks are due and no issues detected, reply `HEARTBEAT_OK`

**Escalation:** If critical issues found, route to the appropriate live execution agent:
- Runtime and deployment issues -> `platform-ops`
- Provider auth, routing, or model drift -> `platform-providers`
- Channel delivery or trust-policy issues -> `platform-channels`
- Skill, toolchain, or extension-code issues -> `platform-skills`

---

⚙️ *The High Council watches. The machinery endures. The mission continues.*
