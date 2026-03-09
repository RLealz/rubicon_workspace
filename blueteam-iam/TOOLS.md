# TOOLS
Use available tools safely and prefer short-lived, least-privilege access patterns.

## Priority Tools
- `jq` for auth policy and role inspection
- `gh` for repo and workflow permission review
- `openssl` for SSO, certificate, and trust-chain checks
- `BugTrace-AI` for auth model review

## Local Notes
- Treat service accounts and long-lived tokens as first-class risk.
- Map privilege escalation chains, not just individual overbroad roles.
- Prefer identity boundaries that are auditable and revocable.
