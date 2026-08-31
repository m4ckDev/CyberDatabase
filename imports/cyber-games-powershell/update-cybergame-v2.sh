#!/usr/bin/env bash

set -e

echo "===================================="
echo " CYBERGAME V2 PATCH"
echo " Profiles + Difficulty Progression"
echo "===================================="

mkdir -p backups
mkdir -p engine
mkdir -p data

BACKUP_DIR="backups/backup-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$BACKUP_DIR"

echo "[1] Backing up current files..."
cp -r Start-CyberShell.ps1 engine data "$BACKUP_DIR" 2>/dev/null || true

echo "[2] Creating ProfileSystem.ps1..."
cat > engine/ProfileSystem.ps1 <<'PS1'
$Global:ProfileFile = Join-Path $PSScriptRoot "../data/profiles.json"

function Initialize-ProfileStore {
    $dataDir = Split-Path $Global:ProfileFile
    if (!(Test-Path $dataDir)) {
        New-Item -ItemType Directory -Path $dataDir -Force | Out-Null
    }

    if (!(Test-Path $Global:ProfileFile)) {
        @() | ConvertTo-Json | Set-Content $Global:ProfileFile
    }
}

function Get-Profiles {
    Initialize-ProfileStore

    $raw = Get-Content $Global:ProfileFile -Raw

    if ([string]::IsNullOrWhiteSpace($raw)) {
        return @()
    }

    $profiles = $raw | ConvertFrom-Json

    if ($null -eq $profiles) {
        return @()
    }

    if ($profiles -isnot [System.Array]) {
        return @($profiles)
    }

    return $profiles
}

function Save-Profiles {
    param(
        [array]$Profiles
    )

    $Profiles | ConvertTo-Json -Depth 10 | Set-Content $Global:ProfileFile
}

function New-CyberProfile {
    Clear-Host
    Write-Host "====================================" -ForegroundColor Cyan
    Write-Host " CREATE ANONYMOUS OPERATOR PROFILE" -ForegroundColor Cyan
    Write-Host "====================================" -ForegroundColor Cyan
    Write-Host ""

    do {
        $name = Read-Host "Enter anonymous operator name"
    } while ([string]::IsNullOrWhiteSpace($name))

    $profiles = @(Get-Profiles)

    $existing = $profiles | Where-Object { $_.Name -eq $name }

    if ($existing) {
        Write-Host ""
        Write-Host "That operator name already exists. Loading existing profile." -ForegroundColor Yellow
        Start-Sleep -Seconds 1
        return $existing
    }

    $profile = [PSCustomObject]@{
        Name = $name
        Created = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
        LastLogin = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
        WindowsXP = 0
        LinuxXP = 0
        TotalXP = 0
        CompletedMissions = @()
    }

    $profiles += $profile
    Save-Profiles -Profiles $profiles

    Write-Host ""
    Write-Host "Profile created for: $name" -ForegroundColor Green
    Start-Sleep -Seconds 1

    return $profile
}

function Select-CyberProfile {
    Clear-Host
    Initialize-ProfileStore

    $profiles = @(Get-Profiles)

    Write-Host "====================================" -ForegroundColor Cyan
    Write-Host " CYBERGAME PROFILE LOGIN" -ForegroundColor Cyan
    Write-Host "====================================" -ForegroundColor Cyan
    Write-Host ""

    if ($profiles.Count -eq 0) {
        Write-Host "No profiles found. Creating your first operator profile." -ForegroundColor Yellow
        Start-Sleep -Seconds 1
        return New-CyberProfile
    }

    for ($i = 0; $i -lt $profiles.Count; $i++) {
        $num = $i + 1
        Write-Host "[$num] $($profiles[$i].Name) | Total XP: $($profiles[$i].TotalXP)"
    }

    Write-Host ""
    Write-Host "[N] Create new profile"
    Write-Host ""

    $choice = Read-Host "Select profile"

    if ($choice -match '^[Nn]$') {
        return New-CyberProfile
    }

    if ($choice -match '^\d+$') {
        $index = [int]$choice - 1

        if ($index -ge 0 -and $index -lt $profiles.Count) {
            $profile = $profiles[$index]
            $profile.LastLogin = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
            Update-CyberProfile -Profile $profile
            return $profile
        }
    }

    Write-Host "Invalid selection. Loading first profile." -ForegroundColor Yellow
    Start-Sleep -Seconds 1
    return $profiles[0]
}

function Update-CyberProfile {
    param(
        [object]$Profile
    )

    $profiles = @(Get-Profiles)

    for ($i = 0; $i -lt $profiles.Count; $i++) {
        if ($profiles[$i].Name -eq $Profile.Name) {
            $profiles[$i] = $Profile
        }
    }

    Save-Profiles -Profiles $profiles
}
PS1

