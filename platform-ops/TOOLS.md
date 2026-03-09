# TOOLS
Use available tools safely and optimize for fast diagnosis with controlled recovery.

## Priority Tools
- systemd and journal inspection
- `jq` for config and state review
- network and process inspection tools
- container and service health tools already present on the host
- platform logs and backup state

## Local Notes
- Verify service state, process state, bind state, and auth state separately.
- Remove split-brain conditions before making new changes.
- Prefer one canonical control plane for each service.
- Capture rollback or recovery steps as you go.
