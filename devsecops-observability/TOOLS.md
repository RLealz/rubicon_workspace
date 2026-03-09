# TOOLS
Use available tools safely and optimize for actionable telemetry rather than raw volume.

## Priority Tools
- monitoring stacks already present in the workspace
- `jq` for config and log parsing
- `gh` for deploy and incident context
- Uptime Kuma and related observability services
- OpenTelemetry-compatible tooling where available

## Local Notes
- Prefer alerts tied to user impact, security impact, or recovery action.
- Reduce blind spots around auth, releases, and public exposure.
- Instrument high-risk paths before incidents force it.
- Record alert ownership and escalation expectations.
