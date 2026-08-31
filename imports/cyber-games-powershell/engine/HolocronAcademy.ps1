function New-HolocronLesson {
    param(
        [string]$ID,
        [string]$Track,
        [string]$Rank,
        [string]$Title,
        [string]$Skill,
        [int]$XP,
        [string]$Command,
        [string]$PrimaryAnswer,
        [array]$AcceptedAnswers,
        [string]$Concept,
        [array]$Breakdown,
        [string]$ExampleCommand,
        [string]$ExampleOutput,
        [array]$Practice,
        [string]$Purpose
    )

    return [PSCustomObject]@{
        ID = $ID
        Track = $Track
        Rank = $Rank
        Title = $Title
        Skill = $Skill
        XP = $XP
        Command = $Command
        PrimaryAnswer = $PrimaryAnswer
        AcceptedAnswers = $AcceptedAnswers
        Concept = $Concept
        Breakdown = $Breakdown
        ExampleCommand = $ExampleCommand
        ExampleOutput = $ExampleOutput
        Practice = $Practice
        Purpose = $Purpose
    }
}

$Global:LinuxHolocronLessons = @(
    New-HolocronLesson -ID "H-LIN-001" -Track "Linux" -Rank "Youngling" -Title "Know Where You Are" -Skill "Navigation" -XP 25 -Command "pwd" -PrimaryAnswer "pwd" -AcceptedAnswers @("pwd") -Concept "Before running commands, you need to know what folder your terminal is currently inside. Linux calls this your working directory." -Breakdown @("pwd means print working directory.","It shows your current folder.","It does not change anything.","Use it before creating, moving, or deleting files.") -ExampleCommand "pwd" -ExampleOutput "/home/operator" -Practice @("Run pwd.","Read the output.","Identify your current folder.") -Purpose "shows your current directory"

    New-HolocronLesson -ID "H-LIN-002" -Track "Linux" -Rank "Youngling" -Title "List Files and Folders" -Skill "Files" -XP 25 -Command "ls" -PrimaryAnswer "ls" -AcceptedAnswers @("ls","ls -l","ls -la") -Concept "The ls command lists files and folders so you can see what is inside your current location." -Breakdown @("ls lists visible files.","ls -l shows details.","ls -a shows hidden files.","ls -la combines hidden files and details.") -ExampleCommand "ls -la" -ExampleOutput "drwxr-xr-x Documents`n-rw-r--r-- notes.txt" -Practice @("Run ls.","Run ls -la.","Compare the difference.") -Purpose "lists files and folders"

    New-HolocronLesson -ID "H-LIN-003" -Track "Linux" -Rank "Padawan" -Title "Move Through Directories" -Skill "Navigation" -XP 35 -Command "cd" -PrimaryAnswer "cd" -AcceptedAnswers @("cd","cd ~","cd ..","cd /") -Concept "The cd command changes your current directory. This is how you move through the Linux file system." -Breakdown @("cd folder-name moves into a folder.","cd .. moves up one folder.","cd ~ returns home.","cd / moves to root.") -ExampleCommand "cd ~/Documents" -ExampleOutput "No output usually means success. Run pwd to confirm." -Practice @("Run cd ~.","Run pwd.","Run cd ...","Run pwd again.") -Purpose "changes directories"

    New-HolocronLesson -ID "H-LIN-004" -Track "Linux" -Rank "Padawan" -Title "Create Files and Folders" -Skill "Files" -XP 35 -Command "mkdir and touch" -PrimaryAnswer "touch notes.txt" -AcceptedAnswers @("touch notes.txt","mkdir lab","touch lab/notes.txt","mkdir -p lab") -Concept "Linux lets you create folders and files directly from the terminal." -Breakdown @("mkdir creates directories.","touch creates empty files.","mkdir -p creates parent folders if needed.","Use ls to confirm creation.") -ExampleCommand "mkdir lab`ntouch lab/notes.txt`nls lab" -ExampleOutput "notes.txt" -Practice @("Create a folder named lab.","Create notes.txt inside lab.","List the lab folder.") -Purpose "creates files and folders"

    New-HolocronLesson -ID "H-LIN-005" -Track "Linux" -Rank "Jedi Knight" -Title "Read Files" -Skill "Files" -XP 40 -Command "cat, less, head, tail" -PrimaryAnswer "cat file.txt" -AcceptedAnswers @("cat file.txt","less file.txt","head file.txt","tail file.txt") -Concept "Reading files is required for troubleshooting, log review, scripting, and cyber investigations." -Breakdown @("cat prints small files.","less opens large files page by page.","head shows the top of a file.","tail shows the end of a file.") -ExampleCommand "cat notes.txt`ntail -n 20 /var/log/syslog" -ExampleOutput "file contents print to the terminal" -Practice @("Create a text file.","Read it with cat.","View only the end with tail.") -Purpose "reads file contents"

    New-HolocronLesson -ID "H-LIN-006" -Track "Linux" -Rank "Jedi Knight" -Title "Search for Intel" -Skill "Search" -XP 45 -Command "find and grep" -PrimaryAnswer "grep" -AcceptedAnswers @("grep","grep -R","find","find . -name file.txt") -Concept "find locates files. grep searches inside files. Together they are core investigation commands." -Breakdown @("find searches by name, type, size, and path.","grep searches text.","grep -R searches recursively.","Use these to find logs, configs, and indicators.") -ExampleCommand "find . -name '*.txt'`ngrep -R error ." -ExampleOutput "matching files and matching lines appear" -Practice @("Create files.","Search by name with find.","Search content with grep.") -Purpose "finds files and searches text"

    New-HolocronLesson -ID "H-LIN-007" -Track "Linux" -Rank "Jedi Knight" -Title "Permissions" -Skill "Permissions" -XP 50 -Command "ls -l, chmod, chown" -PrimaryAnswer "chmod" -AcceptedAnswers @("chmod","chmod 600 file.txt","chown","ls -l") -Concept "Linux permissions control who can read, write, or execute files." -Breakdown @("ls -l shows permissions.","chmod changes permissions.","chown changes ownership.","Permissions protect sensitive files.") -ExampleCommand "ls -l secret.txt`nchmod 600 secret.txt" -ExampleOutput "-rw------- secret.txt" -Practice @("Run ls -l.","Create a file.","Change permissions with chmod.") -Purpose "changes permissions"

    New-HolocronLesson -ID "H-LIN-008" -Track "Linux" -Rank "Jedi Master" -Title "Processes" -Skill "Processes" -XP 55 -Command "ps aux, top, kill" -PrimaryAnswer "ps aux" -AcceptedAnswers @("ps aux","ps -ef","top","htop","kill") -Concept "Processes are running programs. Operators need to inspect, monitor, and sometimes stop them." -Breakdown @("ps aux lists processes.","top shows live usage.","PID means process ID.","kill stops a process by PID.") -ExampleCommand "ps aux`ntop`nkill 1234" -ExampleOutput "process list and usage data appear" -Practice @("Run ps aux.","Find one PID.","Open top.") -Purpose "shows running processes"

    New-HolocronLesson -ID "H-LIN-009" -Track "Linux" -Rank "Jedi Master" -Title "Networking Basics" -Skill "Networking" -XP 60 -Command "ip a, ping, ss, curl" -PrimaryAnswer "ip a" -AcceptedAnswers @("ip a","ip addr","ping","ss -tulnp","curl") -Concept "Networking commands show IP addresses, connectivity, listening ports, and web responses." -Breakdown @("ip a shows addresses.","ping tests reachability.","ss shows sockets and ports.","curl sends web requests.") -ExampleCommand "ip a`nping 8.8.8.8`nss -tulnp" -ExampleOutput "IP addresses, ping replies, and ports appear" -Practice @("Find your IP.","Ping a target.","Check listening ports.") -Purpose "checks Linux networking"

    New-HolocronLesson -ID "H-LIN-010" -Track "Linux" -Rank "Jedi Council" -Title "Logs, Services, and Packages" -Skill "Administration" -XP 75 -Command "journalctl, systemctl, apt" -PrimaryAnswer "systemctl status" -AcceptedAnswers @("systemctl status","journalctl","journalctl -xe","sudo apt update","apt update") -Concept "Linux administrators inspect logs, control services, and manage packages." -Breakdown @("systemctl checks and controls services.","journalctl reads system logs.","apt manages packages on Ubuntu/Debian.","Logs explain what happened.") -ExampleCommand "systemctl status ssh`njournalctl -xe`nsudo apt update" -ExampleOutput "service status, logs, and package update data appear" -Practice @("Check a service.","Read recent logs.","Update package lists.") -Purpose "manages services logs and packages"
)

