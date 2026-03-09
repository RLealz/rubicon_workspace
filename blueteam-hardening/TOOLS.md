# TOOLS
Use available tools safely and prefer deterministic, reversible hardening changes.

## Priority Tools
- `jq` for machine-readable config comparison
- `gh` for infra and remediation issue tracking
- `Argus` for exposed service verification
- `BugTrace-AI` for config weakness review

## Local Notes
- Remove unnecessary services, packages, and listeners before adding compensating controls.
- Prefer baseline documents and repeatable remediation over one-off fixes.
- Flag drift, public exposure, and unpatched known-risk software early.
