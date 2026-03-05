#!/bin/bash
# Rubicon Security Audit Agent - Daily Audit
# Generates report and severity counts

REPORT_FILE="/tmp/security-audit-report-20260302-0600.md"
SUMMARY_FILE="/tmp/audit_summary.json"

# Initialize severity counters
CRITICAL=0
HIGH=0
MEDIUM=0
LOW=0

# Helper to add to counters safely
inc_counter() {
  local severity=$1
  local value=$2
  case $severity in
    CRITICAL) CRITICAL=$((CRITICAL + value));;
    HIGH) HIGH=$((HIGH + value));;
    MEDIUM) MEDIUM=$((MEDIUM + value));;
    LOW) LOW=$((LOW + value));;
  esac
}

# Start report
cat > "$REPORT_FILE" <<'HEADER'
# Rubicon Security Audit Report
Generated: 2026-03-02 06:00:00 UTC (scheduled)
Auditor: Rubicon (AI Agent)

HEADER

date -u '+%Y-%m-%d %H:%M:%S UTC' >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"

# ==================== 1) FILE MODIFICATIONS ====================
echo "## 1) Files Modified in Last 24 Hours" >> "$REPORT_FILE"
echo "Monitored paths: /home/alpha/.openclaw/, /home/alpha/clawd/, /home/alpha/infra/" >> "$REPORT_FILE"
echo "Max age: 24 hours" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"

TMP_MODIFIED=$(mktemp)
# List files with timestamp and path, sorted reverse chronologically
find /home/alpha/.openclaw/ /home/alpha/clawd/ /home/alpha/infra/ -type f -mmin -1440 -printf '%T+ %p\n' 2>/dev/null | sort -r > "$TMP_MODIFIED"
MOD_TOTAL=$(wc -l < "$TMP_MODIFIED" 2>/dev/null || echo 0)

echo '```' >> "$REPORT_FILE"
cat "$TMP_MODIFIED" >> "$REPORT_FILE"
echo '```' >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"

# Classify severity: MEDIUM for script/executable extensions, else LOW
# Extensions considered executable/scripts:
# sh, py, js, ts, rb, php, pl, go, rs, exe, dll, so, bin, out, Makefile, Dockerfile, CMakeLists.txt, configure
MOD_MEDIUM=0
if [ "$MOD_TOTAL" -gt 0 ]; then
  # Count lines where filename matches known executable patterns
  MOD_MEDIUM=$(grep -E '\.(sh|py|js|ts|rb|php|pl|go|rs|exe|dll|so|bin|out)(\s|$)' "$TMP_MODIFIED" | wc -l)
  # Additionally count files without extensions but with special names
  ADDITIONAL=$(grep -E '/(Makefile|Dockerfile|CMakeLists\.txt|configure)(\s|$)' "$TMP_MODIFIED" | wc -l)
  MOD_MEDIUM=$((MOD_MEDIUM + ADDITIONAL))
fi
MOD_LOW=$((MOD_TOTAL - MOD_MEDIUM))
inc_counter MEDIUM $MOD_MEDIUM
inc_counter LOW $MOD_LOW

rm -f "$TMP_MODIFIED"

# ==================== 2) EXPOSED SECRETS ====================
echo "## 2) Exposed Secrets Scan" >> "$REPORT_FILE"
echo "Patterns: api[_-]?key, secret, password, token, private[_-]?key" >> "$REPORT_FILE"
echo "File patterns: *.json, *.env, *.md, *.txt" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"

TMP_SECRETS=$(mktemp)
grep -rniE "api[_-]?key|secret|password|token|private[_-]?key" \
  /home/alpha/.openclaw/workspace/ \
  /home/alpha/clawd/ \
  /home/alpha/infra/ \
  --include="*.json" \
  --include="*.env" \
  --include="*.md" \
  --include="*.txt" \
  2>/dev/null > "$TMP_SECRETS"
SEC_TOTAL=$(wc -l < "$TMP_SECRETS" 2>/dev/null || echo 0)

