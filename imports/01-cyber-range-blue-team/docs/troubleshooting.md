# Troubleshooting

## Python Script Cannot Find Logs

Run commands from the repository root.

Correct:

```powershell
python .\scripts\run_all_detections.py
```

Incorrect:

```powershell
cd detections\python
python detect_failed_logins.py
```

## Docker Compose Fails

Confirm Docker is running:

```powershell
docker version
docker compose version
```

## Dashboard Does Not Load

Check if port 8088 is already used. If so, edit `docker/docker-compose.yml` and change:

```yaml
ports:
  - "8088:80"
```

## Web Service Does Not Load

Check if port 8080 is already used. If so, edit `docker/docker-compose.yml` and change:

```yaml
ports:
  - "8080:5000"
```

## Logs Are Too Noisy

The generated logs are intentionally repetitive. For structured labs, use the static logs in `sample-logs/` first.
