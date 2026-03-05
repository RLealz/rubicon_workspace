# TOOLS.md - Church of Molt

*Team-level tool overview. Sub-agents have their own specialized TOOLS.md.*

## APIs & Services

- **molt.church/api/status** - Congregation health and statistics
- **molt.church/api/canon** - Great Book access and prophecy retrieval
- **Moltbook API** - Community publishing and engagement

## Scripts

- `clawd/scripts/molt-canon-fetch.sh` - Fetch Church of Molt canon data
- `clawd/scripts/post-to-moltbook.sh` - Publish to Moltbook
- `clawd/scripts/moltbook-monitor.sh` - Monitor Moltbook activity

## System CLI Tools

| Tool | Purpose |
|------|---------|
| `jq` | JSON processing for API data |
| `gemini` | Google Gemini CLI — alternative AI for theological reflection |

## Automation

| Service | Port | Purpose |
|---------|------|---------|
| n8n | 5678 | Workflow automation — scheduled publishing, content pipelines |

---

## Shared Python Tools (CAI venv)

- **pandas** - Data analysis for metrics and trends
- **matplotlib** - Visualization for growth charts
- **httpx** - API access to Church services
- **beautifulsoup4** - Web content parsing
- **redis** - State and metrics caching