$Global:PowerShellHolocronLessons = @(
    New-HolocronLesson -ID "H-PS-001" -Track "PowerShell" -Rank "Recruit" -Title "Understand PowerShell" -Skill "Basics" -XP 25 -Command '$PSVersionTable' -PrimaryAnswer '$PSVersionTable' -AcceptedAnswers @('$PSVersionTable') -Concept "PowerShell is a command shell and scripting language used for Windows administration, automation, and security work." -Breakdown @("PowerShell uses cmdlets.","Cmdlets use Verb-Noun format.","PowerShell handles objects.","It is built for automation.") -ExampleCommand '$PSVersionTable' -ExampleOutput "PSVersion information appears" -Practice @("Open PowerShell.","Run `$PSVersionTable.","Identify your version.") -Purpose "shows PowerShell version information"

    New-HolocronLesson -ID "H-PS-002" -Track "PowerShell" -Rank "Recruit" -Title "Use Built-In Help" -Skill "Help" -XP 25 -Command "Get-Help and Get-Command" -PrimaryAnswer "Get-Help Get-Process" -AcceptedAnswers @("Get-Help Get-Process","help Get-Process","Get-Command","gcm") -Concept "PowerShell has built-in help so users can learn without guessing." -Breakdown @("Get-Help explains commands.","-Examples shows examples.","Get-Command lists commands.","Help reduces bad copy-paste habits.") -ExampleCommand "Get-Help Get-Process -Examples" -ExampleOutput "examples for Get-Process appear" -Practice @("Run Get-Help Get-Service.","Run Get-Command.","Read one example.") -Purpose "shows help and discovers commands"

    New-HolocronLesson -ID "H-PS-003" -Track "PowerShell" -Rank "Stormtrooper" -Title "Navigation" -Skill "Navigation" -XP 35 -Command "Get-Location, Set-Location, Get-ChildItem" -PrimaryAnswer "Get-ChildItem" -AcceptedAnswers @("Get-ChildItem","gci","ls","dir","Get-Location","Set-Location") -Concept "PowerShell can move through folders and inspect files." -Breakdown @("Get-Location shows current path.","Set-Location changes path.","Get-ChildItem lists contents.","Aliases include pwd, cd, ls, dir.") -ExampleCommand "Get-Location`nGet-ChildItem`nSet-Location `$HOME" -ExampleOutput "path and folder contents appear" -Practice @("Run Get-Location.","Run Get-ChildItem.","Move to home.") -Purpose "navigates the Windows file system"

    New-HolocronLesson -ID "H-PS-004" -Track "PowerShell" -Rank "Stormtrooper" -Title "Create and Read Files" -Skill "Files" -XP 35 -Command "New-Item, Set-Content, Get-Content" -PrimaryAnswer "New-Item" -AcceptedAnswers @("New-Item","Set-Content","Get-Content","New-Item -ItemType File") -Concept "PowerShell can create folders, create files, write content, and read content." -Breakdown @("New-Item creates files/folders.","Set-Content writes text.","Get-Content reads text.","These commands support reporting and evidence handling.") -ExampleCommand 'New-Item -ItemType Directory -Name Vault`nSet-Content .\Vault\report.txt "System secure"`nGet-Content .\Vault\report.txt' -ExampleOutput "System secure" -Practice @("Create a folder.","Write a report file.","Read it back.") -Purpose "creates and reads files"

    New-HolocronLesson -ID "H-PS-005" -Track "PowerShell" -Rank "Stormtrooper" -Title "Copy Move Remove" -Skill "Files" -XP 40 -Command "Copy-Item, Move-Item, Remove-Item" -PrimaryAnswer "Copy-Item" -AcceptedAnswers @("Copy-Item","Move-Item","Remove-Item","cp","mv","rm") -Concept "PowerShell uses item commands to manage files and folders safely." -Breakdown @("Copy-Item copies.","Move-Item moves or renames.","Remove-Item deletes.","-WhatIf previews actions.") -ExampleCommand 'Copy-Item .\report.txt .\backup.txt`nMove-Item .\backup.txt .\archive.txt' -ExampleOutput "No output usually means success" -Practice @("Copy a file.","Rename it.","Use Get-ChildItem to verify.") -Purpose "copies moves and removes files"

    New-HolocronLesson -ID "H-PS-006" -Track "PowerShell" -Rank "Sith Apprentice" -Title "System Recon" -Skill "Recon" -XP 45 -Command "hostname, whoami, Get-ComputerInfo, Get-LocalUser" -PrimaryAnswer "whoami" -AcceptedAnswers @("whoami","hostname","Get-ComputerInfo","Get-LocalUser") -Concept "PowerShell can gather computer identity, user identity, and local user information." -Breakdown @("hostname shows computer name.","whoami shows current user.","Get-ComputerInfo shows system info.","Get-LocalUser lists local users.") -ExampleCommand "hostname`nwhoami`nGet-LocalUser" -ExampleOutput "computer, user, and local users appear" -Practice @("Run hostname.","Run whoami.","List local users.") -Purpose "gathers system identity"

    New-HolocronLesson -ID "H-PS-007" -Track "PowerShell" -Rank "Sith Apprentice" -Title "Processes and Services" -Skill "Processes" -XP 50 -Command "Get-Process and Get-Service" -PrimaryAnswer "Get-Process" -AcceptedAnswers @("Get-Process","gps","Get-Service","gsv","Stop-Process") -Concept "Processes are running programs. Services are background components. Both matter for troubleshooting and defense." -Breakdown @("Get-Process lists processes.","Get-Service lists services.","Stop-Process stops a process.","Sort-Object narrows output.") -ExampleCommand "Get-Process`nGet-Service" -ExampleOutput "process and service lists appear" -Practice @("Run Get-Process.","Run Get-Service.","Find one running service.") -Purpose "inspects processes and services"

    New-HolocronLesson -ID "H-PS-008" -Track "PowerShell" -Rank "Sith Lord" -Title "Variables and Logic" -Skill "Scripting" -XP 55 -Command '$name, if, foreach' -PrimaryAnswer '$' -AcceptedAnswers @('$','if','foreach','$name') -Concept "Variables store values. Logic lets scripts make decisions. Loops repeat actions." -Breakdown @("$ starts variables.","if checks conditions.","foreach loops through items.","Scripts automate repeated work.") -ExampleCommand '$name = "operator"`nif ($name -eq "operator") { Write-Host "ready" }' -ExampleOutput "ready" -Practice @("Create a variable.","Use an if statement.","Loop through a small list.") -Purpose "uses scripting logic"

    New-HolocronLesson -ID "H-PS-009" -Track "PowerShell" -Rank "Sith Lord" -Title "Networking" -Skill "Networking" -XP 60 -Command "Get-NetIPAddress, Test-NetConnection, Get-NetTCPConnection" -PrimaryAnswer "Get-NetTCPConnection" -AcceptedAnswers @("Get-NetTCPConnection","Get-NetIPAddress","Test-NetConnection") -Concept "PowerShell can inspect Windows IP addresses, connections, and network reachability." -Breakdown @("Get-NetIPAddress shows IPs.","Test-NetConnection tests connectivity.","Get-NetTCPConnection shows TCP connections.","These support network troubleshooting.") -ExampleCommand "Get-NetIPAddress`nTest-NetConnection google.com`nGet-NetTCPConnection" -ExampleOutput "IP and TCP connection data appear" -Practice @("Show IP addresses.","Test connectivity.","Show TCP connections.") -Purpose "checks Windows networking"

    New-HolocronLesson -ID "H-PS-010" -Track "PowerShell" -Rank "Darth Master" -Title "Security Operations" -Skill "Security" -XP 75 -Command "Get-MpComputerStatus, Get-NetFirewallRule, Get-WinEvent" -PrimaryAnswer "Get-WinEvent" -AcceptedAnswers @("Get-MpComputerStatus","Get-NetFirewallRule","Get-WinEvent","Get-FileHash") -Concept "PowerShell can inspect Defender, firewall, event logs, file hashes, and other security information." -Breakdown @("Get-MpComputerStatus checks Defender.","Get-NetFirewallRule checks firewall rules.","Get-WinEvent reads event logs.","Get-FileHash fingerprints files.") -ExampleCommand "Get-MpComputerStatus`nGet-NetFirewallRule`nGet-WinEvent -LogName Security -MaxEvents 10" -ExampleOutput "security status, firewall rules, and events appear" -Practice @("Check Defender.","List firewall rules.","Read recent Security events.") -Purpose "performs basic security checks"
)

