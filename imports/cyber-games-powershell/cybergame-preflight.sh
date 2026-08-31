#!/usr/bin/env bash

ERRORS=0
WARNINGS=0

pass() {
    echo "[PASS] $1"
}

warn() {
    echo "[WARN] $1"
    WARNINGS=$((WARNINGS + 1))
}

fail() {
    echo "[FAIL] $1"
    ERRORS=$((ERRORS + 1))
}

check_file() {
    if [ -f "$1" ]; then
        pass "Found $1"
    else
        fail "Missing $1"
    fi
}

check_contains() {
    local file="$1"
    local text="$2"
    local label="$3"

    if [ ! -f "$file" ]; then
        fail "Cannot check $label because $file is missing"
        return
    fi

    if grep -q "$text" "$file"; then
        pass "$label"
    else
        fail "$label missing in $file"
    fi
}

echo "========================================"
echo " CYBERSHELL PREFLIGHT CHECK"
echo "========================================"
echo ""

echo "[1] Checking required project files..."
check_file "Start-CyberShell.ps1"
check_file "install.sh"
check_file "README.md"
check_file ".gitignore"
echo ""

echo "[2] Checking required engine files..."
check_file "engine/CyberTheme.ps1"
check_file "engine/ProfileSystem.ps1"
check_file "engine/RankSystem.ps1"
check_file "engine/MissionCatalog.ps1"
check_file "engine/GameSystems.ps1"
check_file "engine/QuestionBank.ps1"
echo ""

echo "[3] Checking required functions..."
check_contains "engine/CyberTheme.ps1" "function Write-CyberHeader" "Cyber header function exists"
check_contains "engine/CyberTheme.ps1" "function Write-BoxLine" "Box line function exists"
check_contains "engine/CyberTheme.ps1" "function Write-BoxText" "Box text function exists"
check_contains "engine/CyberTheme.ps1" "function Write-BoxEnd" "Box end function exists"
check_contains "engine/CyberTheme.ps1" "function Read-Menu" "Read menu function exists"
check_contains "engine/CyberTheme.ps1" "function Pause-Game" "Pause game function exists"

check_contains "engine/ProfileSystem.ps1" "function Get-Profiles" "Get profiles function exists"
check_contains "engine/ProfileSystem.ps1" "function Update-CyberProfile" "Update profile function exists"
check_contains "engine/ProfileSystem.ps1" "function Select-CyberProfile" "Select profile function exists"

check_contains "engine/GameSystems.ps1" "function Test-Answer" "Answer checking function exists"
check_contains "engine/GameSystems.ps1" "function Add-Badge" "Badge function exists"
check_contains "engine/GameSystems.ps1" "function Repair-CyberProfile" "Profile repair function exists"
check_contains "engine/GameSystems.ps1" "function Start-PlacementTest" "Placement test function exists"
check_contains "engine/GameSystems.ps1" "function Start-BossTrial" "Boss trial function exists"
check_contains "engine/GameSystems.ps1" "function Start-SpeedRound" "Speed round function exists"
check_contains "engine/GameSystems.ps1" "function Start-DailyChallenge" "Daily challenge function exists"
check_contains "engine/GameSystems.ps1" "function Show-Leaderboard" "Leaderboard function exists"

check_contains "engine/QuestionBank.ps1" "Global:QuestionBank" "Question bank exists"
check_contains "engine/QuestionBank.ps1" "function Get-RandomQuestions" "Random question selector exists"
echo ""

echo "[4] Checking Start-CyberShell.ps1 imports..."
check_contains "Start-CyberShell.ps1" "CyberTheme.ps1" "Loads CyberTheme"
check_contains "Start-CyberShell.ps1" "RankSystem.ps1" "Loads RankSystem"
check_contains "Start-CyberShell.ps1" "ProfileSystem.ps1" "Loads ProfileSystem"
check_contains "Start-CyberShell.ps1" "MissionCatalog.ps1" "Loads MissionCatalog"
check_contains "Start-CyberShell.ps1" "QuestionBank.ps1" "Loads QuestionBank"
check_contains "Start-CyberShell.ps1" "GameSystems.ps1" "Loads GameSystems"
echo ""

