
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

function Add-Badge {
    param(
        [object]$Profile,
        [string]$Badge
    )

    $props = $Profile.PSObject.Properties.Name

    if ($props -notcontains "Badges") {
        $Profile | Add-Member -NotePropertyName Badges -NotePropertyValue @()
    }

    if ($Profile.Badges -notcontains $Badge) {
        $Profile.Badges += $Badge
        Write-Host ""
        Write-Host "BADGE UNLOCKED: $Badge" -ForegroundColor Yellow
    }

    return $Profile
}

function Repair-CyberProfile {
    param([object]$Profile)

    $props = $Profile.PSObject.Properties.Name

    if ($props -notcontains "Badges") {
        $Profile | Add-Member -NotePropertyName Badges -NotePropertyValue @()
    }

    if ($props -notcontains "CurrentStreak") {
        $Profile | Add-Member -NotePropertyName CurrentStreak -NotePropertyValue 0
    }

    if ($props -notcontains "BestStreak") {
        $Profile | Add-Member -NotePropertyName BestStreak -NotePropertyValue 0
    }

    if ($props -notcontains "LastDailyDate") {
        $Profile | Add-Member -NotePropertyName LastDailyDate -NotePropertyValue ""
    }

    if ($props -notcontains "PlacementComplete") {
        $Profile | Add-Member -NotePropertyName PlacementComplete -NotePropertyValue $false
    }

    if ($props -notcontains "CompletedMissions") {
        $Profile | Add-Member -NotePropertyName CompletedMissions -NotePropertyValue @()
    }

    if ($props -notcontains "WindowsXP") {
        $Profile | Add-Member -NotePropertyName WindowsXP -NotePropertyValue 0
    }

    if ($props -notcontains "LinuxXP") {
        $Profile | Add-Member -NotePropertyName LinuxXP -NotePropertyValue 0
    }

    if ($props -notcontains "TotalXP") {
        $Profile | Add-Member -NotePropertyName TotalXP -NotePropertyValue 0
    }

    return $Profile
}



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

$Global:PlacementQuestions = @(
    [PSCustomObject]@{ Track="Windows"; Prompt="Command to show current user?"; Answers=@("whoami") },
    [PSCustomObject]@{ Track="Windows"; Prompt="PowerShell command to list processes?"; Answers=@("get-process", "gps") },
    [PSCustomObject]@{ Track="Windows"; Prompt="Classic command to show IP config?"; Answers=@("ipconfig", "ipconfig /all") },
    [PSCustomObject]@{ Track="Windows"; Prompt="PowerShell command to list services?"; Answers=@("get-service", "gsv") },
    [PSCustomObject]@{ Track="Linux"; Prompt="Linux command to print working directory?"; Answers=@("pwd") },
    [PSCustomObject]@{ Track="Linux"; Prompt="Linux command to list files?"; Answers=@("ls", "ls -la", "ls -l") },
    [PSCustomObject]@{ Track="Linux"; Prompt="Linux command to show current user?"; Answers=@("whoami", "id -un") },
    [PSCustomObject]@{ Track="Linux"; Prompt="Linux command to show processes?"; Answers=@("ps aux", "ps", "top", "htop") },
    [PSCustomObject]@{ Track="Linux"; Prompt="Linux command to show IP addresses?"; Answers=@("ip a", "ip addr", "ip address") },
    [PSCustomObject]@{ Track="Linux"; Prompt="Linux command to print file content?"; Answers=@("cat") }
)

