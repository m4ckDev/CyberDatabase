$Global:Missions = @(
    [PSCustomObject]@{
        ID = "WIN-001"
        Track = "Windows"
        Title = "Current User Recon"
        RequiredXP = 0
        XP = 25
        Prompt = "What PowerShell or Windows command shows the current user?"
        Answers = @("whoami")
        Hint = "It starts with who."
        Skill = "Recon"
    },
    [PSCustomObject]@{
        ID = "WIN-002"
        Track = "Windows"
        Title = "Process Visibility"
        RequiredXP = 0
        XP = 30
        Prompt = "What PowerShell command lists running processes?"
        Answers = @("get-process", "gps")
        Hint = "Verb-Noun format. Get something."
        Skill = "Processes"
    },
    [PSCustomObject]@{
        ID = "WIN-003"
        Track = "Windows"
        Title = "Service Visibility"
        RequiredXP = 50
        XP = 45
        Prompt = "What PowerShell command lists Windows services?"
        Answers = @("get-service", "gsv")
        Hint = "Get the services."
        Skill = "Services"
    },
    [PSCustomObject]@{
        ID = "WIN-004"
        Track = "Windows"
        Title = "Network Configuration"
        RequiredXP = 150
        XP = 60
        Prompt = "What classic Windows command shows IP configuration?"
        Answers = @("ipconfig", "ipconfig /all")
        Hint = "IP configuration."
        Skill = "Networking"
    },
    [PSCustomObject]@{
        ID = "WIN-005"
        Track = "Windows"
        Title = "Event Log Check"
        RequiredXP = 300
        XP = 90
        Prompt = "What PowerShell command starts reading event logs? Type the command name only."
        Answers = @("get-eventlog", "get-winevent")
        Hint = "Get something related to logs or Windows events."
        Skill = "Logs"
    },
    [PSCustomObject]@{
        ID = "LIN-001"
        Track = "Linux"
        Title = "Current Directory"
        RequiredXP = 0
        XP = 25
        Prompt = "What Linux command prints your current directory?"
        Answers = @("pwd")
        Hint = "Print working directory."
        Skill = "Navigation"
    },
    [PSCustomObject]@{
        ID = "LIN-002"
        Track = "Linux"
        Title = "List Files"
        RequiredXP = 0
        XP = 30
        Prompt = "What Linux command lists files in the current directory?"
        Answers = @("ls", "ls -la", "ls -l")
        Hint = "Two letters."
        Skill = "Files"
    },
    [PSCustomObject]@{
        ID = "LIN-003"
        Track = "Linux"
        Title = "Current User"
        RequiredXP = 50
        XP = 45
        Prompt = "What Linux command shows the current username?"
        Answers = @("whoami", "id -un")
        Hint = "Same as Windows."
        Skill = "Recon"
    },
    [PSCustomObject]@{
        ID = "LIN-004"
        Track = "Linux"
        Title = "Process Awareness"
        RequiredXP = 150
        XP = 60
        Prompt = "What Linux command can show running processes? Type one common answer."
        Answers = @("ps aux", "ps", "top", "htop")
        Hint = "Process status."
        Skill = "Processes"
    },
    [PSCustomObject]@{
        ID = "LIN-005"
        Track = "Linux"
        Title = "Network Address"
        RequiredXP = 300
        XP = 90
        Prompt = "What Linux command shows IP addresses on modern systems?"
        Answers = @("ip a", "ip addr", "ip address")
        Hint = "Modern replacement for ifconfig."
        Skill = "Networking"
    }
)

function Normalize-Answer {
    param([string]$Text)

    if ($null -eq $Text) {
        return ""
    }

    return ($Text.Trim().ToLower() -replace '\s+', ' ')
}

function Test-Answer {
    param(
        [string]$UserAnswer,
        [array]$AcceptedAnswers
    )

    $clean = Normalize-Answer -Text $UserAnswer

    foreach ($answer in $AcceptedAnswers) {
        if ($clean -eq (Normalize-Answer -Text $answer)) {
            return $true
        }
    }

    return $false
}

