Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$caseId = Read-Host "Enter case ID, example CASE-001"
$date = Get-Date -Format "yyyyMMdd-HHmmss"
$out = "reports/$caseId-$date-report.md"
Copy-Item REPORT_TEMPLATE.md $out
Write-Host "Created report draft: $out" -ForegroundColor Green
