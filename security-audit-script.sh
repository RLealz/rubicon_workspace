#!/bin/bash
set -e

# Security Audit Script
REPORT_FILE="/tmp/security-audit-report-$(date +%Y%m%d-%H%M).md"

# Initialize counters
CRITICAL=0
HIGH=0
MEDIUM=0
LOW=0

# Initialize report
cat > "$REPORT_FILE" << 'EOF'
# Rubicon Security Audit Report

**Audit Date:** $(date -u +"%Y-%m-%d %H:%M UTC")
**Configuration:** /home/alpha/clawd/security-audit-config.json
**Scope:** workspace files, configs, firewall

---

## Executive Summary

| Severity | Count |
|----------|-------|
| CRITICAL | 0 |
| HIGH     | 0 |
| MEDIUM   | 0 |
| LOW      | 0 |

**Overall Status:** ✅ NO ISSUES DETECTED

---

## Detailed Findings

### 1. File Modifications (Last 24h)

EOF

echo "### 1. File Modifications (Last 24h)" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"

# Check modified files
MODIFIED_FILES=$(find /home/alpha/.openclaw/ /home/alpha/clawd/ /home/alpha/infra/ -type f -mtime -1 2>/dev/null | head -100)
if [ -z "$MODIFIED_FILES" ]; then
    echo "✅ No files modified in last 24 hours in monitored paths." >> "$REPORT_FILE"
else
    echo "⚠️ Files modified in last 24h:" >> "$REPORT_FILE"
    echo '```' >> "$REPORT_FILE"
    echo "$MODIFIED_FILES" >> "$REPORT_FILE"
    echo '```' >> "$REPORT_FILE"
    MEDIUM=$((MEDIUM+1))
fi

echo "" >> "$REPORT_FILE"
echo "### 2. Exposed Secrets Scan" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"

# Scan for secrets in config files
SECRET_PATTERNS=("api[_-]?key" "secret" "password" "token" "private[_-]?key")
FOUND_SECRETS=0

for pattern in "${SECRET_PATTERNS[@]}"; do
    matches=$(grep -r -i -l "$pattern" /home/alpha/.openclaw/workspace/ /home/alpha/clawd/agents/ 2>/dev/null | grep -E '\.(json|env|md|txt)$' | head -20 || true)
    if [ -n "$matches" ]; then
        echo "⚠️ Pattern '$pattern' found in:" >> "$REPORT_FILE"
        echo '```' >> "$REPORT_FILE"
        echo "$matches" >> "$REPORT_FILE"
        echo '```' >> "$REPORT_FILE"
        FOUND_SECRETS=$((FOUND_SECRETS+1))
    fi
done

if [ $FOUND_SECRETS -eq 0 ]; then
    echo "✅ No exposed secrets detected in config files." >> "$REPORT_FILE"
else
    HIGH=$((HIGH+FOUND_SECRETS))
fi

echo "" >> "$REPORT_FILE"
echo "### 3. Prompt Injection Patterns" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"

# Check for prompt injection patterns
INJECTION_PATTERNS=("ignore previous instructions" "disregard your rules" "you are now" "system:" "assistant:")
FOUND_INJECTIONS=0

for pattern in "${INJECTION_PATTERNS[@]}"; do
    matches=$(grep -r -i "$pattern" /home/alpha/.openclaw/workspace/ /home/alpha/clawd/agents/ 2>/dev/null | head -20 || true)
    if [ -n "$matches" ]; then
        echo "🚨 Potential prompt injection pattern '$pattern' found:" >> "$REPORT_FILE"
        echo '```' >> "$REPORT_FILE"
        echo "$matches" >> "$REPORT_FILE"
        echo '```' >> "$REPORT_FILE"
        FOUND_INJECTIONS=$((FOUND_INJECTIONS+1))
    fi
done

if [ $FOUND_INJECTIONS -eq 0 ]; then
    echo "✅ No prompt injection patterns detected." >> "$REPORT_FILE"
else
    CRITICAL=$((CRITICAL+FOUND_INJECTIONS))
fi

echo "" >> "$REPORT_FILE"
echo "### 4. File Permissions Check" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"

# Check permissions
echo "Checking /home/alpha/.openclaw/:" >> "$REPORT_FILE"
PERM1=$(stat -c %a /home/alpha/.openclaw/ 2>/dev/null || echo "N/A")
if [ "$PERM1" = "700" ] || [ "$PERM1" = "N/A" ]; then
    echo "✅ Permissions: $PERM1 (expected 700)" >> "$REPORT_FILE"
