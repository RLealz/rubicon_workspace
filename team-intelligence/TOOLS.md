# TOOLS.md - TEAM-INTELLIGENCE Shared Resources

## CAI (Cybersecurity AI Framework)

**Path:** `/home/alpha/venvs/cai/`
**Activate:** `source /home/alpha/venvs/cai/bin/activate && cai`
**Description:** Parallel agent execution for coordinated OSINT, CVE research, and threat analysis. Run multiple collection agents simultaneously.
**Commands:** `/agent list`, `/agent select`, `/parallel add`, `/memory`, `/history`
**Key Modules:** `cai.tools.reconnaissance.shodan`, `cai.tools.reconnaissance.nmap`, `cai.tools.web.google_search`
**Agent Types:** `bug_bounter` (OSINT recon), `reporter` (intelligence products), `memory` (knowledge retention)

---

## Docker Tools

| Tool | Image | Purpose |
|------|-------|---------|
| Nmap | `instrumentisto/nmap` | Network discovery, port scanning, service enumeration |
| Subfinder | `projectdiscovery/subfinder` | Passive subdomain enumeration |
| Nuclei | `projectdiscovery/nuclei` | Template-based vulnerability scanning |

## Python Packages (CAI venv)

| Package | Purpose |
|---------|---------|
| `shodan` | Shodan API -- internet-wide device search |
| `python-nmap` | Programmatic Nmap integration |
| `theHarvester` | Email, subdomain, IP harvesting from public sources |
| `httpx` | Async HTTP client for web probing |
| `networkx` | Threat actor relationship graphing and link analysis |
| `pandas` / `matplotlib` | Data analysis and visualization |
| `beautifulsoup4` | Web scraping and HTML parsing |
| `tldextract` / `dnspython` | Domain parsing and DNS resolution |
| `reportlab` | PDF report generation |

---

## Security Apps (`/home/alpha/infra/apps/`)

### Argus -- Reconnaissance Dashboard
**Path:** `/home/alpha/infra/apps/argus/`
**Description:** Network assessment, web fingerprinting, service enumeration. Primary recon interface for all sub-agents.
**CLI:** `argus`

### BugTrace-AI -- Vulnerability Tracking
**Path:** `/home/alpha/infra/apps/BugTrace-AI/`
**Description:** SAST/DAST analysis and vuln research. CVE agent uses this for hypothesis generation and validation.

### PentestOPS -- Intelligence Reporting
**Path:** `/home/alpha/infra/apps/PentestOPS/`
**Description:** Track findings (CWE), assets, projects. Reporting agent uses this for intelligence product management.

---

## System CLI Tools

| Tool | Purpose |
|------|---------|
| `jq` | JSON processing for API responses and config parsing |
| `gemini` | Google Gemini CLI — alternative AI for multi-model analysis |

## MCP Plugins

| Plugin | Purpose |
|--------|---------|
| `context7` | Library documentation lookup (up-to-date docs for any library) |
| `Notion` | Intelligence product documentation and knowledge management |

## Automation

| Service | Port | Purpose |
|---------|------|---------|
| n8n | 5678 | Workflow automation — scheduled collection, alerting, report delivery |

---

## Intelligence Workflow

1. **Collect:** OSINT agent gathers raw data (Shodan, theHarvester, Subfinder)
2. **Analyze:** CVE agent identifies vulnerabilities (BugTrace-AI, Nuclei, Nmap)
3. **Attribute:** Threat Actor agent maps relationships (NetworkX, web scraping)
4. **Report:** Reporting agent synthesizes products (PentestOPS, reportlab)
5. **Verify:** Multi-source confirmation before any attribution claim
