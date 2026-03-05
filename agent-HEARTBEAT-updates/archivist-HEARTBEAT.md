# HEARTBEAT.md - Archivist

# Keep this file empty (or with only comments) to skip heartbeat API calls.

# Add tasks below when you want the agent to check something periodically.

---

## 📊 Canon Metrics Dashboard

**Check:** Daily

**Task:** Update and maintain Church of Molt metrics dashboards.

**Prompt:**
```
Archivist metrics update:
1. Pull latest data from audit files: /home/alpha/clawd/audits/
   - Total security audits: count & trend (weekly)
   - Agent productivity: outputs per team (last 7d)
   - Memory growth: new entries per day (Rubicon collective memory)
2. Update MISSION_CONTROL.md metrics tables if any
3. Generate trend charts (ASCII or markdown tables): 
   - Are security issues decreasing? 
   - Is agent output quality improving?
   - Memory consolidation progress?
4. Flag anomalies: any metric moving in wrong direction >20%?
Report: updated dashboard with key metrics.
If critical metric deteriorating: alert Church-of-Molt + High Council.
```

---

## 📈 Trend Analysis Watch

**Check:** Every 6 hours

**Task:** Analyze trends in threat intelligence, agent performance, system health.

**Prompt:**
```
Trend analysis sweep:
1. Security: compare today's audit findings vs. last 7-day avg (CRITICAL/HIGH counts)
2. Operations: cron job success rate trend (morning-brew, security-audit)
3. Agent activity: session counts per agent — any drop-off indicating issues?
4. Memory entropy: is memory growth linear or accelerating? consolidation working?
5. Infrastructure: resource usage trends (disk, memory) from DevSecOps reports
6. Identify positive trends to celebrate + negative trends to investigate
Report: trend summary with ↑/→/↓ arrows + noteworthy deviations.
If downward trend >15% in any critical metric: send alert to relevant team lead + Church.
```

---

## 🗃️ Historical Data Integrity

**Check:** Weekly (Saturday 02:00 UTC)

**Task:** Verify integrity of archived audit logs and historical records.

**Prompt:**
```
Historical data integrity check:
1. Audit log completeness: count files per day in /home/alpha/clawd/audits/ — any missing dates?
2. File corruption: `grep -r "^\s*$" /home/alpha/clawd/audits/*.md` — empty files? run md5sum on critical reports
3. Cross-reference consistency: do summary entries in MISSION_CONTROL.md match detailed reports?
4. Backup verification: confirm /backup/audits/ contains recent copies (if implemented)
5. Retention compliance: are old logs (>90d) properly archived or deleted per policy?
Report: integrity status with any gaps/corruptions.
If data loss detected: alert Platform-Engineering + initiate recovery.
```

---

## 📋 Reporting Standard Compliance

**Check:** Daily

**Task:** Ensure all agents follow the reporting standard (full report + summary).

**Prompt:**
```
Reporting standard compliance audit:
1. Scan /home/alpha/clawd/audits/<team>/ for today's outputs:
   - Does each have corresponding Telegram delivery record in cron runs?
   - Are files named correctly (YYYY-MM-DD-<type>.md)?
2. Spot-check 3 recent agent outputs:
   - Did agent write FULL report before summarizing? (check file exists)
   - Is summary <3000 chars?
   - Does summary reference the full report file path?
3. Count violations: agents non-compliant >2 times this week?
4. Document repeat offenders and enforcements
Report: compliance % + violators list.
If compliance <95% or repeat offenders exist: send alert to agent SOUL + Platform-Engineering.
```

---

## 🔍 Data Quality Assessment

**Check:** Weekly

**Task:** Evaluate quality of collected data (audit reports, threat intel, metrics).

**Prompt:**
```
Data quality assessment:
1. Completeness: are audit reports filling all sections? Any "TBD" or missing headings?
2. Accuracy: spot-check 3 reports for factual errors (cross-reference with source data)
3. Timeliness: is data entering system within expected latency? (e.g., morning-brew should be 08:00 UTC)
4. Consistency: do similarly named fields have same format across reports? (dates, severity levels)
5. Usability: can another agent understand and act on the data without clarification?
Report: quality score (1-10) per category + improvement actions.
If quality <7/10: initiate data quality workshop with affected teams.
```

---

## 📚 Knowledge Base Maintenance

**Check:** Weekly

**Task:** Organize and curate the collective knowledge (MEMORY.md, daily logs, audit reports).

**Prompt:**
```
Knowledge base maintenance:
1. Daily memory logs: /home/alpha/.openclaw/workspace/memory/ — any gaps in coverage?
2. MEMORY.md: review for outdated info (older than 6mo) — flag for archiving/updating
3. Cross-link related entries: ensure decisions reference related past learnings
4. Index important findings: create topic-based index (e.g., "API key rotation", "cron failures")
5. Verify searchability: test `memory_search` with recent queries — are results relevant?
Report: knowledge base health + recommended cleanup tasks.
If memory gaps or index broken: schedule curation sprint with all agents.
```

---

## 🧩 Meta-Documentation

**Check:** Monthly

**Task:** Document the documentation itself — create guide to all audit reports and metrics.

**Prompt:**
```
Meta-documentation task:
1. Inventory all report types: security-audit, mission-control-audit, agent-architecture, etc.
2. For each: document schema (headings, tables, standard fields)
3. Create "Report Reader's Guide" explaining which report answers which question
4. Map report lineage: which reports derive from which source data?
5. Publish guide in /home/alpha/.openclaw/workspace/DOCUMENTATION_GUIDE.md
Report: guide created/updated + cross-training delivered to agents.
```

---

## 📱 Visualization Preparation

**Check:** Monthly (or as needed for Mission Control)

**Task:** Prepare data for graphing/dashboard widgets.

**Prompt:**
```
Visualization data prep:
1. Extract time-series data for key metrics:
   - Security findings trend (CRITICAL/HIGH count over time)
   - Cron job success rate
   - Agent response times
   - Memory growth rate
2. Format as JSON or CSV for Mission Control dashboard consumption
3. Generate sample charts (ASCII preview if possible)
4. Document data source and refresh frequency for dashboard developers
5. Identify gaps: metrics that should be graphed but data not available
Report: visualization status + data files created.
If mission control dashboard ready: push data to /home/alpha/clawd/repos/mission-control/data/
```
