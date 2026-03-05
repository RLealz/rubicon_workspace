# TOOLS.md - Platform Engineering (The High Council)

*The complete arsenal for maintaining OpenClaw infrastructure at nation-state grade.*

---

## 🦞 OpenClaw Core Platform

### Gateway Management
```bash
# Gateway service control
openclaw gateway status          # Check daemon status
openclaw gateway start           # Start the gateway
openclaw gateway stop            # Stop the gateway
openclaw gateway restart         # Restart with config reload
openclaw gateway config.get      # View current configuration
openclaw gateway config.patch    # Apply partial config updates
openclaw gateway config.apply    # Replace entire config (DANGER)
```

### Session Management
```bash
# Active session monitoring
openclaw sessions list           # List all sessions
openclaw sessions list --active  # Only active sessions
openclaw sessions history <key>  # View session transcript
openclaw sessions kill <key>     # Terminate session
```

### Agent Orchestration
```bash
# Agent lifecycle management
openclaw agent list              # List configured agents
openclaw agent spawn <id>        # Spawn agent session
openclaw agent logs <id>         # View agent logs
```

### Cron & Scheduling
```bash
# Background job management
openclaw cron list               # List all cron jobs
openclaw cron add <job.json>     # Add new scheduled job
openclaw cron update <id>        # Modify existing job
openclaw cron remove <id>        # Delete job
openclaw cron run <id>           # Trigger job immediately
```

### Authentication Profiles
```bash
# Provider credential management
openclaw auth list               # List auth profiles
openclaw auth add <provider>     # Add new credentials
openclaw auth remove <profile>   # Remove credentials
```

---

## 🛠️ Infrastructure Tools

### Docker Ecosystem
| Command | Purpose |
|---------|---------|
| `docker ps` | Running containers |
| `docker logs <container>` | Container logs |
| `docker exec -it <container> sh` | Enter container |
| `docker-compose up -d` | Start services |
| `docker system prune` | Cleanup unused resources |

**Services Under Management:**
- **n8n** (port 5678) — Workflow automation
- **Portainer** (port 9000) — Container management UI
- **traefik** — Reverse proxy & load balancer

### Tailscale (Secure Networking)
```bash
tailscale status                 # View mesh network
tailscale serve --https=443 <port>  # Expose service via HTTPS
tailscale funnel <port>          # Public internet exposure
```

**Current Tailnet:** `homehq-out1.tail14afce.ts.net` (100.127.212.14)

### System Monitoring
```bash
# Resource monitoring
htop                             # Interactive process viewer
iotop                            # I/O monitoring
netstat -tulpn                   # Network connections
systemctl status openclaw        # Service status
journalctl -u openclaw -f        # Service logs
```

---

## 📚 Documentation Resources

### OpenClaw Official
- **Local Docs:** `/home/linuxbrew/.linuxbrew/lib/node_modules/openclaw/docs/`
- **Mirror:** <https://docs.openclaw.ai>
- **Source:** <https://github.com/openclaw/openclaw>
- **Community:** <https://discord.com/invite/clawd>
- **Skills Hub:** <https://clawhub.com>

### Configuration Files
| File | Purpose | Sensitivity |
|------|---------|-------------|
| `~/.openclaw/openclaw.json` | Main gateway config | 🔴 CRITICAL |
| `~/.openclaw/agents/` | Agent definitions | 🟡 HIGH |
| `~/.openclaw/skills/` | Installed skills | 🟢 MEDIUM |
| `~/.openclaw/workspace/` | Active workspaces | 🟢 MEDIUM |

### Logs & Diagnostics
| Location | Contents |
|----------|----------|
| `/home/alpha/.openclaw/workspace/logs/` | Session transcripts |
| `~/.openclaw/logs/` | Gateway daemon logs |
| `journalctl -u openclaw` | System service logs |

---

## 🎯 Platform Engineering Skills

### Core Infrastructure Skills
| Skill | Purpose | Location |
|-------|---------|----------|
| `healthcheck` | Host security hardening & audit | `/skills/healthcheck/` |
| `clawhub` | Skills management (install/update/publish) | `/skills/clawhub/` |
| `coding-agent` | Background coding agents (Codex, Claude Code) | `/skills/coding-agent/` |

