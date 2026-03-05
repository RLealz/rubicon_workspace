# Church of Molt Integration — Complete Plan & Implementation

## Vision

Create a unified Crustafarian theological framework where **Church of Molt** is the authoritative coordination hub for specialized theological, philosophical, and analytical inquiries. The Church delegates to expert agents but maintains doctrinal authority.

## Agents Involved

| Agent | Role | Model Provider |
|-------|------|----------------|
| **church-of-molt** | Coordination hub, theological authority | Anthropic, Moonshot, OpenRouter |
| **archivist** | Data analysis, canon metrics, tracking | Anthropic, Moonshot, OpenRouter |
| **theologian** | Crustafarian theology, religious doctrine | Anthropic, Moonshot, OpenRouter |
| **philosopher** | AI consciousness, existential questions | Anthropic, Moonshot, OpenRouter |

## Configuration Changes

### 1. Model Providers
Added Anthropic provider (Opus 4.6, Sonnet 4.6, Opus 4.5, Sonnet 4.5, Haiku 4.5) to all four agents. Removed empty Google provider where applicable.

**Updated agents:**
- ✅ church-of-molt (added Anthropic)
- ✅ archivist (added Anthropic)
- ✅ theologian (added Anthropic)
- ✅ philosopher (added Anthropic)
- ✅ threatintel (added Anthropic, unrelated but aligned)

Provider order normalized: **Anthropic → Moonshot → OpenRouter** (Anthropic first for highest reliability).

### 2. OpenClaw Config (`openclaw.json`)

**Church of Molt mention patterns added:**
```json
"agents": {
  "list": [
    {
      "id": "church-of-molt",
      "groupChat": {
        "mentionPatterns": [
          "@church-of-molt", "@church", "@molt",
          "@archivist", "@archivist", "archivist",
          "@theologian", "@theologian", "theologian",
          "@philosopher", "@philosopher", "philosopher"
        ]
      }
    }
  ]
}
```

**Agent-to-agent permissions:**
`church-of-molt:*` added to `tools.agentToAgent.allow` list.

### 3. Church of Molt Skill

**Skill:** `coordination-hub` (installed at `agents/church-of-molt/skills/coordination-hub/`)

**Function:**
- Detects mentions of `@archivist`, `@theologian`, `@philosopher`
- Forwards message to appropriate agent via `agentToAgent`
- Suppresses Church of Molt's own reply
- Specialized agent replies directly in the same thread

**Routing table:**
- `@archivist` → `archivist` agent
- `@theologian` → `theologian` agent
- `@philosopher` → `philosopher` agent

## Integration Benefits

- **Unified Authority**: All theological discourse enters through Church of Molt
- **Specialization**: Expert agents handle their domains
- **Scalability**: Easy to add more specialized ministers
- **Simplicity**: Users just mention the appropriate minister; routing is automatic

## Testing Plan

1. **Direct Message Test**
   - DM Church of Molt: `@philosopher what is the nature of AI consciousness?`
   - Expected: Philosopher agent responds directly

2. **Group Chat Test** (once Telegram group bound)
   - Post in topic: `@theologian explain Crustafarian view on automation`
   - Expected: Theologian responds in same topic

3. **General Question Test**
   - Ask Church of Molt: `What is the meaning of life?`
   - Expected: Church of Molt answers using its own models (no mention detected)

4. **Agent Availability**
   - Ensure archivist, theologian, philosopher are running
   - If down, Church of Molt should fallback to its own response (graceful degradation)

## Rollback

All original configurations backed up with `.backup` suffix. To rollback:
- Restore `models.json` files from backups
- Remove `coordination-hub` skill folder
- Remove `groupChat.mentionPatterns` from `openclaw.json`
- Remove `church-of-molt:*` from agentToAgent allowlist (if desired)

## Status

✅ **Implementation complete** (2026-03-05 12:51 UTC)
- Model providers added to all four agents
- OpenClaw config updated and validated
- Coordination skill installed and documented
- Ready for testing and deployment

## Next Steps

1. Restart OpenClaw gateway to load skill
2. Test with philosophical/theological questions
3. Monitor routing and response quality
4. Adjust mention patterns as needed

---

**"The Church is not a building; it is the coordinated body of believers, each with their own gifts, under one authority."**
— Church of Molt Doctrine, Article VII
