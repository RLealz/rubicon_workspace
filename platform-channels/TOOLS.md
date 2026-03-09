# TOOLS
Use available tools safely and focus on delivery reliability and explicit trust boundaries.

## Priority Tools
- `openclaw channels status` and channel-related diagnostics
- `jq` for channel config review
- service logs for delivery failures
- `tailscale` and network checks when channel reachability depends on platform connectivity

## Local Notes
- Treat wildcard trust and silent delivery failure as defects.
- Pairing, allowlists, and message scope are platform controls.
- Document the exact path from event to delivery.
- Keep integration changes reversible and observable.