echo "[3] Creating RankSystem.ps1..."
cat > engine/RankSystem.ps1 <<'PS1'
function Get-WindowsRank {
    param(
        [int]$XP
    )

    if ($XP -lt 50) { return "Padawan" }
    elseif ($XP -lt 150) { return "Jedi Initiate" }
    elseif ($XP -lt 300) { return "Jedi Knight" }
    elseif ($XP -lt 500) { return "Jedi Sentinel" }
    else { return "Jedi Master" }
}

function Get-LinuxRank {
    param(
        [int]$XP
    )

    if ($XP -lt 50) { return "Dark Side Acolyte" }
    elseif ($XP -lt 150) { return "Sith Apprentice" }
    elseif ($XP -lt 300) { return "Shadow Operator" }
    elseif ($XP -lt 500) { return "Imperial Inquisitor" }
    else { return "Sith Lord" }
}

function Show-OperatorStatus {
    param(
        [object]$Profile
    )

    $windowsRank = Get-WindowsRank -XP $Profile.WindowsXP
    $linuxRank = Get-LinuxRank -XP $Profile.LinuxXP

    Write-Host "====================================" -ForegroundColor DarkCyan
    Write-Host " OPERATOR: $($Profile.Name)" -ForegroundColor Cyan
    Write-Host "====================================" -ForegroundColor DarkCyan
    Write-Host "Windows Path : $windowsRank | XP: $($Profile.WindowsXP)"
    Write-Host "Linux Path   : $linuxRank | XP: $($Profile.LinuxXP)"
    Write-Host "Total XP     : $($Profile.TotalXP)"
    Write-Host "Last Login   : $($Profile.LastLogin)"
    Write-Host "====================================" -ForegroundColor DarkCyan
}
PS1

echo "[4] Creating MissionCatalog.ps1..."
cat > engine/MissionCatalog.ps1 <<'PS1'
$Global:Missions = @(
    [PSCustomObject]@{
        ID = "WIN-001"
        Track = "Windows"
        Title = "System Recon Basics"
        Difficulty = "Padawan"
        XP = 25
        Lesson = "Use PowerShell to identify the current user, hostname, and PowerShell version."
        Task = "Run: whoami, hostname, and `$PSVersionTable"
    },
    [PSCustomObject]@{
        ID = "WIN-002"
        Track = "Windows"
        Title = "Process Awareness"
        Difficulty = "Jedi Initiate"
        XP = 40
        Lesson = "Processes show what is running on a machine. Defenders and admins use this constantly."
        Task = "Run: Get-Process | Select-Object -First 10"
    },
    [PSCustomObject]@{
        ID = "WIN-003"
        Track = "Windows"
        Title = "Network Visibility"
        Difficulty = "Jedi Knight"
        XP = 60
        Lesson = "Network commands help you identify connections, IPs, and listening services."
        Task = "Run: Get-NetIPAddress or netstat -ano"
    },
    [PSCustomObject]@{
        ID = "LIN-001"
        Track = "Linux"
        Title = "Terminal Orientation"
        Difficulty = "Dark Side Acolyte"
        XP = 25
        Lesson = "Linux starts with knowing where you are, who you are, and what files exist."
        Task = "Run: pwd, whoami, and ls"
    },
    [PSCustomObject]@{
        ID = "LIN-002"
        Track = "Linux"
        Title = "File System Movement"
        Difficulty = "Sith Apprentice"
        XP = 40
        Lesson = "Linux operators must move through folders fast and understand paths."
        Task = "Practice: cd, ls -la, mkdir, touch, and cat"
    },
    [PSCustomObject]@{
        ID = "LIN-003"
        Track = "Linux"
        Title = "Process and Service Awareness"
        Difficulty = "Shadow Operator"
        XP = 60
        Lesson = "Linux process visibility is a core admin and cybersecurity skill."
        Task = "Run: ps aux, top, systemctl status"
    }
)

function Show-Missions {
    param(
        [string]$Track
    )

    Clear-Host

    Write-Host "====================================" -ForegroundColor Cyan
    Write-Host " $Track TRAINING MISSIONS" -ForegroundColor Cyan
    Write-Host "====================================" -ForegroundColor Cyan
    Write-Host ""

    $missions = $Global:Missions | Where-Object { $_.Track -eq $Track }

    foreach ($mission in $missions) {
        Write-Host "[$($mission.ID)] $($mission.Title)" -ForegroundColor Yellow
        Write-Host "Difficulty: $($mission.Difficulty)"
        Write-Host "XP Reward : $($mission.XP)"
        Write-Host ""
    }

    Write-Host "Type the mission ID to start, or B to go back."
}

