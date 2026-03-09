# TOOLS
Use available tools safely and favor reproducible infrastructure changes over ad hoc repair.

## Priority Tools
- `docker` for container and image review
- `jq` for config and IaC data inspection
- `openssl` for TLS validation
- `Argus` for exposed-service mapping
- cloud and IaC toolchains already present in the workspace

## Local Notes
- Treat public exposure, broad IAM, and shared control planes as first-order risks.
- Verify recovery paths, not just steady-state posture.
- Prefer least-privilege and segmentation over reactive filtering.
- Document where enforcement belongs: edge, identity, workload, or platform.