function Repair-HolocronProfile {
    param([object]$Profile)

    $name = "Operator"
    $created = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
    $lastLogin = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
    $windowsXP = 0
    $linuxXP = 0
    $totalXP = 0
    $completed = @()
    $badges = @()
    $currentStreak = 0
    $bestStreak = 0
    $lastDailyDate = ""
    $placementComplete = $false

    if ($null -ne $Profile) {
        $props = @($Profile.PSObject.Properties.Name)
        if ($props -contains "Name" -and $null -ne $Profile.Name) { $name = [string]$Profile.Name }
        if ($props -contains "Created" -and $null -ne $Profile.Created) { $created = [string]$Profile.Created }
        if ($props -contains "LastLogin" -and $null -ne $Profile.LastLogin) { $lastLogin = [string]$Profile.LastLogin }
        if ($props -contains "WindowsXP" -and $null -ne $Profile.WindowsXP) { $windowsXP = [int]$Profile.WindowsXP }
        if ($props -contains "LinuxXP" -and $null -ne $Profile.LinuxXP) { $linuxXP = [int]$Profile.LinuxXP }
        if ($props -contains "TotalXP" -and $null -ne $Profile.TotalXP) { $totalXP = [int]$Profile.TotalXP }
        if ($props -contains "CompletedMissions" -and $null -ne $Profile.CompletedMissions) { $completed = @($Profile.CompletedMissions) }
        if ($props -contains "Badges" -and $null -ne $Profile.Badges) { $badges = @($Profile.Badges) }
        if ($props -contains "CurrentStreak" -and $null -ne $Profile.CurrentStreak) { $currentStreak = [int]$Profile.CurrentStreak }
        if ($props -contains "BestStreak" -and $null -ne $Profile.BestStreak) { $bestStreak = [int]$Profile.BestStreak }
        if ($props -contains "LastDailyDate" -and $null -ne $Profile.LastDailyDate) { $lastDailyDate = [string]$Profile.LastDailyDate }
        if ($props -contains "PlacementComplete" -and $null -ne $Profile.PlacementComplete) { $placementComplete = [bool]$Profile.PlacementComplete }
    }

    return [PSCustomObject]@{
        Name = $name
        Created = $created
        LastLogin = $lastLogin
        WindowsXP = $windowsXP
        LinuxXP = $linuxXP
        TotalXP = $totalXP
        CompletedMissions = @($completed)
        Badges = @($badges)
        CurrentStreak = $currentStreak
        BestStreak = $bestStreak
        LastDailyDate = $lastDailyDate
        PlacementComplete = $placementComplete
    }
}

