# HEARTBEAT.md - Platform Engineering (High Council)

# Keep this file empty (or with only comments) to skip heartbeat API calls.

# Add tasks below when you want the agent to check something periodically.

---

## 🏛️ System Integrity Watch

**Check:** Every 3 hours

**Task:** Verify OpenClaw platform stability and agent health.

**Prompt:**
```
Platform Engineering integrity check:
1. Gateway health: `systemctl --user is-active openclaw-gateway.service` + memory usage
2. Agent sessions: total count, any crashed agents? Check `openclaw agents list`
3. Cron job health: read /home/alpha/.openclaw/cron/jobs.json — any consecutiveErrors?
4. Disk usage: `df -h /home/alpha` — any filesystem >85%?
5. Recent errors: `tail -100 /home/alpha/.openclaw/logs/*.log | grep -i error` — spike?
Report: system overview with 🔴/🟡/🟢 status per component.
If any 🔴 critical issue: send alert to Telegram -1003661374647 immediately.
```

---

## 🔧 Configuration Drift Detection

**Check:** Daily (04:00 UTC)

**Task:** Compare current configs against known-good baselines.

**Prompt:**
```
Configuration drift check:
1. OpenClaw config: `diff <(git show HEAD:openclaw.json) /home/alpha/.openclaw/openclaw.json` (if git-tracked) or compare to /backup/configs/openclaw.json.baseline
2. Agent models.json: scan all agents for unauthorized model changes
3. Secrets provider: verify allowlist matches expected (MOONSHOT_API_KEY, OPENROUTER_API_KEY, etc.)
4. Gateway binding: confirm still bound to Tailscale IP (100.127.212.14), not localhost
5. Agent auth-profiles.json: check for new credentials not from secure source
Report: drift summary with changed files.
If unauthorized drift detected: send alert to Telegram -1003661374647 and flag for immediate rollback.
```

---

## 📚 Documentation Sync

**Check:** Daily

**Task:** Ensure MISSION_CONTROL.md and architecture docs match reality.

**Prompt:**
```
Documentation sync check:
1. Read /home/alpha/.openclaw/workspace/MISSION_CONTROL.md
   - Verify project statuses match actual state (check last commit dates, agent outputs)
   - Identify any stale information (>7 days old)
2. Cross-reference with /home/alpha/infra/docs/openclaw-system-architecture.md
   - Agent count still accurate?
   - Service ports unchanged?
   - Network topology current?
3. Check TOOLS.md for each agent: do they reflect latest skills and credentials?
Report: doc items needing update + owner assignment (DevSecOps/Team-Intel).
Send update reminder to relevant agent if stale.
```

---

## 🔄 OpenClaw Upgrade Readiness

**Check:** Weekly (Sunday 05:00 UTC)

**Task:** Assess if OpenClaw gateway or agents need updates.

**Prompt:**
```
Weekly upgrade assessment:
1. Current version: `openclaw --version` (if available) or git rev-parse HEAD in OpenClaw repo
2. Check upstream releases: `curl -s https://api.github.com/repos/openclaw/openclaw/releases | jq -r '.[0].tag_name'`
3. Breaking changes review: read latest release notes for migration steps
4. Agent compatibility: are any agents using deprecated features? scan SOUL.md for old patterns
5. Backup status: confirm full config + data backup exists before upgrade
Report: upgrade recommendation (now/wait/critical) + blockers.
If upgrade needed but blockers exist: send alert to Telegram -1003661374647 to prioritize.
```

---

## 🧪 Testing Coverage Audit

**Check:** Weekly

**Task:** Review agent testing practices and results.

**Prompt:**
```
Testing coverage audit:
1. Check each agent's test suite: `find /home/alpha/clawd/agents/*/tests -name "*.py" -o -name "*.test.js"` — exists?
2. Review recent test runs: look for logs in /home/alpha/clawd/agents/*/test-results/
3. Coverage thresholds: any `.codecov.yml` or coverage config? current coverage %?
4. Integration tests: are there end-to-end tests for agent interactions?
5. Manual testing log: does each agent have a TESTING.md with manual verification steps?
Report: testing maturity score (1-5) + gaps.
If coverage <70% or no test suite exists for critical agents (RedTeam, DevSecOps): send alert to Telegram -1003661374647.
```

---

## 📈 Skill Inventory & Security

**Check:** Weekly

**Task:** Audit installed skills for vulnerabilities and outdated versions.

**Prompt:**
```
Skill security audit:
1. List all installed skills: `ls /home/alpha/.claude/skills/` vs. ClawHub registry
2. Flag experimental skills: any in `/skills/experimental/`? review usage
3. Check skill updates: `clawhub outdated` (if available) — any critical patches?
4. Scan skill SOURCES.md for malicious patterns (as per Rubicon Security Protocols)
5. Verify skill permissions: no skill requesting >needed access (e.g., filesystem write when not required)
Report: skill inventory count, experimental count, update availability.
If any skill flagged as high-risk or outdated with CVE: send alert to Telegram -1003661374647.
```

---

## 🔍 Platform-Wide Anomaly Detection

**Check:** Every 6 hours

**Task:** Look for unusual patterns across all agents and systems.

**Prompt:**
```
Anomaly detection sweep:
1. Agent session spikes: `ls /home/alpha/.openclaw/agents/*/sessions/*.jsonl | wc -l` — sudden increase?
2. Error rate: `grep -r '"status":"error"' /home/alpha/.openclaw/cron/runs/*.jsonl | wc -l` — trending up?
3. Memory usage growth per agent: check daily log file sizes in /home/alpha/.openclaw/workspace/memory/
4. Unusual file access: `ausearch -f /home/alpha/.openclaw --start recent-6h` (if auditd enabled) — unexpected files?
5. Network connections: `ss -tnp | grep -E ':(18789|3000|8000)'` — abnormal remote IPs?
Report: anomalies with severity (LOW/MEDIUM/HIGH/CRITICAL).
If CRITICAL anomaly: immediate alert to Telegram -1003661374647 with investigation steps.
```

---

## 🗄️ Data Retention & Cleanup

**Check:** Weekly (Monday 03:00 UTC)

**Task:** Enforce retention policies and clean stale data.

**Prompt:**
```
Data retention enforcement:
1. Session logs: `find /home/alpha/.openclaw/agents/*/sessions -name "*.jsonl" -mtime +30` — delete (keep only 30d)
2. Cron runs: `find /home/alpha/.openclaw/cron/runs -mtime +90` — archive/delete
3. Audit log rotation: check /home/alpha/clawd/logs/ — any logs >100MB? compress/truncate
4. Docker prune: `docker system df` — reclaim space from unused images/containers/volumes
5. Temporary files: `/tmp/security-audit-report-*.md` older than 7d? delete
6. Memory consolidation: verify /home/alpha/clawd/memory/consolidated/ has weekly summaries
Report: cleanup actions taken + space reclaimed.
If any retention policy violated (keeping data too long): send alert to Telegram -1003661374647.
```