echo "[5] Checking PowerShell parser syntax..."
if command -v pwsh >/dev/null 2>&1; then
    cat > /tmp/cybergame-parse-check.ps1 <<'PSCHECK'
param(
    [string]$TargetFile
)

$tokens = $null
$parseErrors = $null

[System.Management.Automation.Language.Parser]::ParseFile($TargetFile, [ref]$tokens, [ref]$parseErrors) | Out-Null

if ($parseErrors.Count -gt 0) {
    foreach ($e in $parseErrors) {
        Write-Host "[PARSE-ERROR] $TargetFile : $($e.Message)"
    }
    exit 1
}

exit 0
PSCHECK

    for file in Start-CyberShell.ps1 engine/*.ps1; do
        pwsh -NoProfile -ExecutionPolicy Bypass -File /tmp/cybergame-parse-check.ps1 "$file" >/tmp/cybergame-parse.log 2>&1

        if [ $? -eq 0 ]; then
            pass "PowerShell syntax OK: $file"
        else
            fail "PowerShell syntax error: $file"
            cat /tmp/cybergame-parse.log
        fi
    done
else
    fail "PowerShell not installed or pwsh not found"
fi
echo ""

echo "[6] Checking question bank health..."
if command -v pwsh >/dev/null 2>&1 && [ -f "engine/QuestionBank.ps1" ]; then
    pwsh -NoProfile -Command '
        . ./engine/QuestionBank.ps1

        $errors = 0

        if ($null -eq $Global:QuestionBank) {
            Write-Host "[FAIL] QuestionBank is null"
            exit 1
        }

        $count = @($Global:QuestionBank).Count
        Write-Host "[INFO] Question count: $count"

        if ($count -lt 20) {
            Write-Host "[WARN] Question bank has fewer than 20 questions"
        }

        foreach ($q in $Global:QuestionBank) {
            if ([string]::IsNullOrWhiteSpace($q.ID)) {
                Write-Host "[FAIL] Question missing ID"
                $errors++
            }

            if ([string]::IsNullOrWhiteSpace($q.Track)) {
                Write-Host "[FAIL] Question $($q.ID) missing Track"
                $errors++
            }

            if ([string]::IsNullOrWhiteSpace($q.Prompt)) {
                Write-Host "[FAIL] Question $($q.ID) missing Prompt"
                $errors++
            }

            if ($null -eq $q.Answers -or @($q.Answers).Count -eq 0) {
                Write-Host "[FAIL] Question $($q.ID) missing Answers"
                $errors++
            }
        }

        $windows = @($Global:QuestionBank | Where-Object { $_.Track -eq "Windows" }).Count
        $linux = @($Global:QuestionBank | Where-Object { $_.Track -eq "Linux" }).Count

        Write-Host "[INFO] Windows questions: $windows"
        Write-Host "[INFO] Linux questions: $linux"

        if ($windows -lt 10) {
            Write-Host "[FAIL] Not enough Windows questions"
            $errors++
        }

        if ($linux -lt 10) {
            Write-Host "[FAIL] Not enough Linux questions"
            $errors++
        }

        if ($errors -gt 0) {
            exit 1
        }
    ' >/tmp/cybergame-qb.log 2>&1

    if [ $? -eq 0 ]; then
        cat /tmp/cybergame-qb.log
        pass "Question bank health check passed"
    else
        cat /tmp/cybergame-qb.log
        fail "Question bank health check failed"
    fi
fi
echo ""

echo "[7] Checking mission catalog health..."
if command -v pwsh >/dev/null 2>&1 && [ -f "engine/MissionCatalog.ps1" ]; then
    pwsh -NoProfile -Command '
        . ./engine/CyberTheme.ps1
        . ./engine/MissionCatalog.ps1

        $errors = 0

        if ($null -eq $Global:Missions) {
            Write-Host "[FAIL] Missions list is null"
            exit 1
        }

        $count = @($Global:Missions).Count
        Write-Host "[INFO] Mission count: $count"

        foreach ($m in $Global:Missions) {
            if ([string]::IsNullOrWhiteSpace($m.ID)) {
                Write-Host "[FAIL] Mission missing ID"
                $errors++
            }

            if ([string]::IsNullOrWhiteSpace($m.Track)) {
                Write-Host "[FAIL] Mission $($m.ID) missing Track"
                $errors++
            }

            if ([string]::IsNullOrWhiteSpace($m.Prompt)) {
                Write-Host "[FAIL] Mission $($m.ID) missing Prompt"
                $errors++
            }

            if ($null -eq $m.Answers -or @($m.Answers).Count -eq 0) {
                Write-Host "[FAIL] Mission $($m.ID) missing Answers"
                $errors++
            }

            if ($null -eq $m.XP) {
                Write-Host "[FAIL] Mission $($m.ID) missing XP"
                $errors++
            }

            if ($null -eq $m.RequiredXP) {
                Write-Host "[FAIL] Mission $($m.ID) missing RequiredXP"
                $errors++
            }
        }

        if ($errors -gt 0) {
            exit 1
        }
    ' >/tmp/cybergame-missions.log 2>&1

    if [ $? -eq 0 ]; then
        cat /tmp/cybergame-missions.log
        pass "Mission catalog health check passed"
    else
        cat /tmp/cybergame-missions.log
        fail "Mission catalog health check failed"
    fi
fi
echo ""

echo "[8] Checking profile JSON..."
mkdir -p data

if [ ! -f "data/profiles.json" ]; then
    echo "[]" > data/profiles.json
    warn "data/profiles.json was missing, created empty profile file"
fi

python3 - <<'PY' >/tmp/cybergame-json.log 2>&1
import json
from pathlib import Path

file = Path("data/profiles.json")

try:
    json.loads(file.read_text())
    print("[INFO] profiles.json is valid JSON")
except Exception as e:
    print(f"[FAIL] profiles.json invalid JSON: {e}")
    raise SystemExit(1)
PY

if [ $? -eq 0 ]; then
    cat /tmp/cybergame-json.log
    pass "Profile JSON valid"
else
    cat /tmp/cybergame-json.log
    fail "Profile JSON invalid"
fi
echo ""

echo "[9] Smoke testing engine load..."
if command -v pwsh >/dev/null 2>&1; then
    pwsh -NoProfile -Command '
        try {
            . ./engine/CyberTheme.ps1
            . ./engine/RankSystem.ps1
            . ./engine/ProfileSystem.ps1
            . ./engine/MissionCatalog.ps1
            . ./engine/QuestionBank.ps1
            . ./engine/GameSystems.ps1

            Get-Command Write-CyberHeader | Out-Null
            Get-Command Write-BoxLine | Out-Null
            Get-Command Test-Answer | Out-Null
            Get-Command Add-Badge | Out-Null
            Get-Command Start-BossTrial | Out-Null
            Get-Command Get-RandomQuestions | Out-Null

            Write-Host "[INFO] Engine load successful"
        }
        catch {
            Write-Host "[FAIL] Engine load failed: $($_.Exception.Message)"
            exit 1
        }
    ' >/tmp/cybergame-smoke.log 2>&1

    if [ $? -eq 0 ]; then
        cat /tmp/cybergame-smoke.log
        pass "Engine smoke test passed"
    else
        cat /tmp/cybergame-smoke.log
        fail "Engine smoke test failed"
    fi
fi
echo ""

echo "========================================"
echo " PREFLIGHT SUMMARY"
echo "========================================"
echo "Errors:   $ERRORS"
echo "Warnings: $WARNINGS"
echo ""

if [ "$ERRORS" -eq 0 ]; then
    echo "[READY] CyberShell passed preflight."
    echo "Run game with:"
    echo "pwsh -NoProfile -ExecutionPolicy Bypass -File ./Start-CyberShell.ps1"
    exit 0
else
    echo "[BLOCKED] Fix errors before running or pushing."
    exit 1
fi