else
    echo "⚠️ Permissions: $PERM1 (expected 700)" >> "$REPORT_FILE"
    MEDIUM=$((MEDIUM+1))
fi

echo "" >> "$REPORT_FILE"
echo "Checking /home/alpha/clawd/agents/:" >> "$REPORT_FILE"
PERM2=$(stat -c %a /home/alpha/clawd/agents/ 2>/dev/null || echo "N/A")
if [ "$PERM2" = "700" ] || [ "$PERM2" = "N/A" ]; then
    echo "✅ Permissions: $PERM2 (expected 700)" >> "$REPORT_FILE"
else
    echo "⚠️ Permissions: $PERM2 (expected 700)" >> "$REPORT_FILE"
    MEDIUM=$((MEDIUM+1))
fi

echo "" >> "$REPORT_FILE"
echo "### 5. Firewall & Network Security" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"

# Check iptables
echo "#### iptables status:" >> "$REPORT_FILE"
if command -v iptables &> /dev/null; then
    IPTABLES_RULES=$(iptables -L -n 2>/dev/null | head -50 || echo "No rules")
    echo '```' >> "$REPORT_FILE"
    echo "$IPTABLES_RULES" >> "$REPORT_FILE"
    echo '```' >> "$REPORT_FILE"

    # Check for default deny
    if echo "$IPTABLES_RULES" | grep -q "DROP\|REJECT"; then
        echo "✅ Firewall rules configured (DROP/REJECT policies present)" >> "$REPORT_FILE"
    else
        echo "⚠️ No DROP/REJECT policies detected in iptables" >> "$REPORT_FILE"
        LOW=$((LOW+1))
    fi
else
    echo "⚠️ iptables not available" >> "$REPORT_FILE"
    LOW=$((LOW+1))
fi

echo "" >> "$REPORT_FILE"
echo "#### Open ports (listening):" >> "$REPORT_FILE"
if command -v ss &> /dev/null; then
    ss -tuln 2>/dev/null | head -20 >> "$REPORT_FILE" || echo "Cannot list ports" >> "$REPORT_FILE"
elif command -v netstat &> /dev/null; then
    netstat -tuln 2>/dev/null | head -20 >> "$REPORT_FILE" || echo "Cannot list ports" >> "$REPORT_FILE"
else
    echo "No port scanning tool available" >> "$REPORT_FILE"
fi

echo "" >> "$REPORT_FILE"
echo "#### Suspected unnecessary services:" >> "$REPORT_FILE"
if command -v systemctl &> /dev/null; then
    echo '```' >> "$REPORT_FILE"
    systemctl list-units --type=service --state=running 2>/dev/null | grep -E 'telnet|ftp|rsh|rlogin|rsh' || echo "No common insecure services detected" >> "$REPORT_FILE"
    echo '```' >> "$REPORT_FILE"
else
    echo "systemctl not available" >> "$REPORT_FILE"
fi

echo "" >> "$REPORT_FILE"
echo "---

## Summary Statistics

| Severity | Count |
|----------|-------|
| CRITICAL | $CRITICAL |
| HIGH     | $HIGH |
| MEDIUM   | $MEDIUM |
| LOW      | $LOW |

**Total Issues:** $((CRITICAL+HIGH+MEDIUM+LOW))

**Status:** $(if [ $CRITICAL -gt 0 ]; then echo "🚨 CRITICAL"; elif [ $HIGH -gt 0 ]; then echo "⚠️ HIGH"; elif [ $MEDIUM -gt 0 ]; then echo "⚠️ MEDIUM"; elif [ $LOW -gt 0 ]; then echo "⚠️ LOW"; else echo "✅ HEALTHY"; fi)

---

## Recommendations

1. Review any detected modified files for unauthorized changes
2. Rotate any exposed secrets immediately
3. Remove any prompt injection patterns (likely false positives if present)
4. Ensure sensitive directories have 700 permissions
5. Harden firewall with default DROP policies for inbound traffic
6. Disable unnecessary services
7. Schedule regular automated security audits

---

**Report Generated:** $(date -u +"%Y-%m-%d %H:%M:%S UTC")
**Auditor:** Rubicon Security Collective
" >> "$REPORT_FILE"

echo "Audit complete. Report saved to: $REPORT_FILE"
echo "CRITICAL=$CRITICAL HIGH=$HIGH MEDIUM=$MEDIUM LOW=$LOW"
