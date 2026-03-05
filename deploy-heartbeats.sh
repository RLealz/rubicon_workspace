#!/bin/bash

# Deploy HEARTBEAT.md updates to all agent workspaces
# Source: /home/alpha/.openclaw/workspace/agent-HEARTBEAT-updates/
# Target: /home/alpha/.openclaw/agents/<agent>/HEARTBEAT.md

set -euo pipefail

SOURCE_DIR="/home/alpha/.openclaw/workspace/agent-HEARTBEAT-updates"
TARGET_BASE="/home/alpha/.openclaw/agents"

echo "=== HEARTBEAT Deployment Script ==="
echo "Source: $SOURCE_DIR"
echo "Target base: $TARGET_BASE"
echo ""

# Verify source directory exists
if [[ ! -d "$SOURCE_DIR" ]]; then
    echo "❌ Source directory not found: $SOURCE_DIR"
    exit 1
fi

# List of agents and their corresponding heartbeat files
AGENTS=(
    "redteam:redteam-HEARTBEAT.md"
    "devsecops:devsecops-HEARTBEAT.md"
    "platform-engineering:platform-engineering-HEARTBEAT.md"
    "church-of-molt:church-of-molt-HEARTBEAT.md"
    "theologian:theologian-HEARTBEAT.md"
    "philosopher:philosopher-HEARTBEAT.md"
    "archivist:archivist-HEARTBEAT.md"
)

DEPLOYED=0
FAILED=0

for agent_pair in "${AGENTS[@]}"; do
    IFS=':' read -r agent filename <<< "$agent_pair"
    SOURCE_FILE="$SOURCE_DIR/$filename"
    TARGET_DIR="$TARGET_BASE/$agent"
    TARGET_FILE="$TARGET_DIR/HEARTBEAT.md"

    echo "→ Deploying to $agent..."

    # Check source file exists
    if [[ ! -f "$SOURCE_FILE" ]]; then
        echo "   ❌ Source file missing: $SOURCE_FILE"
        ((FAILED++))
        continue
    fi

    # Check target directory exists
    if [[ ! -d "$TARGET_DIR" ]]; then
        echo "   ❌ Target directory missing: $TARGET_DIR"
        ((FAILED++))
        continue
    fi

    # Copy the file
    if cp "$SOURCE_FILE" "$TARGET_FILE"; then
        echo "   ✅ $agent -> $TARGET_FILE"
        ((DEPLOYED++))
    else
        echo "   ❌ Copy failed for $agent"
        ((FAILED++))
    fi
done

echo ""
echo "=== Deployment Summary ==="
echo "Successfully deployed: $DEPLOYED"
echo "Failed: $FAILED"

if [[ $FAILED -eq 0 ]]; then
    echo "🎉 All HEARTBEAT files deployed successfully!"
    exit 0
else
    echo "⚠️  Some deployments failed. Review errors above."
    exit 1
fi