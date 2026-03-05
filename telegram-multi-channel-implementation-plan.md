# Telegram Multi-Channel Implementation Plan

## Current State Analysis

### Configuration Status
- **Gateway**: Running on `ws://127.0.0.1:18789`, local mode, loopback binding
- **Channels**: Telegram enabled, Discord enabled but not configured
- **Cron Jobs**: 2 jobs configured to deliver to `-1003661374647` (old group)
- **Delivery Issues**: Both jobs have `lastError: "cron announce delivery failed"`

### User Requirements
- Old group `-1003661374647`: Still active, I'm admin, but won't get morning brew/security audit
- New group: Has multiple topics including dedicated ones for Red, Blue, HC teams
- Flow: Full report on disk, summary with report attached in Telegram
- Each run goes to correct topic/section

## Implementation Plan

### Phase 1: Configuration Discovery

**Tasks:**
1. Get new group ID and topic names from user
2. Verify bot permissions in new group
3. Test delivery to new group/topic

**Questions for User:**
1. What's the new group ID? (Use @getidsbot to find)
2. What topic name should Morning Brew go to?
3. What topic name should Security Audit go to?
4. What topic names for Red, Blue, HC teams?

### Phase 2: Cron Job Updates

**Tasks:**
1. Update cron jobs to use new group ID
2. Add topic routing to delivery configuration
3. Test delivery with manual job runs

**Configuration Changes:**
```json
// Before (old group)
{
  "delivery": {
    "mode": "announce",
    "channel": "telegram",
    "to": "-1003661374647"
  }
}

// After (new group + topic)
{
  "delivery": {
    "mode": "announce",
    "channel": "telegram",
    "to": "3874489920",
    "topic": "MorningBrew"
  }
}
```

### Phase 3: Multi-Channel Routing Setup

**Tasks:**
1. Configure dedicated topics for each team
2. Set up routing rules for agent communications
3. Test all delivery paths

**Configuration Structure:**
```json
// ~/.openclaw/openclaw.json additions
{
  "telegram": {
    "enabled": true,
    "dmPolicy": "pairing",
    "botToken": "__OPENCLAW_REDACTED__",
    "groupPolicy": "allowlist",
    "streaming": "partial",
    "routing": {
      "dedicatedTopics": {
        "redTeam": "Red",
        "blueTeam": "Blue",
        "highCouncil": "HC",
        "morningBrew": "MorningBrew",
        "securityAudit": "SecurityAudtis"
      }
    }
  }
}
```

### Phase 4: Testing & Validation

**Tasks:**
1. Test delivery to each topic
2. Verify full report + summary flow
3. Test cron job execution
4. Validate error handling

**Test Cases:**
- Manual delivery to each topic
- Cron job execution and delivery
- Error scenarios (bot offline, topic missing)
- Rate limiting handling

## Implementation Steps

### Step 1: Configuration Updates

1. **Get user input** for new group ID and topic names
2. **Update cron jobs** with new delivery targets
3. **Update OpenClaw config** with routing rules

### Step 2: Testing

1. **Manual delivery tests** for each topic
2. **Cron job tests** with manual triggers
3. **Error handling tests** (simulate bot offline)

### Step 3: Validation

1. **Check delivery logs** for all topics
2. **Verify report generation** and attachment flow
3. **Test team routing** for Red/Blue/HC communications

## Risk Assessment

### Low Risk
- Configuration changes are JSON-based and reversible
- Bot already has permissions in old group
- Delivery failures are logged and recoverable

### Medium Risk
- Topic name typos could cause delivery to wrong place
- Group ID changes require manual verification
- Rate limiting could affect delivery during high load

### High Risk
- Bot removed from group would break all delivery
- Channel ID changes require manual intervention
- Permission changes could block delivery

## Rollback Plan

### If delivery fails after changes:
1. **Immediate rollback**: Restore old group ID in cron jobs
2. **Check bot status**: Verify bot is still in new group
3. **Verify permissions**: Ensure bot has post permissions
4. **Test manually**: Send test message to confirm delivery works