function Start-PlacementTest {
    param([object]$Profile)

    $Profile = Repair-CyberProfile -Profile $Profile

    if ($Profile.PlacementComplete) {
        Write-CyberHeader -Title "PLACEMENT TEST" -Subtitle "Already completed for this profile" -Theme "Neutral"
        Write-Host "Placement test already complete." -ForegroundColor Yellow
        Pause-Game
        return $Profile
    }

    Write-CyberHeader -Title "PLACEMENT TEST" -Subtitle "Score decides your starting XP" -Theme "Neutral"

    $score = 0

    for ($i = 0; $i -lt $Global:PlacementQuestions.Count; $i++) {
        $q = $Global:PlacementQuestions[$i]
        Write-Host ""
        Write-Host "Question $($i + 1)/$($Global:PlacementQuestions.Count): $($q.Prompt)" -ForegroundColor Cyan
        $answer = Read-Host "Answer"

        if (Test-Answer -UserAnswer $answer -AcceptedAnswers $q.Answers) {
            Write-Host "Correct." -ForegroundColor Green
            $score++
        }
        else {
            Write-Host "Incorrect." -ForegroundColor Red
        }
    }

    $bonus = 0
    if ($score -ge 9) {
        $bonus = 300
    }
    elseif ($score -ge 7) {
        $bonus = 150
    }
    elseif ($score -ge 4) {
        $bonus = 50
    }

    $Profile.WindowsXP += $bonus
    $Profile.LinuxXP += $bonus
    $Profile.TotalXP += ($bonus * 2)
    $Profile.PlacementComplete = $true
    $Profile = Add-Badge -Profile $Profile -Badge "Placement Test Complete"

    Write-Host ""
    Write-Host "Score: $score/10" -ForegroundColor Yellow
    Write-Host "Starting bonus awarded to each path: $bonus XP" -ForegroundColor Green

    Update-CyberProfile -Profile $Profile
    Pause-Game
    return $Profile
}


function Start-BossTrial {
    param(
        [object]$Profile,
        [string]$Track
    )

    $theme = Get-ThemeForTrack -Track $Track
    Write-CyberHeader -Title "$Track BOSS TRIAL" -Subtitle "10 random questions. Score 8/10 to pass. No hints." -Theme $theme

    $questions = Get-RandomQuestions -Track $Track -Count 10

    if (@($questions).Count -eq 0) {
        Write-Host "No questions found for $Track." -ForegroundColor Red
        Pause-Game
        return $Profile
    }

    $score = 0
    $questionNumber = 1

    foreach ($q in $questions) {
        Write-Host ""
        Write-Host "Question $questionNumber/10" -ForegroundColor Yellow
        Write-Host "$($q.Prompt)" -ForegroundColor Cyan

        $answer = Read-Host "Answer"

        if (Test-Answer -UserAnswer $answer -AcceptedAnswers $q.Answers) {
            Write-Host "Correct." -ForegroundColor Green
            $score++
        }
        else {
            Write-Host "Incorrect." -ForegroundColor Red
        }

        $questionNumber++
    }

    Write-Host ""
    Write-Host "Trial score: $score/10" -ForegroundColor Yellow

    if ($score -ge 8) {
        $badge = "$Track Boss Trial Passed"
        $Profile = Add-Badge -Profile $Profile -Badge $badge
        $Profile.TotalXP += 150

        if ($Track -eq "Windows") {
            $Profile.WindowsXP += 150
        }

        if ($Track -eq "Linux") {
            $Profile.LinuxXP += 150
        }

        Write-Host "Boss trial passed. +150 XP." -ForegroundColor Green
    }
    else {
        Write-Host "Boss trial failed. Score 8/10 required." -ForegroundColor Red
    }

    Update-CyberProfile -Profile $Profile
    Pause-Game
    return $Profile
}

function Start-SpeedRound {
    param(
        [object]$Profile,
        [string]$Track
    )

    $theme = Get-ThemeForTrack -Track $Track
    Write-CyberHeader -Title "$Track SPEED ROUND" -Subtitle "5 random questions. Fast recall training." -Theme $theme

    $questions = Get-RandomQuestions -Track $Track -Count 5

    if (@($questions).Count -eq 0) {
        Write-Host "No questions found for $Track." -ForegroundColor Red
        Pause-Game
        return $Profile
    }

    $score = 0
    $questionNumber = 1

    foreach ($q in $questions) {
        Write-Host ""
        Write-Host "Speed Question $questionNumber/5" -ForegroundColor Yellow
        Write-Host "$($q.Prompt)" -ForegroundColor Cyan

        $answer = Read-Host "Answer"

        if (Test-Answer -UserAnswer $answer -AcceptedAnswers $q.Answers) {
            Write-Host "Correct." -ForegroundColor Green
            $score++
        }
        else {
            Write-Host "Incorrect." -ForegroundColor Red
        }

        $questionNumber++
    }

    $earned = $score * 10

    $Profile.TotalXP += $earned

    if ($Track -eq "Windows") {
        $Profile.WindowsXP += $earned
    }

    if ($Track -eq "Linux") {
        $Profile.LinuxXP += $earned
    }

    if ($score -eq 5) {
        $Profile = Add-Badge -Profile $Profile -Badge "$Track Perfect Speed Round"
    }

    Write-Host ""
    Write-Host "Speed round complete. Score: $score/5. XP earned: $earned" -ForegroundColor Green

    Update-CyberProfile -Profile $Profile
    Pause-Game
    return $Profile
}


