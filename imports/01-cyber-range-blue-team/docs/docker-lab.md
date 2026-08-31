# Docker Lab Guide

## Start

```powershell
docker compose -f docker/docker-compose.yml up --build
```

## Stop

```powershell
docker compose -f docker/docker-compose.yml down
```

## Rebuild Cleanly

```powershell
docker compose -f docker/docker-compose.yml down --volumes --remove-orphans
docker compose -f docker/docker-compose.yml build --no-cache
docker compose -f docker/docker-compose.yml up
```

## Services

| Service | Port | Purpose |
|---|---:|---|
| web-service | 8080 | Simulated web logs |
| dashboard | 8088 | Placeholder dashboard |
| log-generator | none | Writes synthetic logs |
| monitor | none | Emits JSON alerts |

## Where Logs Appear

Generated logs appear in:

```text
sample-logs/generated/
```

Static practice logs are stored directly under:

```text
sample-logs/
```

## Common Troubleshooting

### Port Already in Use

Change the port mapping in `docker/docker-compose.yml`.

### Docker Not Running

Start Docker Desktop or the Docker service before running the lab.

### No Logs Generated

Wait 15-30 seconds after startup, then check:

```powershell
Get-ChildItem .\sample-logs\generated\
```
