# HEARTBEAT.md - DevSecOps

# Keep this file empty (or with only comments) to skip heartbeat API calls.

# Add tasks below when you want the agent to check something periodically.

---

## 🏗️ Infrastructure Health

**Check:** Every 2 hours

**Task:** Monitor all Docker services and system resources.

**Prompt:**
```
DevSecOps infrastructure check:
1. Docker services: `docker ps --format "table {{.Names}}\t{{.Status}}" | grep -v "STATUS"`
   - Verify: mission-control (frontend, backend, db, redis), n8n, portainer, uptime-kuma all RUNNING
2. System resources: `df -h /` (disk), `free -h` (memory), `nproc` (CPU count)
3. Tailscale status: `tailscale status` — all peers healthy?
4. OpenClaw gateway: `systemctl --user is-active openclaw-gateway.service`
Report: Service status table + any anomalies.
If any critical service down: send alert to Telegram -1003661374647 with 🔥 prefix.
```

---

## 📦 Deployment Pipeline Watch

**Check:** Every 3 hours

**Task:** Check for stuck deployments or CI/CD failures.

**Prompt:**
```
CI/CD pipeline health:
1. Check GitHub Actions / CI runs (if configured): any failed builds in last 24h?
2. Docker image freshness: `docker images --format "table {{.Repository}}\t{{.Tag}}\t{{.CreatedSince}}"` — any images >7 days old that should be updated?
3. Pending migrations: database schema changes pending?
4. Rollback readiness: can we roll back latest deployment in <5 min?
Report: pipeline status, image age, migration status.
If any pipeline failed or deployment stuck: send alert to Telegram -1003661374647.
```

---

## 🔐 Secrets & Credentials Audit

**Check:** Daily (02:00 UTC)

**Task:** Scan for exposed secrets and verify rotation schedule.

**Prompt:**
```
Daily secrets audit:
1. Scan workspace for patterns: `api[_-]?key`, `secret`, `password`, `token` in /home/alpha/.openclaw/workspace/, /home/alpha/clawd/agents/
2. Check .env files: any world-readable? (perm -o+r)
3. Verify Infisical sync status: last sync time, any errors?
4. Review API key expiry: Moonshot, OpenRouter, Brave, etc. — any expiring in 7 days?
5. Check for plaintext credentials in logs: /var/log/, /home/alpha/.openclaw/logs/
Report: issues found + recommended actions.
If CRITICAL (exposed secret detected): send 🚨 alert to Telegram -1003661374647 immediately.
```

---

## 🌐 Network & Security Posture

**Check:** Daily (03:00 UTC)

**Task:** Verify firewall, open ports, SSL certs.

**Prompt:**
```
Security posture check:
1. Firewall status: `sudo nft list ruleset` — default drop? required ports only?
2. Open ports: `ss -tuln` — any unexpected listening ports?
3. SSL certificates: check expiry for services (Traefik Let's Encrypt)
4. Fail2ban status: `sudo fail2ban-client status` — any jails active?
5. Recent auth failures: `tail -100 /var/log/auth.log | grep "Failed"` — spike?
Report: security status with ✅/❌ for each item.
If any critical issue (firewall down, port 22 open to world, cert expiring <7d): send alert to Telegram -1003661374647.
```

---

## 📊 Mission Control Progress

**Check:** Every 4 hours

**Task:** Update MISSION_CONTROL.md with latest status from DevSecOps projects.

**Prompt:**
```
DevSecOps project status update:
1. Mission Control Dashboard: phase (1-4), completion %, blockers
2. ACP Integration: setup complete? offering designed?
3. Memory System v2.0: installed? tested?
4. Telegram Multi-Channel: groups created? routing configured?
5. TradingDesk: agent created? sub-agents defined?
For each: current status, next steps, ETA.
Update /home/alpha/.openclaw/workspace/MISSION_CONTROL.md with latest info.
If any project behind schedule >3 days: send alert to Telegram -1003661374647.
```

---

## 🧪 Test Environment Validation

**Check:** Weekly (Sunday 02:00 UTC)

**Task:** Verify test/staging environments match production.

**Prompt:**
```
Weekly test environment validation:
1. Compare config hashes: `find /home/alpha/.openclaw -name "*.json" -exec md5sum {} \;` — staging vs prod diffs?
2. Test deployment: simulate production deploy to staging, verify success
3. Database schema: staging matches prod? (`pg_dump --schema-only` diff)
4. Environment variables: staging mirrors production (minus secrets)
5. Canary testing: if canary exists, verify health checks pass
Report: validation results with ✅/❌.
If drift detected: flag for immediate sync.
```

---

## 💾 Backup & Disaster Recovery

**Check:** Daily (01:00 UTC)

**Task:** Verify backups are fresh and recovery is possible.

**Prompt:**
```
Backup health check:
1. Last backup timestamp: `ls -lt /backup/` (or configured backup location)
2. Backup size: reasonable? (not 0 bytes)
3. Test restore (dry-run): list contents of latest backup, verify key files present
4. RPO check: backup age < 24h? (critical data) / < 7d? (non-critical)
5. Offsite sync: if using remote storage, verify last sync succeeded
Report: backup age, size, health status.
If backup missing or stale: send 🚨 alert to Telegram -1003661374647.
```

---

## 🔍 Performance & Capacity Planning

**Check:** Every 6 hours

**Task:** Monitor resource usage trends and forecast capacity.

**Prompt:**
```
Capacity metrics:
1. Disk usage: `df -h /` — any partition >80%?
2. Memory: `free -h` — swap usage? memory pressure?
3. CPU load: `uptime` — 1/5/15 min loads vs. CPU count
4. Database size: `docker exec mission-control-db-1 psql -U postgres -d mission_control -c "SELECT pg_size_pretty(pg_database_size('mission_control'));"`
5. Docker container count: growth trend?
Report: usage percentages + trending (↑/→/↓).
If any resource >85% or growing rapidly: send alert to Telegram -1003661374647 with forecast.
```
