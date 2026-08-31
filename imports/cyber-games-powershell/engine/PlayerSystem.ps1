# PlayerSystem.ps1
# Handles player stats, XP, rank, credits, and profile display

$Global:Player = [ordered]@{
    Name              = ""
    Rank              = "Recruit Analyst"
    Level             = 1
    XP                = 0
    Credits           = 0
    Health            = 100
    Reputation        = 0
    MissionsCompleted = @()
    ToolsUnlocked     = @("Basic Terminal")
    Achievements      = @()
}

function New-Player {
    Show-SectionHeader "New Operator Registration"

    $name = Read-Host "Enter your operator name"

    if ([string]::IsNullOrWhiteSpace($name)) {
        $name = "Unknown Operator"
    }

    $Global:Player.Name = $name

    Save-Player

    Show-MessageBox "ORACLE" "Welcome, $name. Your terminal access has been approved." "Green"
    Pause-Game
}

function Show-PlayerProfile {
    Show-SectionHeader "Operator Profile"

    Write-Host "Name:              $($Global:Player.Name)" -ForegroundColor White
    Write-Host "Rank:              $($Global:Player.Rank)" -ForegroundColor White
    Write-Host "Level:             $($Global:Player.Level)" -ForegroundColor White
    Write-Host "XP:                $($Global:Player.XP)" -ForegroundColor White
    Write-Host "Credits:           $($Global:Player.Credits)" -ForegroundColor White
    Write-Host "Health:            $($Global:Player.Health)" -ForegroundColor White
    Write-Host "Reputation:        $($Global:Player.Reputation)" -ForegroundColor White
    Write-Host ""

    Write-Host "Tools Unlocked:" -ForegroundColor Cyan

    foreach ($tool in $Global:Player.ToolsUnlocked) {
        Write-Host " - $tool" -ForegroundColor Gray
    }

    Write-Host ""
    Write-Host "Completed Missions:" -ForegroundColor Cyan

    if ($Global:Player.MissionsCompleted.Count -eq 0) {
        Write-Host " - None yet" -ForegroundColor DarkGray
    }
    else {
        foreach ($mission in $Global:Player.MissionsCompleted) {
            Write-Host " - $mission" -ForegroundColor Gray
        }
    }

    Pause-Game
}

function Add-XP {
    param (
        [int]$Amount
    )

    $Global:Player.XP += $Amount

    Write-Host ""
    Write-Host "+$Amount XP gained" -ForegroundColor Green

    Update-Level
}

function Add-Credits {
    param (
        [int]$Amount
    )

    $Global:Player.Credits += $Amount

    Write-Host "+$Amount credits gained" -ForegroundColor Yellow
}

function Add-Reputation {
    param (
        [int]$Amount
    )

    $Global:Player.Reputation += $Amount

    Write-Host "+$Amount reputation gained" -ForegroundColor Cyan
}

function Update-Level {
    $requiredXP = $Global:Player.Level * 100

    while ($Global:Player.XP -ge $requiredXP) {
        $Global:Player.XP -= $requiredXP
        $Global:Player.Level += 1

        Write-Host ""
        Write-Host "LEVEL UP! You are now Level $($Global:Player.Level)." -ForegroundColor Magenta

        Update-Rank

        $requiredXP = $Global:Player.Level * 100
    }
}

function Update-Rank {
    switch ($Global:Player.Level) {
        { $_ -ge 20 } { $Global:Player.Rank = "Terminal Ghost"; break }
        { $_ -ge 15 } { $Global:Player.Rank = "Incident Commander"; break }
        { $_ -ge 10 } { $Global:Player.Rank = "Exploit Analyst"; break }
        { $_ -ge 7 }  { $Global:Player.Rank = "Threat Hunter"; break }
        { $_ -ge 4 }  { $Global:Player.Rank = "Cyber Defender"; break }
        { $_ -ge 2 }  { $Global:Player.Rank = "Junior Operator"; break }
        default       { $Global:Player.Rank = "Recruit Analyst" }
    }
}