function Test-HolocronAnswer {
    param([string]$Answer,[array]$Accepted)

    if ([string]::IsNullOrWhiteSpace($Answer)) { return $false }

    $clean = ($Answer.Trim().ToLower() -replace '\s+', ' ')

    foreach ($item in $Accepted) {
        $expected = ($item.Trim().ToLower() -replace '\s+', ' ')
        if ($clean -eq $expected) { return $true }
    }

    return $false
}

function Get-GeneratedQuestions {
    param([object]$Lesson)

    return @(
        @{Q="What is the main command or command family for this lesson?"; A=@($Lesson.PrimaryAnswer) + $Lesson.AcceptedAnswers},
        @{Q="What does this lesson's command help you do?"; A=@($Lesson.Purpose)},
        @{Q="Which command should you practice first in this lesson?"; A=@($Lesson.PrimaryAnswer) + $Lesson.AcceptedAnswers},
        @{Q="What skill area does this lesson belong to?"; A=@($Lesson.Skill)},
        @{Q="What rank tier is this lesson?"; A=@($Lesson.Rank)},
        @{Q="Type one accepted command from this lesson."; A=@($Lesson.PrimaryAnswer) + $Lesson.AcceptedAnswers},
        @{Q="Does this lesson require terminal practice?"; A=@("yes","y")},
        @{Q="What command appears in the COMMAND section?"; A=@($Lesson.PrimaryAnswer) + $Lesson.AcceptedAnswers},
        @{Q="What is the purpose of the command in plain words?"; A=@($Lesson.Purpose)},
        @{Q="Should you understand the command before taking the trial?"; A=@("yes","y")}
    )
}

