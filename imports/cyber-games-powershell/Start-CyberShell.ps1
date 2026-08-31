$ErrorActionPreference = "Stop"

. "$PSScriptRoot/engine/CyberTheme.ps1"
. "$PSScriptRoot/engine/RankSystem.ps1"
. "$PSScriptRoot/engine/ProfileSystem.ps1"
. "$PSScriptRoot/engine/MissionCatalog.ps1"
. "$PSScriptRoot/engine/QuestionBank.ps1"
. "$PSScriptRoot/engine/GameSystems.ps1"
. "$PSScriptRoot/engine/HolocronAcademy.ps1"
. "$PSScriptRoot/engine/JediArchives.ps1"

function Show-MainMenu {
    param([object]$Profile)

    Write-CyberHeader -Title "CYBERSHELL ACADEMY" -Subtitle "Command-line cyber training RPG, public-test build" -Theme "Neutral"

    Show-OperatorStatus -Profile $Profile

    Write-Host ""
    Write-BoxLine
    Write-BoxText -Text "TRAINING PATHS" -Color Cyan
    Write-BoxText -Text "[1] Holocron Academy, walkthrough lessons"
    Write-BoxText -Text "[2] Windows Light Path, PowerShell and Windows fundamentals"
    Write-BoxText -Text "[3] Linux Shadow Path, terminal and Linux fundamentals"
    Write-BoxEnd

    Write-Host ""
    Write-BoxLine
    Write-BoxText -Text "OPERATOR SYSTEMS" -Color Yellow
    Write-BoxText -Text "[3] Placement Test        [4] Boss Trials"
    Write-BoxText -Text "[5] Skill Tree            [6] Daily Challenge"
    Write-BoxText -Text "[7] Badges                [8] Leaderboard"
    Write-BoxText -Text "[9] Switch Profile        [S] Speed Round"
    Write-BoxText -Text "[0] Exit and Save"
    Write-BoxEnd
    Write-Host ""
}

function Start-TrainingTrack {
    param(
        [object]$Profile,
        [string]$Track
    )

    while ($true) {
        Show-Missions -Track $Track -Profile $Profile
        $choice = Read-Menu -Prompt "Mission"

        if ($choice -match '^[Bb]$') {
            return $Profile
        }

        $Profile = Start-Mission -Profile $Profile -MissionID $choice.ToUpper()
    }
}

function Start-BossTrialMenu {
    param([object]$Profile)

    Write-CyberHeader -Title "BOSS TRIALS" -Subtitle "Choose a path trial" -Theme "Neutral"

    Write-MenuOption -Key "1" -Text "Windows Boss Trial" -Color Cyan
    Write-MenuOption -Key "2" -Text "Linux Boss Trial" -Color Red
    Write-MenuOption -Key "B" -Text "Back" -Color DarkGray

    $choice = Read-Menu -Prompt "Choose"

    switch ($choice) {
        "1" { return Start-BossTrial -Profile $Profile -Track "Windows" }
        "2" { return Start-BossTrial -Profile $Profile -Track "Linux" }
        default { return $Profile }
    }
}


function Start-SpeedRoundMenu {
    param([object]$Profile)

    Write-CyberHeader -Title "SPEED ROUND" -Subtitle "Choose a randomized speed challenge path" -Theme "Neutral"

    Write-MenuOption -Key "1" -Text "Windows Speed Round" -Color Cyan
    Write-MenuOption -Key "2" -Text "Linux Speed Round" -Color Red
    Write-MenuOption -Key "B" -Text "Back" -Color DarkGray

    $choice = Read-Menu -Prompt "Choose"

    switch ($choice) {
        "1" { return Start-SpeedRound -Profile $Profile -Track "Windows" }
        "2" { return Start-SpeedRound -Profile $Profile -Track "Linux" }
        default { return $Profile }
    }
}


$CurrentProfile = Select-CyberProfile
$Running = $true

while ($Running) {
    Show-MainMenu -Profile $CurrentProfile
    $menuChoice = Read-Menu -Prompt "Choose"

    switch ($menuChoice) {
        "1" {
            $CurrentProfile = Show-HolocronAcademy -Profile $CurrentProfile
        }
        "2" {
            $CurrentProfile = Start-TrainingTrack -Profile $CurrentProfile -Track "Windows"
        }
        "3" {
            $CurrentProfile = Start-TrainingTrack -Profile $CurrentProfile -Track "Linux"
        }
        "3" {
            $CurrentProfile = Start-PlacementTest -Profile $CurrentProfile
        }
        "4" {
            $CurrentProfile = Start-BossTrialMenu -Profile $CurrentProfile
        }
        "5" {
            Show-SkillTree -Profile $CurrentProfile
        }
        "6" {
            $CurrentProfile = Start-DailyChallenge -Profile $CurrentProfile
        }
        "7" {
            Show-Badges -Profile $CurrentProfile
        }
        "8" {
            Show-Leaderboard
        }
        "9" {
            
function Start-SpeedRoundMenu {
    param([object]$Profile)

    Write-CyberHeader -Title "SPEED ROUND" -Subtitle "Choose a randomized speed challenge path" -Theme "Neutral"

    Write-MenuOption -Key "1" -Text "Windows Speed Round" -Color Cyan
    Write-MenuOption -Key "2" -Text "Linux Speed Round" -Color Red
    Write-MenuOption -Key "B" -Text "Back" -Color DarkGray

    $choice = Read-Menu -Prompt "Choose"

    switch ($choice) {
        "1" { return Start-SpeedRound -Profile $Profile -Track "Windows" }
        "2" { return Start-SpeedRound -Profile $Profile -Track "Linux" }
        default { return $Profile }
    }
}


$CurrentProfile = Select-CyberProfile
        }
        "0" {
            Update-CyberProfile -Profile $CurrentProfile
            Clear-Host
            Write-Host "Operator progress saved." -ForegroundColor Green
            Write-Host "Exiting CyberShell Academy."
            $Running = $false
        }
        default {
            Write-Host "Invalid selection." -ForegroundColor Red
            Start-Sleep -Seconds 1
        }
    }
}
