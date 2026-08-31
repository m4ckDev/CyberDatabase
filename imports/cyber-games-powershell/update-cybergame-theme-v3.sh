#!/usr/bin/env bash

set -e

echo "===================================="
echo " CYBERGAME V3 THEME PATCH"
echo " Jedi + Dark Side Visual Upgrade"
echo "===================================="

mkdir -p backups
mkdir -p engine
mkdir -p data

BACKUP_DIR="backups/theme-backup-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$BACKUP_DIR"

echo "[1] Backing up current files..."
cp -r Start-CyberShell.ps1 engine data "$BACKUP_DIR" 2>/dev/null || true

echo "[2] Creating CyberTheme.ps1..."
cat > engine/CyberTheme.ps1 <<'PS1'
function Write-CyberLine {
    param(
        [string]$Color = "Cyan"
    )

    Write-Host "====================================================================" -ForegroundColor $Color
}

function Write-CyberHeader {
    param(
        [string]$Title,
        [string]$Subtitle = "",
        [string]$Theme = "Neutral"
    )

    $mainColor = "Cyan"
    $accentColor = "DarkCyan"

    if ($Theme -eq "Jedi") {
        $mainColor = "Cyan"
        $accentColor = "Green"
    }

    if ($Theme -eq "Dark") {
        $mainColor = "Red"
        $accentColor = "DarkRed"
    }

    Clear-Host
    Write-Host ""
    Write-CyberLine -Color $accentColor
    Write-Host "   ██████╗██╗   ██╗██████╗ ███████╗██████╗ ███████╗██╗  ██╗███████╗██╗     ██╗     " -ForegroundColor $mainColor
    Write-Host "  ██╔════╝╚██╗ ██╔╝██╔══██╗██╔════╝██╔══██╗██╔════╝██║  ██║██╔════╝██║     ██║     " -ForegroundColor $mainColor
    Write-Host "  ██║      ╚████╔╝ ██████╔╝█████╗  ██████╔╝███████╗███████║█████╗  ██║     ██║     " -ForegroundColor $mainColor
    Write-Host "  ██║       ╚██╔╝  ██╔══██╗██╔══╝  ██╔══██╗╚════██║██╔══██║██╔══╝  ██║     ██║     " -ForegroundColor $mainColor
    Write-Host "  ╚██████╗   ██║   ██████╔╝███████╗██║  ██║███████║██║  ██║███████╗███████╗███████╗" -ForegroundColor $mainColor
    Write-Host "   ╚═════╝   ╚═╝   ╚═════╝ ╚══════╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚══════╝╚══════╝╚══════╝" -ForegroundColor $mainColor
    Write-CyberLine -Color $accentColor
    Write-Host "   $Title" -ForegroundColor $mainColor

    if ($Subtitle -ne "") {
        Write-Host "   $Subtitle" -ForegroundColor $accentColor
    }

    Write-CyberLine -Color $accentColor
    Write-Host ""
}

function Write-PathHeader {
    param(
        [string]$Track
    )

    if ($Track -eq "Windows") {
        Write-CyberHeader -Title "JEDI SYSTEMS TRAINING PATH" -Subtitle "Windows command mastery, admin control, blue-team discipline" -Theme "Jedi"
        Write-Host "   THE LIGHT SIDE PATH" -ForegroundColor Green
        Write-Host "   Discipline. Visibility. Control. Precision." -ForegroundColor Cyan
        Write-Host ""
    }
    elseif ($Track -eq "Linux") {
        Write-CyberHeader -Title "DARK SIDE TERMINAL TRAINING PATH" -Subtitle "Linux command power, shell control, operator dominance" -Theme "Dark"
        Write-Host "   THE DARK SIDE PATH" -ForegroundColor Red
        Write-Host "   Power. Persistence. Enumeration. Control." -ForegroundColor DarkRed
        Write-Host ""
    }
    else {
        Write-CyberHeader -Title "CYBERSHELL TERMINAL OPS" -Subtitle "Choose your operator path" -Theme "Neutral"
    }
}

function Write-MenuOption {
    param(
        [string]$Key,
        [string]$Text,
        [string]$Color = "White"
    )

    Write-Host "   [$Key] " -NoNewline -ForegroundColor DarkGray
    Write-Host $Text -ForegroundColor $Color
}

function Write-ThemeText {
    param(
        [string]$Text,
        [string]$Track
    )

    if ($Track -eq "Windows") {
        Write-Host $Text -ForegroundColor Cyan
    }
    elseif ($Track -eq "Linux") {
        Write-Host $Text -ForegroundColor Red
    }
    else {
        Write-Host $Text -ForegroundColor White
    }
}
PS1

