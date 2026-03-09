# TOOLS.md - DevSecOps Shared Resources

## CAI (Cybersecurity AI Framework)

**Path:** `/home/alpha/venvs/cai/`
**Activate:** `source /home/alpha/venvs/cai/bin/activate && cai`
**Description:** Multi-agent framework for pipeline security testing, infrastructure auditing, and code analysis.
**Commands:** `/agent list`, `/agent select`, `/parallel add`, `/memory`, `/history`
**Key Modules:** `cai.tools.reconnaissance.nmap`, `cai.tools.misc.code_interpreter`
**Agent Types:** `codeagent` (code analysis), `android_sast_agent` (mobile SAST), `guardrails` (safety gates)

---

## Docker Services

| Service | Port | Purpose |
|---------|------|---------|
| Portainer | 9000 | Container management and monitoring (running) |
| n8n | 5678 | Workflow automation and CI/CD integration (running) |

## System Tools

| Tool | Purpose |
|------|---------|
| `gh` (v2.86.0) | GitHub CLI -- PR reviews, issue tracking, Actions management |
| `docker` | Container builds, image scanning, compose orchestration |
| `go` / `node` / `npm` | Go and JavaScript/TypeScript toolchains |
| `jq` | JSON processing for API and config parsing |
| `openssl` | Certificate management and TLS verification |
| `gemini` | Google Gemini CLI — alternative AI for multi-model code analysis |

## Python Packages (CAI venv)

| Package | Purpose |
|---------|---------|
| `pandas` | Data analysis for metrics and audit logs |
| `boto3` | AWS SDK for cloud infrastructure management |
| `opentelemetry-*` | Distributed tracing and observability |
| `SQLAlchemy` / `pydantic` | Database ORM and config validation |
| `reportlab` | PDF report generation |

---

## Security Apps (`/home/alpha/infra/apps/`)

### Argus -- Infrastructure Scanning
**Path:** `/home/alpha/infra/apps/argus/`
**Description:** Network assessment and service enumeration for attack surface auditing.
**CLI:** `argus`

### BugTrace-AI -- Code Analysis
**Path:** `/home/alpha/infra/apps/BugTrace-AI/`
**Description:** SAST/DAST analysis. Pipeline and Code Security agents use this for vulnerability detection.

### PentestOPS -- Findings Management
**Path:** `/home/alpha/infra/apps/PentestOPS/`
**Description:** Track security findings, remediation status, and compliance. CWE database integration.

### Uptime Kuma -- Availability Monitoring
**Path:** `/home/alpha/infra/monitoring/uptime-kuma/`  |  **Port:** 3001
**Description:** Service uptime monitoring. Observability agent uses this for availability tracking.

---

## MCP Plugins

| Plugin | Purpose |
|--------|---------|
| `context7` | Library documentation lookup (framework and security tool docs) |
| `github` | GitHub API integration — PR reviews, code search, Actions |
| `Notion` | Security documentation and compliance tracking |

---

## DevSecOps Workflow

1. **Scan:** `devsecops-pipeline` secures CI/CD, dependencies, and release gates (BugTrace-AI, n8n automation)
2. **Analyze:** `devsecops-appsec` reviews application code, auth, APIs, and supply-chain risk (SAST, gh CLI)
3. **Harden:** `devsecops-infra` audits environments, runtime exposure, and recovery posture (Argus, Docker, IaC tooling)
4. **Monitor:** `devsecops-observability` tracks health, telemetry quality, and alerting coverage (Uptime Kuma, Portainer, OpenTelemetry)
5. **Report:** All agents feed findings into PentestOPS for lifecycle tracking
