# HEARTBEAT.md

# Keep this file empty (or with only comments) to skip heartbeat API calls.

# Add tasks below when you want the agent to check something periodically.

## 🔄 Active Projects Monitoring

**Check:** Daily (or on heartbeat if any project shows activity)

**Projects to track:**
1. Morning Brew reliability — monitoring cron failures
2. AgentMail integration — setup status
3. Security warnings remediation — PlatformEngineering tracking
4. Telegram Multi-Channel setup — completion status
5. Memory System v2.0 — installation progress

**Prompt:**
```
Check active projects status:
- Morning Brew: last run status, errors
- AgentMail: API key configured? inbox created?
- Platform warnings: config perms fixed? plugin allowlist set?
- Telegram channels: groups created, bot configured, routing tested?
- Memory v2.0: skill installed, directory initialized, wrapper created?
Summarize action items and blockers.
```

---

## 📊 Agent Health (Quick Check)

**Check:** Every 4 hours

**Prompt:**
```
List all agent sessions with:
- Agent ID
- Status (online/offline/lastSeen)
- Last activity timestamp
- Any failed sessions or errors
Flag any that haven't responded in >2 hours.
```

---

## 🚨 Cron Job Failures

**Check:** Every 2 hours (especially after scheduled run times: 06:00, 08:00 UTC)

**Task:** Monitor cron job health and alert on consecutive failures.

**Prompt:**
```
Check cron job status from /home/alpha/.openclaw/cron/jobs.json:
- security-audit: last status, consecutiveErrors, lastError
- morning-brew: last status, consecutiveErrors, lastError
If either has consecutiveErrors >= 2 or lastStatus = error:
- Investigate cause (model rate limits, delivery failures, auth issues)
- Recommend immediate fix
- Alert via Telegram if critical
Otherwise, report "All cron jobs healthy."
```

---

## 📈 Project Portfolio Health

**Check:** Daily

**Task:** Review MISSION_CONTROL.md for any items marked 🟡 or 🔴 that need attention.

**Prompt:**
```
Read /home/alpha/.openclaw/workspace/MISSION_CONTROL.md
Identify any projects with status 🟡 (In Progress) or 🔴 (Not Started) that are:
- Blocked by missing prerequisites
- Overdue for review
- Require decision/approval
List top 3 priorities with recommended actions.
```