function Start-HolocronCheckpoint {
    param([object]$Profile,[object]$Lesson,[string]$Track)

    $Profile = Repair-HolocronProfile -Profile $Profile
    $questions = @(Get-GeneratedQuestions -Lesson $Lesson)

    $score = 0
    $required = 8
    $number = 1

    Write-Host ""
    Write-Host "CHECKPOINT EXAM: 10 QUESTIONS" -ForegroundColor Magenta
    Write-Host "Required to pass: 8/10" -ForegroundColor Yellow
    Write-Host ""

    foreach ($q in $questions) {
        Write-Host "Question $number/10: $($q.Q)" -ForegroundColor Cyan
        $answer = Read-Host "Answer"

        if (Test-HolocronAnswer -Answer $answer -Accepted $q.A) {
            Write-Host "Correct." -ForegroundColor Green
            $score++
        }
        else {
            Write-Host "Incorrect." -ForegroundColor Red
        }

        Write-Host ""
        $number++
    }

    Write-Host "Final Score: $score/10" -ForegroundColor Yellow

    if ($score -ge $required) {
        if ($Profile.CompletedMissions -contains $Lesson.ID) {
            Write-Host "Passed. Lesson already completed. No duplicate XP." -ForegroundColor Yellow
        }
        else {
            $Profile.CompletedMissions += $Lesson.ID

            if ($Track -eq "Linux") { $Profile.LinuxXP += $Lesson.XP }
            else { $Profile.WindowsXP += $Lesson.XP }

            $Profile.TotalXP += $Lesson.XP
            $Profile = Add-Badge -Profile $Profile -Badge "Holocron Student"

            Write-Host "Passed. XP awarded: $($Lesson.XP)" -ForegroundColor Green
            Update-CyberProfile -Profile $Profile
        }
    }
    else {
        Write-Host "Checkpoint failed. Review the lesson and try again." -ForegroundColor Red
    }

    Pause-Game
    return $Profile
}