### Rollback Commands:
```bash
# Restore old config
openclaw config set cron.jobs[0].delivery.to "-1003661374647"
openclaw config set cron.jobs[1].delivery.to "-1003661374647"
```

## Success Criteria

### Primary Criteria
- ✅ Cron jobs execute and deliver to new group
- ✅ Delivery goes to correct topics (morning brew, security audit)
- ✅ Full report + summary flow maintained
- ✅ Team routing works for Red/Blue/HC

### Secondary Criteria
- ✅ Delivery succeeds within 30 seconds
- ✅ Error handling works (retries, fallbacks)
- ✅ No delivery failures for 7 consecutive runs
- ✅ All topics receive expected content

## Timeline

### Phase 1: Discovery (1 hour)
- Get user input for group IDs and topic names
- Verify bot permissions

### Phase 2: Implementation (2 hours)
- Update cron jobs
- Update OpenClaw config
- Test delivery

### Phase 3: Validation (1 hour)
- Test all delivery paths
- Validate error handling
- Document final configuration

**Total Estimated Time: 4 hours**

## Cost Analysis

### Model Usage
- Morning Brew: ~5-10K tokens per run (moonshot/kimi-k2.5)
- Security Audit: ~2-5K tokens per run (varies by findings)
- **Daily cost**: ~$0.05-0.10 (based on model rates)

### Operational Cost
- **Zero additional cost** - uses existing OpenClaw infrastructure
- **No new dependencies** - only configuration changes
- **Minimal downtime** - changes are incremental

## Next Steps

1. **User provides**: New group ID and topic names
2. **Implement**: Update cron jobs and OpenClaw config
3. **Test**: Manual delivery tests and cron job execution
4. **Validate**: Verify all delivery paths work correctly
5. **Document**: Final configuration and troubleshooting guide

## Dependencies

- ✅ OpenClaw gateway running
- ✅ Telegram bot configured and working
- ✅ Cron jobs exist and executable
- ✅ User provides group ID and topic names
- ✅ Bot has permissions in new group

## Open Questions

1. **Topic names**: What are the exact topic names in the new group?
2. **Delivery preferences**: Should morning brew and security audit go to specific topics?
3. **Team routing**: Should Red/Blue/HC teams have dedicated topics for agent communications?
4. **Fallback behavior**: What should happen if delivery to topic fails? (fallback to general channel?)

## Success Metrics

- **Delivery success rate**: 100% for 7 consecutive runs
- **Delivery time**: <30 seconds from job completion to Telegram delivery
- **Error rate**: <1% (recoverable errors only)
- **Team satisfaction**: All teams receive communications in their dedicated topics

---

**Ready for review and approval.**

**Next step:** User provides group ID and topic names to proceed with implementation.

## Updated Configuration with User Data

### New Group ID
- **Group ID**: `3874489920`

### Topic Names and Relations
| Topic Name | Purpose | Relation |
|------------|---------|----------|
| `Red` | RedTeam chat | Direct team communication |
| `Blue` | BlueTeam chat | Direct team communication |
| `HC` | High council/platform eng chat | Direct team communication |
| `MorningBrew` | Morning brews | Automated delivery |
| `SecurityAudtis` | Security audits | Automated delivery |
| `General` | Everything else | General discussion |

### Updated Configuration

#### Cron Job Delivery Targets
```json
// Morning Brew cron job
{
  "delivery": {
    "mode": "announce",
    "channel": "telegram",
    "to": "3874489920",
    "topic": "MorningBrew"
  }
}

// Security Audit cron job
{
  "delivery": {
    "mode": "announce",
    "channel": "telegram",
    "to": "3874489920",
    "topic": "SecurityAudtis"
  }
}
```

#### Telegram Routing Configuration
```json
// ~/.openclaw/openclaw.json additions
{
  "telegram": {
    "enabled": true,
    "dmPolicy": "pairing",
    "botToken": "__OPENCLAW_REDACTED__",
    "groupPolicy": "allowlist",
    "streaming": "partial",
    "routing": {
      "dedicatedTopics": {
        "redTeam": "Red",
        "blueTeam": "Blue",
        "highCouncil": "HC",
        "morningBrew": "MorningBrew",
        "securityAudit": "SecurityAudtis"
      }
    }
  }
}
```