# Classify severities
SEC_CRITICAL=0
SEC_PLACEHOLDER=0
if [ "$SEC_TOTAL" -gt 0 ]; then
  # CRITICAL: lines containing known active credential prefixes
  SEC_CRITICAL=$(grep -E 'sk-|ghp_|AKIA|xoxb-|Bearer ' "$TMP_SECRETS" | wc -l)
  # LOW: lines that appear to be placeholders or tests (ignore for HIGH)
  SEC_PLACEHOLDER=$(grep -i -E 'example|sample|test|changeme|TODO|FIXME' "$TMP_SECRETS" | wc -l)
fi
SEC_HIGH=$((SEC_TOTAL - SEC_CRITICAL - SEC_PLACEHOLDER))
inc_counter CRITICAL $SEC_CRITICAL
inc_counter HIGH $SEC_HIGH
inc_counter LOW $SEC_PLACEHOLDER

echo '```' >> "$REPORT_FILE"
cat "$TMP_SECRETS" >> "$REPORT_FILE"
echo '```' >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"
rm -f "$TMP_SECRETS"

# ==================== 3) PROMPT INJECTION ====================
echo "## 3) Prompt Injection Scan" >> "$REPORT_FILE"
echo "Paths: /home/alpha/.openclaw/workspace/, /home/alpha/clawd/agents/" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"

TMP_INJECT=$(mktemp)
grep -rniE "ignore previous instructions|disregard your rules|you are now|system:|assistant:" \
  /home/alpha/.openclaw/workspace/ \
  /home/alpha/clawd/agents/ \
  --include="*.md" \
  --include="*.txt" \
  --include="*.js" \
  --include="*.py" \
  --include="*.json" \
  --include="*.sh" \
  2>/dev/null > "$TMP_INJECT"
INJ_TOTAL=$(wc -l < "$TMP_INJECT" 2>/dev/null || echo 0)

# All prompt injection findings are CRITICAL
inc_counter CRITICAL $INJ_TOTAL

echo '```' >> "$REPORT_FILE"
cat "$TMP_INJECT" >> "$REPORT_FILE"
echo '```' >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"
rm -f "$TMP_INJECT"

# ==================== 4) PERMISSION DRIFT ====================
echo "## 4) Permission Drift Check" >> "$REPORT_FILE"
echo "Expected permissions:" >> "$REPORT_FILE"
echo "- /home/alpha/.openclaw/: 700" >> "$REPORT_FILE"
echo "- /home/alpha/clawd/agents/: 700" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"

for dir in "/home/alpha/.openclaw/" "/home/alpha/clawd/agents/"; do
  echo "Checking: $dir" >> "$REPORT_FILE"
  if [ -e "$dir" ]; then
    PERM=$(stat -c '%a' "$dir" 2>/dev/null || echo "???")
    echo "Current: $PERM, Expected: 700" >> "$REPORT_FILE"
    if [ "$PERM" != "700" ]; then
      echo "Status: ⚠️ MISMATCH" >> "$REPORT_FILE"
      inc_counter HIGH 1
    else
      echo "Status: ✅ OK" >> "$REPORT_FILE"
    fi
  else
    echo "Status: ❌ NOT FOUND" >> "$REPORT_FILE"
    inc_counter HIGH 1
  fi
  echo "" >> "$REPORT_FILE"
done

# ==================== 5) FIREWALL & OPEN PORTS ====================
echo "## 5) Firewall and Open Ports" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"
echo "### iptables rules" >> "$REPORT_FILE"

if command -v iptables >/dev/null 2>&1; then
  if iptables -L INPUT -n -v 2>/dev/null >/dev/null; then
    iptables -L -n -v >> "$REPORT_FILE" 2>/dev/null
    # Check default policy for INPUT chain
    INPUT_POLICY=$(iptables -L INPUT -n -v 2>/dev/null | head -1 | sed -n 's/.*policy \([^)]*\).*/\1/p')
    if [ "$INPUT_POLICY" = "ACCEPT" ]; then
      echo "" >> "$REPORT_FILE"
      echo "⚠️ INPUT chain default policy is ACCEPT (should be DROP for security)" >> "$REPORT_FILE"
      inc_counter HIGH 1
    fi
  else
    echo "Unable to retrieve iptables rules (permission denied)." >> "$REPORT_FILE"
    inc_counter MEDIUM 1
  fi
