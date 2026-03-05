# HEARTBEAT.md - RedTeam

# Keep this file empty (or with only comments) to skip heartbeat API calls.

# Add tasks below when you want the agent to check something periodically.

---

## 🎯 Operational Readiness

**Check:** Every 3 hours

**Task:** Verify RedTeam tools and environments are ready for engagement.

**Prompt:**
```
RedTeam readiness check:
1. Verify tool availability: sqlmap, metasploit, burp-style scanners, nuclei, gobuster
2. Check ACP skill status: `acp status` (if configured) — wallet balance, active jobs
3. Validate PentestOPS connection: can create project, list findings?
4. Review recent assignments in Mission Control Dashboard (if integrated)
5. Check for any scheduled engagements in next 24h
Report: READY / NOT READY + any blockers (missing tools, API limits, funding).
If NOT READY, send alert to Telegram -1003661374647.
```

---

## ⚠️ ACP Job Monitoring

**Check:** Every hour (if ACP integration is live)

**Task:** Monitor active jobs in the ACP marketplace.

**Prompt:**
```
Check ACP job status:
1. List active jobs assigned to RedTeam offering
2. Check SLA compliance: time remaining vs. completion %?
3. Any jobs at risk of missing deadline?
4. New job inquiries needing response?
If any job overdue or at risk: send alert to Telegram -1003661374647 with job details.
Otherwise: "All ACP jobs on track."
```

---

## 📊 Security Tools Health

**Check:** Daily

**Task:** Verify security scanning tools are operational and not rate-limited.

**Prompt:**
```
Security tools health check:
- nuclei: check latest CVEs coverage, rate limit status
- sqlmap: test connection to target DB (canary)
- gobuster: wordlist availability, common paths updated?
- metasploit: module load test, exploit DB updated?
- Any tool reporting errors or rate limits?
Report status per tool with ✅/❌ flags.
If critical tool down: send alert to Telegram -1003661374647.
```

---

## 🔥 Threat Intelligence Feed

**Check:** Every 4 hours

**Task:** Pull latest exploit trends and adjust RedTeam tactics.

**Prompt:**
```
Quick threat intel scan:
1. Check for new critical CVEs affecting common targets (web, infra)
2. Any newly weaponized exploits in the wild?
3. Emerging attack patterns (supply chain, API abuse, AI model theft)?
4. Update RedTeam SOUL.md tactics if needed (add new patterns)
Report: 2-3 top items with actionable notes.
If urgent threat identified: send to Telegram -1003661374647 with 🚨 prefix.
```

---

## 💾 Exploit Payload Maintenance

**Check:** Weekly

**Task:** Review and rotate payloads to avoid detection.

**Prompt:**
```
Weekly payload audit:
1. Check payload database size (aim for 500+ unique payloads)
2. Verify no payloads have become signatured (test against latest AV/EDR)
3. Update obfuscation techniques if needed
4. Clean up deprecated payloads
5. Ensure staging server ready for payload hosting
Report: payload count, detection rate, any updates made.
Log only — no Telegram alert unless critical issue.
```

---

## 📈 Performance Metrics

**Check:** Daily (summary)

**Task:** Track RedTeam effectiveness and SLA compliance.

**Prompt:**
```
RedTeam performance snapshot (last 24h):
- Jobs completed: count
- Average completion time: hours
- SLA met: % (jobs completed within deadline)
- Findings severity distribution (CRITICAL/HIGH/MEDIUM/LOW)
- Client satisfaction (if feedback available)
- Revenue generated (if ACP payments active)
Report in concise bullet format.
If SLA < 90% or critical findings low: investigate causes.
```
