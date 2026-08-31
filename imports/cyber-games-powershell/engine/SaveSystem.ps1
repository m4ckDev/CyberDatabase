# SaveSystem.ps1
# Handles saving and loading player data

$Global:SavePath = "$PSScriptRoot\..\data\player-save.json"

function Save-Player {
    $Global:Player | ConvertTo-Json -Depth 10 | Set-Content -Path $Global:SavePath

    Write-Host ""
    Write-Host "Progress saved." -ForegroundColor DarkGreen
}

function Load-Player {
    if (Test-Path $Global:SavePath) {
        $saveContent = Get-Content -Path $Global:SavePath -Raw

        if (-not [string]::IsNullOrWhiteSpace($saveContent)) {
            $loadedPlayer = $saveContent | ConvertFrom-Json

            $Global:Player.Name = $loadedPlayer.Name
            $Global:Player.Rank = $loadedPlayer.Rank
            $Global:Player.Level = $loadedPlayer.Level
            $Global:Player.XP = $loadedPlayer.XP
            $Global:Player.Credits = $loadedPlayer.Credits
            $Global:Player.Health = $loadedPlayer.Health
            $Global:Player.Reputation = $loadedPlayer.Reputation
            $Global:Player.MissionsCompleted = @($loadedPlayer.MissionsCompleted)
            $Global:Player.ToolsUnlocked = @($loadedPlayer.ToolsUnlocked)
            $Global:Player.Achievements = @($loadedPlayer.Achievements)

            return $true
        }
    }

    return $false
}

function Reset-Save {
    if (Test-Path $Global:SavePath) {
        Remove-Item $Global:SavePath -Force
    }

    Write-Host "Save data reset." -ForegroundColor Yellow
}