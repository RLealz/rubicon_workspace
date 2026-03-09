# TOOLS
Use available tools safely and prefer detections that answer concrete attack questions.

## Priority Tools
- `jq` for log and JSON event analysis
- `gh` for workflow and code-path context
- `Argus` for exposed surface inventory to align monitoring coverage
- `BugTrace-AI` for behavioral hypothesis generation

## Local Notes
- Prefer behavioral detections over brittle indicators.
- Tune aggressively to reduce alert fatigue.
- Call out blind spots separately from noisy controls.
