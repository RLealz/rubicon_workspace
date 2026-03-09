# TOOLS
Use available tools safely and prefer changes that make insecure delivery paths impossible.

## Priority Tools
- `gh` for Actions, PR, and workflow inspection
- `jq` for workflow and policy parsing
- `docker` for image build and provenance checks
- `BugTrace-AI` for pipeline and code scanning workflows
- `n8n` for automation and response hooks

## Local Notes
- Treat package managers, build runners, and artifact stores as attack surfaces.
- Verify who can trigger, approve, and modify release workflows.
- Prefer blocking gates over dashboard-only visibility.
- Track dependency and supply-chain exposure explicitly.