### Implementation Commands

#### Update Cron Jobs
```bash
# Morning Brew
openclaw cron update 9c15eba9-607c-4182-a867-d5abc9f1147b \
  --delivery-channel telegram \
  --delivery-to 3874489920 \
  --delivery-topic MorningBrew

# Security Audit
openclaw cron update f89cec34-580f-4a1f-88c5-5d6d4fee75a4 \
  --delivery-channel telegram \
  --delivery-to 3874489920 \
  --delivery-topic SecurityAudtis
```

#### Update OpenClaw Config
```bash
# Add routing configuration
openclaw config set telegram.routing.dedicatedTopics.redTeam "Red"
openclaw config set telegram.routing.dedicatedTopics.blueTeam "Blue"
openclaw config set telegram.routing.dedicatedTopics.highCouncil "HC"
openclaw config set telegram.routing.dedicatedTopics.morningBrew "MorningBrew"
openclaw config set telegram.routing.dedicatedTopics.securityAudit "SecurityAudtis"
```

### Testing Commands

#### Manual Delivery Tests
```bash
# Test Morning Brew delivery
openclaw message send \
  --channel telegram \
  --to 3874489920 \
  --topic MorningBrew \
  --message "Test Morning Brew delivery"

# Test Security Audit delivery
openclaw message send \
  --channel telegram \
  --to 3874489920 \
  --topic SecurityAudtis \
  --message "Test Security Audit delivery"

# Test team communications
openclaw message send \
  --channel telegram \
  --to 3874489920 \
  --topic Red \
  --message "Test Red Team communication"

openclaw message send \
  --channel telegram \
  --to 3874489920 \
  --topic Blue \
  --message "Test Blue Team communication"

openclaw message send \
  --channel telegram \
  --to 3874489920 \
  --topic HC \
  --message "Test High Council communication"
```

#### Cron Job Tests
```bash
# Test Morning Brew cron job
openclaw cron run 9c15eba9-607c-4182-a867-d5abc9f1147b

# Test Security Audit cron job
openclaw cron run f89cec34-580f-4a1f-88c5-5d6d4fee75a4
```

### Troubleshooting Commands

#### Check Bot Status
```bash
# Verify bot is in group
openclaw channels status

# Check bot permissions
openclaw message send --channel telegram --to 3874489920 --message "Test bot permissions"
```

#### Check Delivery Logs
```bash
# Check cron job status
openclaw cron list

# Check recent runs
openclaw cron runs --job-id 9c15eba9-607c-4182-a867-d5abc9f1147b
```

### Validation Checklist

#### Pre-Deployment
- [ ] New group ID confirmed: 3874489920
- [ ] Topic names confirmed: Red, Blue, HC, MorningBrew, SecurityAudtis, General
- [ ] Bot permissions verified in new group
- [ ] Old group `-1003661374647` remains active

#### Post-Deployment
- [ ] Cron jobs updated with new delivery targets
- [ ] OpenClaw config updated with routing rules
- [ ] Manual delivery tests pass for all topics
- [ ] Cron job execution and delivery verified
- [ ] Error handling tested and working
- [ ] Team routing working for Red/Blue/HC communications

#### Long-term Monitoring
- [ ] Delivery success rate > 95% for 7 consecutive runs
- [ ] No delivery failures for 30 consecutive runs
- [ ] All teams receive communications in correct topics
- [ ] Error logs show < 1% recoverable errors

---

**Implementation Ready:**

This plan is ready for implementation with the provided group ID and topic names. The configuration changes are minimal and reversible, with comprehensive testing and validation steps included.

**Estimated Completion Time:** 4 hours

**Dependencies:**
- OpenClaw gateway running
- Telegram bot configured and working
- User confirms implementation is ready to proceed