function Start-DailyChallenge {
    param([object]$Profile)

    $today = (Get-Date).ToString("yyyy-MM-dd")
    $index = [math]::Abs($today.GetHashCode()) % $Global:Missions.Count
    $challenge = $Global:Missions[$index]

    Write-CyberHeader -Title "DAILY CHALLENGE" -Subtitle "One challenge per day. Build your streak." -Theme "Neutral"

    if ($Profile.LastDailyDate -eq $today) {
        Write-Host "Daily challenge already completed today." -ForegroundColor Yellow
        Pause-Game
        return $Profile
    }

    Write-Host "Challenge: $($challenge.Prompt)" -ForegroundColor Cyan
    Write-Host "Reward: 50 XP + streak progress" -ForegroundColor Yellow
    Write-Host ""

    $answer = Read-Host "Answer"

    if (Test-Answer -UserAnswer $answer -AcceptedAnswers $challenge.Answers) {
        Write-Host "Correct. Daily complete." -ForegroundColor Green

        $yesterday = (Get-Date).AddDays(-1).ToString("yyyy-MM-dd")

        if ($Profile.LastDailyDate -eq $yesterday) {
            $Profile.CurrentStreak++
        }
        else {
            $Profile.CurrentStreak = 1
        }

        if ($Profile.CurrentStreak -gt $Profile.BestStreak) {
            $Profile.BestStreak = $Profile.CurrentStreak
        }

        $Profile.LastDailyDate = $today
        $Profile.TotalXP += 50

        if ($challenge.Track -eq "Windows") {
            $Profile.WindowsXP += 50
        }

        if ($challenge.Track -eq "Linux") {
            $Profile.LinuxXP += 50
        }

        if ($Profile.CurrentStreak -ge 3) {
            $Profile = Add-Badge -Profile $Profile -Badge "Three Day Streak"
        }

        if ($Profile.CurrentStreak -ge 7) {
            $Profile = Add-Badge -Profile $Profile -Badge "Seven Day Streak"
        }
    }
    else {
        Write-Host "Incorrect. Try tomorrow or train more." -ForegroundColor Red
    }

    Update-CyberProfile -Profile $Profile
    Pause-Game
    return $Profile
}

function Show-SkillTree {
    param([object]$Profile)

    Write-CyberHeader -Title "SKILL TREE" -Subtitle "Progress by completed mission skills" -Theme "Neutral"

    $skills = @("Recon", "Files", "Navigation", "Processes", "Services", "Networking", "Logs")

    foreach ($skill in $skills) {
        $done = $false

        foreach ($mission in $Global:Missions) {
            if ($mission.Skill -eq $skill -and $Profile.CompletedMissions -contains $mission.ID) {
                $done = $true
            }
        }

        if ($done) {
            Write-Host "   [✓] $skill" -ForegroundColor Green
        }
        else {
            Write-Host "   [ ] $skill" -ForegroundColor DarkGray
        }
    }

    Pause-Game
}

function Show-Badges {
    param([object]$Profile)

    Write-CyberHeader -Title "BADGES" -Subtitle "Operator achievements" -Theme "Neutral"

    if ($Profile.Badges.Count -eq 0) {
        Write-Host "No badges yet." -ForegroundColor DarkGray
    }
    else {
        foreach ($badge in $Profile.Badges) {
            Write-Host "   [✓] $badge" -ForegroundColor Yellow
        }
    }

    Pause-Game
}

function Show-Leaderboard {
    Write-CyberHeader -Title "LOCAL LEADERBOARD" -Subtitle "Local profiles ranked by total XP" -Theme "Neutral"

    $profiles = @(Get-Profiles) | Sort-Object -Property TotalXP -Descending

    if ($profiles.Count -eq 0) {
        Write-Host "No profiles found." -ForegroundColor DarkGray
    }
    else {
        $rank = 1

        foreach ($p in $profiles) {
            Write-Host "   $rank. $($p.Name) | $($p.TotalXP) XP | Badges: $($p.Badges.Count)" -ForegroundColor Cyan
            $rank++
        }
    }

    Pause-Game
}
