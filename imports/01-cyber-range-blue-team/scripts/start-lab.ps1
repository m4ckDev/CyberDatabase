Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

Write-Host "Starting 01 Cyber Range Blue Team lab..." -ForegroundColor Cyan
docker compose -f docker/docker-compose.yml up --build
