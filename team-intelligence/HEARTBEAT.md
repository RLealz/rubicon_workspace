# HEARTBEAT.md

# Keep this file empty (or with only comments) to skip heartbeat API calls.

# Add tasks below when you want the agent to check something periodically.

---

## 🚨 Critical CVE Watch

**Check:** Every 4 hours

**Task:** Scan for new critical/high CVEs published in the last 4 hours. Focus on:
- CVSS ≥ 9.0 (Critical)
- Actively exploited (CISA KEV additions)
- Affects: Linux, cloud infra, AI/ML libraries, web frameworks

**Prompt:**
```
Search for critical CVEs published in the last 4 hours (CVSS ≥ 9.0 or CISA KEV additions).
Use web_search with query: "CVE 2026 critical CVSS 9 site:nvd.nist.gov OR site:cisa.gov" freshness=ph.
Report: CVE ID, CVSS score, affected product, patch availability.
If any affect our known stack (Linux, Python, Docker, Node.js), flag as HIGH PRIORITY.
Keep response under 800 chars for Telegram delivery.
```

---

## 🌐 Threat Signal Pulse

**Check:** Twice daily (08:00 UTC handled by morning-brew — run at 18:00 UTC)

**Task:** Afternoon threat intelligence update — check for emerging campaigns or IOCs since morning brew.

**Prompt:**
```
Quick afternoon threat signal check (since 08:00 UTC today):
1. web_search: "ransomware attack 2026" freshness=pd — any new campaigns?
2. web_search: "zero day exploit 2026" freshness=pd — new unpatched vulns?
3. web_search: "data breach 2026" freshness=pd — notable incidents?
Summarize in 3 bullets max. If nothing new, respond "No new signals since morning brew."
Deliver to Telegram channel -1003661374647.
```

---

## 📡 OSINT Feed Health

**Check:** Daily

**Task:** Verify threat intelligence sources are reachable and returning fresh data.

**Prompt:**
```
Quick OSINT health check:
- web_search: "NVD National Vulnerability Database" — is nvd.nist.gov responding?
- web_search: "CISA advisories 2026" — any new CISA advisories today?
- web_search: "VirusTotal threat intelligence" — any notable malware reports?
Log status only — no Telegram delivery unless a source is down or CRITICAL finding.
```
