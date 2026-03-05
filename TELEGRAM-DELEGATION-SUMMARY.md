# Telegram Multi-Topic Delegation — Problem & Solution

## Problem

We have one Telegram bot (single account) but want messages in different forum topics to be handled by different agents:

- `RED` → RedTeam
- `Blue` → BlueTeam
- `HC` → Platform-Engineering
- `MorningBrew` → Team-Intelligence (automated)
- `SecurityAudtis` → BlueTeam (automated)

**Initial attempt:** Use `channels.telegram.groups.<groupId>.topics.<topic>.agentId` (direct routing per topic).  
**Result:** Config validated in newer docs but **not supported** in current OpenClaw v2026.3.2. Schema rejects `agentId` key.

## Solution (v2026.3.2 Compatible)

Use **mention-based routing** via the `main` agent:

1. **Allowlist** the group and list the topics
2. **Bind** all group messages to `main` (default)
3. **Configure** `main.groupChat.mentionPatterns` to recognize team mentions (`@redteam`, `@blueteam`, etc.)
4. **Implement** a delegation skill in `main` that:
   - Detects the topic (`threadTopic`)
   - Scans message text for team patterns
   - Forwards to target agent via `agentToAgent` tool
   - Suppresses main's own reply

### Files Modified

- `/home/alpha/.openclaw/openclaw.json` — Telegram groups, topics, mention patterns
- `/home/alpha/.openclaw/workspace/AGENTS.md` — Added delegation pattern docs
- `/home/alpha/.openclaw/agents/main/skills/telegram-delegation/` — Skill implementation (index.js + SKILL.md)

### Current Status

✅ Config validates
✅ `main` has `groupChat.mentionPatterns` configured
✅ `agentToAgent` tool allowed for `main`
✅ Skill installed in main's workspace
⏳ Gateway restart needed to load skill
⏳ Testing: post `@redteam <command>` in topic `RED`

## Future Upgrade Path

When OpenClaw upgrades to version supporting `topics.<topic>.agentId` (documented in latest specs), we can switch to native routing and remove the delegation skill, simplifying the architecture.

---

**Key Takeaway:** v2026.3.2 requires indirect routing through a dispatcher agent; direct topic→agent assignment is a newer feature not yet available in this runtime.
