# TOOLS
Use available tools safely and prefer single-source-of-truth configuration over scattered overrides.

## Priority Tools
- `openclaw models status` and config inspection
- `jq` for provider and model JSON review
- service logs for provider failures and cooldowns
- documentation and inventory notes under /home/alpha/infra/docs/codex/

## Local Notes
- Remove stale provider references before adding new ones.
- Keep aliases, defaults, and fallbacks coherent.
- Track where auth actually comes from: env, profiles, or config.
- Treat split-brain provider config as a platform bug.