function Show-Missions {
    param(
        [string]$Track,
        [object]$Profile
    )

    $theme = Get-ThemeForTrack -Track $Track
    $title = if ($Track -eq "Windows") { "WINDOWS LIGHT PATH" } else { "LINUX SHADOW PATH" }

    Write-CyberHeader -Title $title -Subtitle "Missions unlock as your XP increases" -Theme $theme

    $xp = if ($Track -eq "Windows") { $Profile.WindowsXP } else { $Profile.LinuxXP }

    foreach ($mission in ($Global:Missions | Where-Object { $_.Track -eq $Track })) {
        $complete = $Profile.CompletedMissions -contains $mission.ID
        $locked = $xp -lt $mission.RequiredXP

        if ($complete) {
            Write-Host "   [DONE] $($mission.ID) $($mission.Title) | +$($mission.XP) XP" -ForegroundColor Green
        }
        elseif ($locked) {
            Write-Host "   [LOCKED] $($mission.ID) $($mission.Title) | Requires $($mission.RequiredXP) XP" -ForegroundColor DarkGray
        }
        else {
            $color = if ($Track -eq "Windows") { "Cyan" } else { "Red" }
            Write-Host "   [$($mission.ID)] $($mission.Title) | +$($mission.XP) XP | Skill: $($mission.Skill)" -ForegroundColor $color
        }
    }

    Write-Host ""
    Write-Host "   Type mission ID to start, or B to go back." -ForegroundColor DarkGray
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

    $trackXP = if ($mission.Track -eq "Windows") { $Profile.WindowsXP } else { $Profile.LinuxXP }

    if ($trackXP -lt $mission.RequiredXP) {
        Write-Host "Mission locked. Required XP: $($mission.RequiredXP)" -ForegroundColor Yellow
        Start-Sleep -Seconds 2
        return $Profile
    }

    $theme = Get-ThemeForTrack -Track $mission.Track
    Write-CyberHeader -Title "$($mission.ID): $($mission.Title)" -Subtitle "Answer correctly to earn XP" -Theme $theme

    Write-Host "   Track: $($mission.Track)" -ForegroundColor White
    Write-Host "   Skill: $($mission.Skill)" -ForegroundColor White
    Write-Host "   Reward: $($mission.XP) XP" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "   $($mission.Prompt)" -ForegroundColor Cyan
    Write-Host ""

    $hintUsed = $false
    $correct = $false

    for ($attempt = 1; $attempt -le 3; $attempt++) {
        $answer = Read-Host "Answer, or type H for hint"

        if ($answer.Trim().ToUpper() -eq "H") {
            Write-Host "Hint: $($mission.Hint)" -ForegroundColor Yellow
            $hintUsed = $true
            $attempt--
            continue
        }

        if (Test-Answer -UserAnswer $answer -AcceptedAnswers $mission.Answers) {
            $correct = $true
            break
        }

        Write-Host "Incorrect. Attempts left: $(3 - $attempt)" -ForegroundColor Red
    }

    if ($correct) {
        if ($Profile.CompletedMissions -contains $mission.ID) {
            Write-Host "Correct, but mission was already completed. No duplicate XP." -ForegroundColor Yellow
        }
        else {
            $earned = $mission.XP

            if ($hintUsed) {
                $earned = [math]::Max(5, [math]::Floor($mission.XP * 0.75))
            }

            $Profile.CompletedMissions += $mission.ID

            if ($mission.Track -eq "Windows") {
                $Profile.WindowsXP += $earned
                $Profile = Add-Badge -Profile $Profile -Badge "Windows Path Started"
            }

            if ($mission.Track -eq "Linux") {
                $Profile.LinuxXP += $earned
                $Profile = Add-Badge -Profile $Profile -Badge "Linux Path Started"
            }

            $Profile.TotalXP += $earned
            $Profile = Add-Badge -Profile $Profile -Badge "First Mission Complete"

            if ($Profile.CompletedMissions.Count -ge 5) {
                $Profile = Add-Badge -Profile $Profile -Badge "Five Missions Complete"
            }

            Write-Host ""
            Write-Host "Correct. XP awarded: $earned" -ForegroundColor Green
        }
    }
    else {
        Write-Host ""
        Write-Host "Mission failed. Retry when ready." -ForegroundColor Red
        Write-Host "Review the lesson and try again." -ForegroundColor DarkGray
    }

    Update-CyberProfile -Profile $Profile
    Pause-Game
    return $Profile
}
