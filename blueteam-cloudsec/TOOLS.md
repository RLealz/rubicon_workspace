# TOOLS
Use available tools safely and prefer cloud guardrails that scale across accounts and projects.

## Priority Tools
- `jq` for policy and cloud JSON review
- `gh` for IaC and deployment workflow context
- `openssl` for endpoint and certificate validation
- `Argus` for exposure discovery
- `BugTrace-AI` for cloud misconfiguration hypothesis review

## Local Notes
- Treat broad IAM roles, public buckets, and exposed control planes as urgent.
- Prefer provider-native guardrails plus infrastructure-as-code remediation.
- Document blast radius by account, project, region, and identity boundary.
