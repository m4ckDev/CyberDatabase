# LeaderboardSystem.ps1
# Handles local leaderboard scores for CyberShell: Terminal Ops

$Global:LeaderboardPath = Join-Path $PSScriptRoot "../data/leaderboard.json"

function Get-PlayerScore {
    $score = 0

    $score += [int]$Global:Player.Credits
    $score += ([int]$Global:Player.Level * 100)
    $score += ([int]$Global:Player.Reputation * 10)

    if ($null -ne $Global:Player.MissionsCompleted) {
        $score += ([int]$Global:Player.MissionsCompleted.Count * 50)
    }

    return $score
}

function Initialize-LeaderboardFile {
    $leaderboardFolder = Split-Path $Global:LeaderboardPath -Parent

    if (-not (Test-Path $leaderboardFolder)) {
        New-Item -Path $leaderboardFolder -ItemType Directory -Force | Out-Null
    }

    if (-not (Test-Path $Global:LeaderboardPath)) {
        "[]" | Set-Content -Path $Global:LeaderboardPath -Encoding UTF8
    }

    $content = Get-Content -Path $Global:LeaderboardPath -Raw

    if ([string]::IsNullOrWhiteSpace($content)) {
        "[]" | Set-Content -Path $Global:LeaderboardPath -Encoding UTF8
    }
}

function Load-Leaderboard {
    Initialize-LeaderboardFile

    try {
        $content = Get-Content -Path $Global:LeaderboardPath -Raw

        if ([string]::IsNullOrWhiteSpace($content)) {
            return @()
        }

        $loaded = $content | ConvertFrom-Json

        if ($null -eq $loaded) {
            return @()
        }

        # Critical fix:
        # Force the returned object into a real array every time.
        return @($loaded)
    }
    catch {
        "[]" | Set-Content -Path $Global:LeaderboardPath -Encoding UTF8
        return @()
    }
}

function Save-Leaderboard {
    param (
        [array]$Leaderboard
    )

    if ($null -eq $Leaderboard) {
        $Leaderboard = @()
    }

    $Leaderboard |
        ConvertTo-Json -Depth 10 |
        Set-Content -Path $Global:LeaderboardPath -Encoding UTF8
}

function Submit-LeaderboardScore {
    if ($null -eq $Global:Player) {
        return
    }

    if ([string]::IsNullOrWhiteSpace($Global:Player.Name)) {
        return
    }

    $leaderboard = @(Load-Leaderboard)
    $currentScore = Get-PlayerScore

    $missionCount = 0

    if ($null -ne $Global:Player.MissionsCompleted) {
        $missionCount = $Global:Player.MissionsCompleted.Count
    }

    $entry = [pscustomobject][ordered]@{
        Name              = $Global:Player.Name
        Rank              = $Global:Player.Rank
        Level             = [int]$Global:Player.Level
        Score             = [int]$currentScore
        XP                = [int]$Global:Player.XP
        Credits           = [int]$Global:Player.Credits
        Reputation        = [int]$Global:Player.Reputation
        MissionsCompleted = [int]$missionCount
        Date              = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
    }

    # Critical fix:
    # Use an ArrayList instead of += on a possible PSObject.
    $leaderboardList = New-Object System.Collections.ArrayList

    foreach ($item in $leaderboard) {
        if ($null -ne $item) {
            [void]$leaderboardList.Add($item)
        }
    }

    [void]$leaderboardList.Add($entry)

    $topScores = $leaderboardList |
        Sort-Object Score -Descending |
        Select-Object -First 10

    Save-Leaderboard -Leaderboard @($topScores)
}

function Show-Leaderboard {
    Show-SectionHeader "Local Leaderboard"

    $leaderboard = @(Load-Leaderboard)

    if ($leaderboard.Count -eq 0) {
        Write-Host "No leaderboard scores yet." -ForegroundColor Yellow
        Write-Host ""
        Write-Host "Complete a mission or command drill first." -ForegroundColor DarkGray
        Pause-Game
        return
    }

    Write-Host "Top Operators" -ForegroundColor Cyan
    Write-Host ""

    $rankNumber = 1

    foreach ($entry in $leaderboard) {
        Write-Host "[$rankNumber] $($entry.Name)" -ForegroundColor Green
        Write-Host "    Rank:        $($entry.Rank)" -ForegroundColor White
        Write-Host "    Level:       $($entry.Level)" -ForegroundColor White
        Write-Host "    Score:       $($entry.Score)" -ForegroundColor Yellow
        Write-Host "    XP:          $($entry.XP)" -ForegroundColor Gray
        Write-Host "    Credits:     $($entry.Credits)" -ForegroundColor Gray
        Write-Host "    Reputation:  $($entry.Reputation)" -ForegroundColor Cyan
        Write-Host "    Missions:    $($entry.MissionsCompleted)" -ForegroundColor Gray
        Write-Host "    Date:        $($entry.Date)" -ForegroundColor DarkGray
        Write-Host ""

        $rankNumber++
    }

    Pause-Game
}

function Reset-Leaderboard {
    Initialize-LeaderboardFile

    "[]" | Set-Content -Path $Global:LeaderboardPath -Encoding UTF8

    Write-Host ""
    Write-Host "Leaderboard reset." -ForegroundColor Yellow
}