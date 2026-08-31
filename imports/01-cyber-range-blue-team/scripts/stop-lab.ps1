Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

Write-Host "Stopping 01 Cyber Range Blue Team lab..." -ForegroundColor Cyan
docker compose -f docker/docker-compose.yml down
