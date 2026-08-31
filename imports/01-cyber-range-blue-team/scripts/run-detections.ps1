Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

Write-Host "Running local detection scripts..." -ForegroundColor Cyan
python .\scripts\run_all_detections.py
Write-Host "Detection results saved to reports\local-detection-results.json" -ForegroundColor Green
