# 🍓 Raspberry Command Center

Central home for Raspberry Pi code, scripts, automation, services, configs, and operational notes.

## Structure

```text
RaspberryCommandCenter/
├── scripts/
├── python/
├── bash/
├── docker/
├── services/
├── networking/
├── monitoring/
├── backups/
├── security/
├── configs/
├── utilities/
└── docs/
```

## Purpose

Use this folder to keep Raspberry Pi work organized in one place:

- Bash scripts
- Python scripts
- Docker Compose files
- systemd service files
- Network tools and diagnostics
- Monitoring scripts
- Backup and restore scripts
- Security checks
- Configuration templates
- Utility scripts
- Setup notes and documentation

## Rule

Do not commit passwords, API keys, private keys, tokens, or other secrets.

Use `.env.example` files and environment variables for sensitive values.
