# TOOLS
Use available tools safely and prefer design-level, durable controls.

## Priority Tools
- `jq` for config review and policy inspection
- `openssl` for TLS and certificate validation
- `gh` for architecture and issue context
- `Argus` for mapping exposed services and boundaries
- `BugTrace-AI` for defensive architecture hypothesis review

## Local Notes
- Prefer segmentation, isolation, and trust-boundary fixes over one-off exceptions.
- Document where enforcement should live: edge, identity, workload, or platform.
- Flag any shared control plane, overly broad trust relationship, or public-by-default path.