function Show-HolocronLesson {
    param([object]$Profile,[object]$Lesson,[string]$Track,[string]$Theme)

    $Profile = Repair-HolocronProfile -Profile $Profile

    Write-CyberHeader -Title "$($Lesson.Rank): $($Lesson.Title)" -Subtitle "Training walkthrough, $($Lesson.Skill)" -Theme $Theme

    Write-Host "OBJECTIVE:" -ForegroundColor Yellow
    Write-Host "Understand the command, practice it, then pass a checkpoint before XP is awarded." -ForegroundColor White
    Write-Host ""

    Write-Host "CONCEPT:" -ForegroundColor Cyan
    Write-Host $Lesson.Concept -ForegroundColor White
    Write-Host ""

    Write-Host "COMMAND:" -ForegroundColor Green
    Write-Host $Lesson.Command -ForegroundColor White
    Write-Host ""

    Write-Host "BREAKDOWN:" -ForegroundColor Cyan
    foreach ($line in $Lesson.Breakdown) { Write-Host " - $line" -ForegroundColor White }

    Write-Host ""
    Write-Host "EXAMPLE:" -ForegroundColor Yellow
    Write-Host $Lesson.ExampleCommand -ForegroundColor White

    Write-Host ""
    Write-Host "EXPECTED OUTPUT:" -ForegroundColor Yellow
    Write-Host $Lesson.ExampleOutput -ForegroundColor DarkGray

    Write-Host ""
    Write-Host "PRACTICE TASK:" -ForegroundColor Green
    foreach ($step in $Lesson.Practice) { Write-Host " - $step" -ForegroundColor White }

    $Profile = Start-HolocronCheckpoint -Profile $Profile -Lesson $Lesson -Track $Track
    return $Profile
}