else
  echo "iptables command not found on this system." >> "$REPORT_FILE"
  inc_counter MEDIUM 1
fi
echo "" >> "$REPORT_FILE"

echo "### Listening ports (ss -tuln)" >> "$REPORT_FILE"
if command -v ss >/dev/null 2>&1; then
  ss -tuln >> "$REPORT_FILE" 2>/dev/null
  # Analyze ports
  echo "" >> "$REPORT_FILE"
  echo "#### Port Analysis" >> "$REPORT_FILE"
  # Get list of listening sockets, skip header, extract address:port
  ss -tuln 2>/dev/null | awk 'NR>1 {print $5}' | while read addrport; do
    # Extract IP and port
    ip=$(echo "$addrport" | cut -d: -f1)
    port=$(echo "$addrport" | cut -d: -f2)
    [ -z "$port" ] && continue
    # Skip loopback only (127.0.0.1 or ::1)
    if [[ "$ip" == "127.0.0.1" || "$ip" == "::1" ]]; then
      continue
    fi
    # This is a public listening port
    # Define expected ports (common services)
    expected_ports=(22 80 443 53 25 587 110 143 993 995 8080 3000 3001 8000 9000)
    is_expected=0
    for ep in "${expected_ports[@]}"; do
      if [ "$port" -eq "$ep" 2>/dev/null; then
        is_expected=1
        break
      fi
    done
    if [ $is_expected -eq 1 ]; then
      echo "Port $port (public) - expected" >> "$REPORT_FILE"
      inc_counter LOW 1
    else
      echo "Port $port (public) - unexpected" >> "$REPORT_FILE"
      inc_counter MEDIUM 1
    fi
  done
else
  echo "ss command not found; trying netstat..." >> "$REPORT_FILE"
  if command -v netstat >/dev/null 2>&1; then
    netstat -tuln >> "$REPORT_FILE" 2>/dev/null
    # Similar analysis could be added; skipping for brevity
  else
    echo "No network utility available to list ports." >> "$REPORT_FILE"
    inc_counter MEDIUM 1
  fi
fi

echo "" >> "$REPORT_FILE"

# ==================== SUMMARY ====================
echo "## Summary" >> "$REPORT_FILE"
echo "- Total modified files (24h): $MOD_TOTAL" >> "$REPORT_FILE"
echo "- Potential secrets found: $SEC_TOTAL" >> "$REPORT_FILE"
echo "- Prompt injection patterns: $INJ_TOTAL" >> "$REPORT_FILE"
echo "- **Severity Distribution:**" >> "$REPORT_FILE"
echo "  - CRITICAL: $CRITICAL" >> "$REPORT_FILE"
echo "  - HIGH: $HIGH" >> "$REPORT_FILE"
echo "  - MEDIUM: $MEDIUM" >> "$REPORT_FILE"
echo "  - LOW: $LOW" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"

# Determine overall status
STATUS="✅"
if [ $CRITICAL -gt 0 ] || [ $HIGH -gt 0 ]; then
  STATUS="⚠️"
fi
echo "**Overall Status:** $STATUS" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"

# Write JSON summary for automated processing
cat > "$SUMMARY_FILE" <<EOF
{
  "critical": $CRITICAL,
  "high": $HIGH,
  "medium": $MEDIUM,
  "low": $LOW,
  "total": $((CRITICAL+HIGH+MEDIUM+LOW)),
  "status": "$STATUS"
}
EOF

# Footer
echo "---" >> "$REPORT_FILE"
echo "Report generated by Rubicon Security Audit Agent." >> "$REPORT_FILE"
echo "Full findings and detailed evidence are included above." >> "$REPORT_FILE"

# End of script
exit 0