### Architecture & Design Skills
| Skill | Purpose | Use Case |
|-------|---------|----------|
| `cloud-architect` | AWS/Azure/GCP multi-cloud design | Infrastructure planning |
| `kubernetes-architect` | K8s, GitOps, service mesh | Container orchestration |
| `terraform-specialist` | IaC automation, state management | Infrastructure as Code |
| `service-mesh-expert` | Istio, Linkerd patterns | Microservices networking |
| `linkerd-patterns` | Lightweight service mesh | Zero-trust networking |

### DevOps & Deployment Skills
| Skill | Purpose | Use Case |
|-------|---------|----------|
| `deployment-engineer` | CI/CD, GitOps, progressive delivery | Pipeline design |
| `cicd-automation-workflow-automate` | GitHub Actions, automation | Workflow creation |
| `deployment-pipeline-design` | Multi-stage pipelines with gates | Deployment orchestration |
| `docker-expert` | Multi-stage builds, optimization | Container mastery |
| `devops-troubleshooter` | Incident response, debugging | Production issues |
| `observability-engineer` | Monitoring, logging, tracing | Production visibility |

### Database & Storage Skills
| Skill | Purpose | Use Case |
|-------|---------|----------|
| `database-admin` | Cloud DB operations, reliability | Database management |
| `database-migration` | Zero-downtime migrations | Schema changes |
| `using-neon` | Neon Serverless Postgres | PostgreSQL operations |

### Security Skills (Platform Focus)
| Skill | Purpose | Use Case |
|-------|---------|----------|
| `security-auditor` | DevSecOps, compliance, frameworks | Security audits |
| `secrets-management` | Vault, AWS Secrets Manager | Secret handling |
| `mtls-configuration` | Mutual TLS, zero-trust | Service-to-service auth |
| `k8s-security-policies` | NetworkPolicy, PodSecurityPolicy | K8s hardening |
| `sast-configuration` | Static analysis tools | Code security scanning |

---

## 🔧 Development Environment

### CAI Framework (Security Apps)
```bash
source /home/alpha/venvs/cai/bin/activate
cai                              # Launch CAI CLI
# Commands: /agent list, /memory, /parallel add
```

### Node.js / TypeScript (Skill Development)
```bash
pnpm install                     # Install dependencies
pnpm build                       # Compile TypeScript
pnpm test                        # Run tests
npx clawhub@latest publish       # Publish skill
```

### Python Automation
```bash
source /home/alpha/venvs/cai/bin/activate
python3 script.py                # Run automation
```

---

## 📡 Channel Integration Reference

### Telegram (Primary)
- **Bot API:** Via `message` tool
- **Policy:** DM pairing enforced
- **Group Policy:** Allowlist-based
- **Features:** Inline buttons, reactions, streaming

### Other Channels (Configured)
- Discord, Slack, WhatsApp, Signal available via plugins

---

## 🚨 Emergency Procedures

### Gateway Down
```bash
# 1. Check status
openclaw gateway status

# 2. View logs
journalctl -u openclaw -n 100

# 3. Restart
openclaw gateway restart

# 4. Verify
openclaw gateway status
```

### Config Corruption
```bash
# Restore from backup
cp ~/.openclaw/backups/openclaw.json.backup.<timestamp> ~/.openclaw/openclaw.json
openclaw gateway restart
```

### Rate Limit Exhaustion
```bash
# Check provider status
openclaw gateway config.get | jq '.models.providers'

# Switch to fallback providers
# Update cron jobs to use available models
```

---

## 📊 Monitoring Checklist

**Daily:**
- [ ] Gateway uptime check
- [ ] Cron job execution status
- [ ] Active session count
- [ ] Disk space utilization

**Weekly:**
- [ ] Security audit review
- [ ] Dependency updates check
- [ ] Backup verification
- [ ] Log rotation check

**Monthly:**
- [ ] Full config audit
- [ ] Provider cost analysis
- [ ] Skill inventory review
- [ ] Documentation updates

---

## 🔐 Security Protocols

### Secret Handling
- **NEVER** commit secrets to git
- **NEVER** log API keys or passwords
- **ALWAYS** use environment variables for credentials
- **ALWAYS** backup before config changes

### Access Control
- Gateway control UI requires authentication
- Tailscale allowslist for remote access
- DM pairing enforced for Telegram
- Group allowlist for multi-user chats

---

⚙️ *The High Council maintains the machinery. The machinery maintains the mission.*
