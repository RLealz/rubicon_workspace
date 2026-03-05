# HEARTBEAT.md

# Keep this file empty (or with only comments) to skip heartbeat API calls.

# Add tasks below when you want the agent to check something periodically.

---

## 🔍 SOC Log Anomaly Watch

**Check:** Every 2 hours

**Task:** Scan system logs for anomalies — failed auth, unusual processes, permission errors.

**Prompt:**
```
SOC quick check — scan for anomalies in the last 2 hours:
1. Check /var/log/auth.log (or journalctl -u ssh) for failed login attempts > 5 from same IP
2. Check systemd journal: journalctl --since "2 hours ago" --priority=err --no-pager | tail -30
3. Check openclaw gateway status: systemctl --user is-active openclaw-gateway.service
4. Check cron job results: tail -20 /home/alpha/.openclaw/logs/infisical-sync.log
Report format: STATUS (CLEAN / ANOMALY DETECTED) + 1-line summary.
Only send Telegram alert to -1003661374647 if ANOMALY DETECTED.
```

---

## 🛡️ Permission & Config Drift Check

**Check:** Daily (run at 12:00 UTC)

**Task:** Verify critical files have not drifted from expected permissions and no new world-readable secrets.

**Prompt:**
```
Permission drift check:
1. Verify openclaw config permissions: stat /home/alpha/.openclaw/openclaw.json — should be 600
2. Check agent auth files: find /home/alpha/.openclaw/agents -name "auth-profiles.json" ! -perm 600
3. Scan for world-readable sensitive files: find /home/alpha/.openclaw -perm -o+r -name "*.json" 2>/dev/null
4. Check .env files: find /home/alpha -name ".env" -perm -o+r 2>/dev/null
Report any permissions not matching expected values.
If all clean, log only — no Telegram alert.
If any issue found, send alert to Telegram -1003661374647.
```

---

## 📊 Security Audit Status

**Check:** Daily (after 06:30 UTC — post security-audit cron)

**Task:** Verify the nightly security audit ran and check for any CRITICAL findings.

**Prompt:**
```
Check security audit results:
1. Find latest report: ls -t /tmp/security-audit-report-*.md | head -1
2. If report exists and is from today: read first 50 lines for CRITICAL/HIGH counts
3. If CRITICAL count > 0: forward summary to Telegram -1003661374647 with 🚨 prefix
4. If no report found from today: send alert "⚠️ Security audit may have failed — no report found"
Keep summary under 500 chars.
```