echo "[3] Rebuilding MissionCatalog.ps1 with themed mission screens..."
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
        ID = "WIN-004"
        Track = "Windows"
        Title = "Service Control"
        Difficulty = "Jedi Sentinel"
        XP = 85
        Lesson = "Services are background programs. Knowing how to inspect them is core Windows administration."
        Task = "Run: Get-Service | Sort-Object Status | Select-Object -First 15"
    },
    [PSCustomObject]@{
        ID = "WIN-005"
        Track = "Windows"
        Title = "Event Log Awareness"
        Difficulty = "Jedi Master"
        XP = 120
        Lesson = "Event logs are where Windows leaves clues. Admins and defenders live here."
        Task = "Run: Get-EventLog -LogName System -Newest 10"
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
    },
    [PSCustomObject]@{
        ID = "LIN-004"
        Track = "Linux"
        Title = "Permission Control"
        Difficulty = "Imperial Inquisitor"
        XP = 85
        Lesson = "Permissions decide who can read, write, and execute files. This is Linux power control."
        Task = "Practice: ls -l, chmod, chown, and groups"
    },
    [PSCustomObject]@{
        ID = "LIN-005"
        Track = "Linux"
        Title = "Network Recon Basics"
        Difficulty = "Sith Lord"
        XP = 120
        Lesson = "Linux networking commands help you understand IPs, routes, DNS, and open connections."
        Task = "Run: ip a, ip route, ss -tulnp, and dig example.com"
    }
)

function Show-Missions {
    param(
        [string]$Track
    )

    Write-PathHeader -Track $Track

    $missions = $Global:Missions | Where-Object { $_.Track -eq $Track }

    foreach ($mission in $missions) {
        if ($Track -eq "Windows") {
            Write-Host "   [$($mission.ID)] $($mission.Title)" -ForegroundColor Cyan
            Write-Host "      Difficulty : $($mission.Difficulty)" -ForegroundColor Green
            Write-Host "      XP Reward  : $($mission.XP)" -ForegroundColor White
            Write-Host ""
        }
        elseif ($Track -eq "Linux") {
            Write-Host "   [$($mission.ID)] $($mission.Title)" -ForegroundColor Red
            Write-Host "      Difficulty : $($mission.Difficulty)" -ForegroundColor DarkRed
            Write-Host "      XP Reward  : $($mission.XP)" -ForegroundColor White
            Write-Host ""
        }
    }

    Write-Host ""
    Write-Host "   Type the mission ID to start, or B to go back." -ForegroundColor DarkGray
    Write-Host ""
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

    if ($mission.Track -eq "Windows") {
        Write-CyberHeader -Title "$($mission.ID): $($mission.Title)" -Subtitle "Jedi training simulation initialized" -Theme "Jedi"
        $accent = "Cyan"
        $rankColor = "Green"
    }
    else {
        Write-CyberHeader -Title "$($mission.ID): $($mission.Title)" -Subtitle "Dark side terminal sequence initialized" -Theme "Dark"
        $accent = "Red"
        $rankColor = "DarkRed"
    }

    Write-Host "   Track      : $($mission.Track)" -ForegroundColor $accent
    Write-Host "   Difficulty : $($mission.Difficulty)" -ForegroundColor $rankColor
    Write-Host "   XP Reward  : $($mission.XP)" -ForegroundColor White
    Write-Host ""
    Write-Host "   LESSON:" -ForegroundColor Green
    Write-Host "   $($mission.Lesson)" -ForegroundColor White
    Write-Host ""
    Write-Host "   TASK:" -ForegroundColor Yellow
    Write-Host "   $($mission.Task)" -ForegroundColor White
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

echo "[4] Rebuilding Start-CyberShell.ps1 with larger cyber main menu..."
cat > Start-CyberShell.ps1 <<'PS1'
$ErrorActionPreference = "Stop"

. "$PSScriptRoot/engine/CyberTheme.ps1"
. "$PSScriptRoot/engine/ProfileSystem.ps1"
. "$PSScriptRoot/engine/RankSystem.ps1"
. "$PSScriptRoot/engine/MissionCatalog.ps1"

function Show-MainMenu {
    param(
        [object]$Profile
    )

    Write-CyberHeader -Title "CYBERSHELL TERMINAL OPS" -Subtitle "Operator profile loaded. Choose your training path." -Theme "Neutral"

    Show-OperatorStatus -Profile $Profile

    Write-Host ""
    Write-Host "   TRAINING PATHS" -ForegroundColor DarkGray
    Write-Host ""

    Write-MenuOption -Key "1" -Text "Windows Path, Jedi Systems Training" -Color Cyan
    Write-Host "       Light-side discipline, PowerShell, Windows admin, defense fundamentals" -ForegroundColor DarkGray

    Write-MenuOption -Key "2" -Text "Linux Path, Dark Side Terminal Training" -Color Red
    Write-Host "       Dark-side terminal control, Linux command mastery, operator fundamentals" -ForegroundColor DarkGray

    Write-Host ""
    Write-Host "   OPERATOR" -ForegroundColor DarkGray
    Write-Host ""

    Write-MenuOption -Key "3" -Text "View Profile" -Color White
    Write-MenuOption -Key "4" -Text "Switch Profile" -Color White
    Write-MenuOption -Key "5" -Text "Exit and Save" -Color Yellow
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
            Write-CyberHeader -Title "OPERATOR PROFILE" -Subtitle "Saved memory-based profile data" -Theme "Neutral"
            Show-OperatorStatus -Profile $CurrentProfile
            Write-Host ""
            Write-Host "   Completed Missions:" -ForegroundColor Yellow

            if ($CurrentProfile.CompletedMissions.Count -eq 0) {
                Write-Host "   None yet." -ForegroundColor DarkGray
            }
            else {
                $CurrentProfile.CompletedMissions | ForEach-Object {
                    Write-Host "   - $_" -ForegroundColor White
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

echo "[5] Theme patch complete."
echo ""
echo "Run:"
echo "cybergame"