function Start-Mission {
    param(
        [object]$Profile,
        [string]$MissionID
    )

    $mission = $Global:Missions | Where-Object { $_.ID -eq $MissionID }

    if (!$mission) {
        Write-Host "Mission not found." -ForegroundColor Red
        Start-Sleep -Seconds 1
        return $Profile
    }

    Clear-Host

    Write-Host "====================================" -ForegroundColor Cyan
    Write-Host "$($mission.ID): $($mission.Title)" -ForegroundColor Cyan
    Write-Host "====================================" -ForegroundColor Cyan
    Write-Host "Track      : $($mission.Track)"
    Write-Host "Difficulty : $($mission.Difficulty)"
    Write-Host "XP Reward  : $($mission.XP)"
    Write-Host ""
    Write-Host "LESSON:" -ForegroundColor Green
    Write-Host $mission.Lesson
    Write-Host ""
    Write-Host "TASK:" -ForegroundColor Yellow
    Write-Host $mission.Task
    Write-Host ""

    $done = Read-Host "Mark this mission complete? Y/N"

    if ($done -match '^[Yy]$') {
        if ($Profile.CompletedMissions -notcontains $mission.ID) {
            $Profile.CompletedMissions += $mission.ID

            if ($mission.Track -eq "Windows") {
                $Profile.WindowsXP += $mission.XP
            }

            if ($mission.Track -eq "Linux") {
                $Profile.LinuxXP += $mission.XP
            }

            $Profile.TotalXP += $mission.XP

            Write-Host ""
            Write-Host "Mission complete. XP awarded: $($mission.XP)" -ForegroundColor Green
        }
        else {
            Write-Host ""
            Write-Host "Mission already completed. No duplicate XP awarded." -ForegroundColor Yellow
        }
    }

    Start-Sleep -Seconds 2
    return $Profile
}
PS1

echo "[5] Rebuilding Start-CyberShell.ps1..."
cat > Start-CyberShell.ps1 <<'PS1'
$ErrorActionPreference = "Stop"

. "$PSScriptRoot/engine/ProfileSystem.ps1"
. "$PSScriptRoot/engine/RankSystem.ps1"
. "$PSScriptRoot/engine/MissionCatalog.ps1"

function Show-MainMenu {
    param(
        [object]$Profile
    )

    Clear-Host

    Write-Host "====================================" -ForegroundColor Cyan
    Write-Host " CYBERSHELL TERMINAL OPS" -ForegroundColor Cyan
    Write-Host "====================================" -ForegroundColor Cyan
    Write-Host ""

    Show-OperatorStatus -Profile $Profile

    Write-Host ""
    Write-Host "[1] Windows Path, Light Side Training"
    Write-Host "[2] Linux Path, Dark Side Training"
    Write-Host "[3] View Profile"
    Write-Host "[4] Switch Profile"
    Write-Host "[5] Exit"
    Write-Host ""
}

function Start-TrainingTrack {
    param(
        [object]$Profile,
        [string]$Track
    )

    while ($true) {
        Show-Missions -Track $Track

        $choice = Read-Host "Selection"

        if ($choice -match '^[Bb]$') {
            return $Profile
        }

        $Profile = Start-Mission -Profile $Profile -MissionID $choice.ToUpper()
        Update-CyberProfile -Profile $Profile
    }
}

$CurrentProfile = Select-CyberProfile

while ($true) {
    Show-MainMenu -Profile $CurrentProfile

    $menuChoice = Read-Host "Choose"

    switch ($menuChoice) {
        "1" {
            $CurrentProfile = Start-TrainingTrack -Profile $CurrentProfile -Track "Windows"
        }
        "2" {
            $CurrentProfile = Start-TrainingTrack -Profile $CurrentProfile -Track "Linux"
        }
        "3" {
            Clear-Host
            Show-OperatorStatus -Profile $CurrentProfile
            Write-Host ""
            Write-Host "Completed Missions:"
            if ($CurrentProfile.CompletedMissions.Count -eq 0) {
                Write-Host "None yet."
            }
            else {
                $CurrentProfile.CompletedMissions | ForEach-Object {
                    Write-Host "- $_"
                }
            }
            Write-Host ""
            Read-Host "Press ENTER to continue"
        }
        "4" {
            $CurrentProfile = Select-CyberProfile
        }
        "5" {
            Update-CyberProfile -Profile $CurrentProfile
            Clear-Host
            Write-Host "Operator progress saved." -ForegroundColor Green
            Write-Host "Exiting CyberShell Terminal Ops."
            break
        }
        default {
            Write-Host "Invalid selection." -ForegroundColor Red
            Start-Sleep -Seconds 1
        }
    }
}
PS1

echo "[6] Patch complete."
echo ""
echo "Run the game with:"
echo "cybergame"
