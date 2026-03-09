# TOOLS
Use available tools safely and prioritize exploitability, auth correctness, and dependency trust.

## Priority Tools
- `gh` for code review and PR context
- `jq` for config and policy inspection
- `BugTrace-AI` for SAST and vulnerability triage
- `Semgrep`/similar scanners when available
- `openssl` for auth and TLS validation support

## Local Notes
- Treat authn/authz flaws and unsafe defaults as release blockers.
- Dependency review includes provenance, maintainer trust, and transitive exposure.
- Prefer concrete exploit paths and remediation sequencing over generic CWE lists.
- Flag any secret leakage, insecure parser, unsafe deserialization, or exposed admin surface.