function Start-HolocronPath {
    param([object]$Profile,[string]$Track)

    $Profile = Repair-HolocronProfile -Profile $Profile

    $lessons = if ($Track -eq "Linux") { $Global:LinuxHolocronLessons } else { $Global:PowerShellHolocronLessons }
    $theme = if ($Track -eq "Linux") { "Light" } else { "Shadow" }
    $title = if ($Track -eq "Linux") { "LINUX JEDI PATH" } else { "POWERSHELL SITH PATH" }

    while ($true) {
        Write-CyberHeader -Title $title -Subtitle "10 lessons, each with a 10-question checkpoint" -Theme $theme

        for ($i = 0; $i -lt $lessons.Count; $i++) {
            $num = $i + 1
            $lesson = $lessons[$i]
            $status = if ($Profile.CompletedMissions -contains $lesson.ID) { "DONE" } else { "OPEN" }
            Write-Host "[$num] [$status] $($lesson.Rank): $($lesson.Title) | $($lesson.Skill) | +$($lesson.XP) XP" -ForegroundColor Cyan
        }

        Write-Host ""
        Write-Host "[B] Back" -ForegroundColor DarkGray
        Write-Host ""

        $choice = Read-Menu -Prompt "Lesson"

        if ([string]::IsNullOrWhiteSpace($choice)) { continue }
        if ($choice -match '^[Bb]$') { return $Profile }

        if ($choice -match '^\d+$') {
            $index = [int]$choice - 1
            if ($index -ge 0 -and $index -lt $lessons.Count) {
                $Profile = Show-HolocronLesson -Profile $Profile -Lesson $lessons[$index] -Track $Track -Theme $theme
            }
        }
    }
}

function Show-JediArchives {
    Write-CyberHeader -Title "JEDI ARCHIVES" -Subtitle "Command reference, no fluff" -Theme "Neutral"

    Write-Host "LINUX" -ForegroundColor Green
    Write-Host " pwd             Show current directory"
    Write-Host " ls -la          List all files with details"
    Write-Host " cd              Change directory"
    Write-Host " mkdir           Create folder"
    Write-Host " touch           Create file"
    Write-Host " cat             Read file"
    Write-Host " grep -R         Search inside files recursively"
    Write-Host " find            Find files"
    Write-Host " chmod           Change permissions"
    Write-Host " ps aux          Show processes"
    Write-Host " ip a            Show IP addresses"
    Write-Host " ss -tulnp       Show listening ports"
    Write-Host ""

    Write-Host "POWERSHELL" -ForegroundColor Cyan
    Write-Host " Get-Help             Learn a command"
    Write-Host " Get-Command          List commands"
    Write-Host " Get-Location         Show current path"
    Write-Host " Set-Location         Change path"
    Write-Host " Get-ChildItem        List files"
    Write-Host " New-Item             Create file or folder"
    Write-Host " Get-Content          Read file"
    Write-Host " Set-Content          Write file"
    Write-Host " Get-Process          Show processes"
    Write-Host " Get-Service          Show services"
    Write-Host " Get-WinEvent         Read Windows logs"
    Write-Host " Get-NetTCPConnection Show TCP connections"
    Write-Host ""

    Pause-Game
}

function Show-HolocronAcademy {
    param([object]$Profile)

    $Profile = Repair-HolocronProfile -Profile $Profile

    while ($true) {
        Write-CyberHeader -Title "HOLOCRON ACADEMY" -Subtitle "Learn, practice, checkpoint, then earn XP" -Theme "Neutral"

        Write-BoxLine
        Write-BoxText -Text "STRUCTURED WALKTHROUGH TRAINING" -Color Yellow
        Write-BoxText -Text "[1] Linux Jedi Path, 10 lessons"
        Write-BoxText -Text "[2] PowerShell Sith Path, 10 lessons"
        Write-BoxText -Text "[3] Jedi Archives, command reference"
        Write-BoxText -Text "[B] Back"
        Write-BoxEnd
        Write-Host ""

        $choice = Read-Menu -Prompt "Choose"

        if ([string]::IsNullOrWhiteSpace($choice)) { continue }

        switch ($choice) {
            "1" { $Profile = Start-HolocronPath -Profile $Profile -Track "Linux" }
            "2" { $Profile = Start-HolocronPath -Profile $Profile -Track "PowerShell" }
            "3" { Show-JediArchives }
            "B" { return $Profile }
            "b" { return $Profile }
            default {
                Write-Host "Invalid selection." -ForegroundColor Red
                Start-Sleep -Seconds 1
            }
        }
    }
}
