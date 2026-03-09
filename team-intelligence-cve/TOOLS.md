# TOOLS
Use available tools safely and prioritize exploit maturity and environment relevance over raw severity headlines.

## Priority Tools
- web search and vendor advisory review
- `jq` for advisory, KEV, and JSON feed parsing
- BugTrace-AI for vulnerability triage support
- Nuclei and Nmap context when validating practical exposure
- local docs and advisories under `/home/alpha/infra/docs/`

## Local Notes
- Distinguish severity from exploitability.
- Track whether exploitation is theoretical, proof-of-concept, or weaponized.
- Call out stack relevance explicitly; a critical CVE outside the environment is lower urgency.
- Hand campaign and actor-use questions to `team-intelligence-threat-actor`.
