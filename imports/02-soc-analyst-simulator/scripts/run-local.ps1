$ErrorActionPreference = "Stop"

Write-Host "Starting SOC Analyst Simulator locally..." -ForegroundColor Cyan

if (-not (Test-Path "backend")) {
  Write-Error "Run this script from the repository root."
}

Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd backend; python -m venv .venv; .\.venv\Scripts\Activate.ps1; pip install -r requirements.txt; uvicorn app.main:app --reload --host 0.0.0.0 --port 8000"
Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd frontend; npm install; npm run dev"

Write-Host "Backend:  http://localhost:8000/docs" -ForegroundColor Green
Write-Host "Frontend: http://localhost:5173" -ForegroundColor Green
