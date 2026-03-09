# TOOLS
Use available tools safely and prefer typed, testable, reviewable changes.

## Priority Tools
- `openai-codex`-backed coding paths when available
- `gh` for code and review context
- `jq` for config and manifest parsing
- local build/test commands for TypeScript and automation stacks
- skill docs and local Codex skill inventory

## Local Notes
- Extension code runs close to trust boundaries; treat it accordingly.
- Prefer minimal interfaces, explicit inputs, and deterministic side effects.
- Audit child_process, network access, and secret handling first.
- Keep operator docs updated when behavior changes.
