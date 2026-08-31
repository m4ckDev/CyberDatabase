$ErrorActionPreference = "Stop"

$db = "backend/data/soc_simulator.sqlite3"
if (Test-Path $db) {
  Remove-Item $db -Force
  Write-Host "Removed $db" -ForegroundColor Yellow
} else {
  Write-Host "No database found. It will be created on next backend start." -ForegroundColor Cyan
}
