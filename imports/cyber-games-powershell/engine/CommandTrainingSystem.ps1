# CommandTrainingSystem.ps1
# PowerShell and Linux CLI training system for CyberShell: Terminal Ops

$Global:PowerShellCommands = @(
    [ordered]@{
        Name        = "Get-Location"
        Alias       = "pwd"
        Category    = "Navigation"
        Syntax      = "Get-Location"
        Example     = "Get-Location"
        Explanation = "Shows the current folder path."
        Practice    = "Type the command that shows your current folder location."
        Answer      = "Get-Location"
        SimOutput   = "Path`n----`nC:\CyberGames\Training"
    },
    [ordered]@{
        Name        = "Set-Location"
        Alias       = "cd"
        Category    = "Navigation"
        Syntax      = "Set-Location <path>"
        Example     = "Set-Location C:\Dev"
        Explanation = "Changes your current folder."
        Practice    = "Type the command to move into C:\Dev."
        Answer      = "Set-Location C:\Dev"
        SimOutput   = "Current location changed to C:\Dev"
    },
    [ordered]@{
        Name        = "Get-ChildItem"
        Alias       = "ls, dir"
        Category    = "Files"
        Syntax      = "Get-ChildItem"
        Example     = "Get-ChildItem"
        Explanation = "Lists files and folders."
        Practice    = "Type the command that lists files and folders."
        Answer      = "Get-ChildItem"
        SimOutput   = "Mode   Name`n----   ----`nd----  logs`nd----  tools`n-a---  report.txt"
    },
    [ordered]@{
        Name        = "New-Item"
        Alias       = "ni"
        Category    = "Files"
        Syntax      = "New-Item -Path <path> -ItemType <type>"
        Example     = "New-Item -Path .\notes.txt -ItemType File"
        Explanation = "Creates a new file or folder."
        Practice    = "Type the command to create a file named notes.txt."
        Answer      = "New-Item -Path .\notes.txt -ItemType File"
        SimOutput   = "notes.txt created."
    },
    [ordered]@{
        Name        = "Copy-Item"
        Alias       = "copy, cp"
        Category    = "Files"
        Syntax      = "Copy-Item <source> <destination>"
        Example     = "Copy-Item .\notes.txt .\backup\notes.txt"
        Explanation = "Copies a file or folder."
        Practice    = "Type the command to copy notes.txt into the backup folder."
        Answer      = "Copy-Item .\notes.txt .\backup\notes.txt"
        SimOutput   = "notes.txt copied to .\backup\notes.txt"
    },
    [ordered]@{
        Name        = "Move-Item"
        Alias       = "move, mv"
        Category    = "Files"
        Syntax      = "Move-Item <source> <destination>"
        Example     = "Move-Item .\old.txt .\archive\old.txt"
        Explanation = "Moves a file or folder."
        Practice    = "Type the command to move old.txt into the archive folder."
        Answer      = "Move-Item .\old.txt .\archive\old.txt"
        SimOutput   = "old.txt moved to .\archive\old.txt"
    },
    [ordered]@{
        Name        = "Remove-Item"
        Alias       = "del, rm"
        Category    = "Files"
        Syntax      = "Remove-Item <path>"
        Example     = "Remove-Item .\temp.txt"
        Explanation = "Deletes a file or folder. In this game it is simulated only."
        Practice    = "Type the command to delete temp.txt."
        Answer      = "Remove-Item .\temp.txt"
        SimOutput   = "temp.txt removed in simulation only."
    },
    [ordered]@{
        Name        = "Get-Content"
        Alias       = "cat, type"
        Category    = "Files"
        Syntax      = "Get-Content <file>"
        Example     = "Get-Content .\log.txt"
        Explanation = "Displays the contents of a text file."
        Practice    = "Type the command to read log.txt."
        Answer      = "Get-Content .\log.txt"
        SimOutput   = "[INFO] Service started`n[WARN] Failed login detected"
    },
    [ordered]@{
        Name        = "Select-String"
        Alias       = "sls"
        Category    = "Search"
        Syntax      = "Select-String -Path <file> -Pattern <text>"
        Example     = "Select-String -Path .\log.txt -Pattern failed"
        Explanation = "Searches text inside files."
        Practice    = "Type the command to search log.txt for failed."
        Answer      = "Select-String -Path .\log.txt -Pattern failed"
        SimOutput   = "log.txt:2:[WARN] Failed login detected"
    },
    [ordered]@{
        Name        = "Get-Process"
        Alias       = "ps"
        Category    = "System"
        Syntax      = "Get-Process"
        Example     = "Get-Process"
        Explanation = "Shows running processes."
        Practice    = "Type the command that shows running processes."
        Answer      = "Get-Process"
        SimOutput   = "ProcessName   Id   CPU`n-----------   --   ---`nchrome      4421  18.2`npwsh        7001  2.1"
    },
    [ordered]@{
        Name        = "Stop-Process"
        Alias       = "kill"
        Category    = "System"
        Syntax      = "Stop-Process -Name <name>"
        Example     = "Stop-Process -Name notepad"
        Explanation = "Stops a running process by name or ID."
        Practice    = "Type the command to stop notepad by name."
        Answer      = "Stop-Process -Name notepad"
        SimOutput   = "notepad stopped in simulation only."
    },
    [ordered]@{
        Name        = "Get-Service"
        Alias       = "gsv"
        Category    = "Services"
        Syntax      = "Get-Service"
        Example     = "Get-Service"
        Explanation = "Shows Windows services and their status."
        Practice    = "Type the command that lists services."
        Answer      = "Get-Service"
        SimOutput   = "Status   Name        DisplayName`n------   ----        -----------`nRunning  WinDefend   Microsoft Defender Antivirus Service"
    },
    [ordered]@{
        Name        = "Start-Service"
        Alias       = "sasv"
        Category    = "Services"
        Syntax      = "Start-Service -Name <service>"
        Example     = "Start-Service -Name WinDefend"
        Explanation = "Starts a stopped Windows service."
        Practice    = "Type the command to start WinDefend."
        Answer      = "Start-Service -Name WinDefend"
        SimOutput   = "WinDefend started in simulation."
    },
    [ordered]@{
        Name        = "Stop-Service"
        Alias       = "spsv"
        Category    = "Services"
        Syntax      = "Stop-Service -Name <service>"
        Example     = "Stop-Service -Name Spooler"
        Explanation = "Stops a Windows service."
        Practice    = "Type the command to stop Spooler."
        Answer      = "Stop-Service -Name Spooler"
        SimOutput   = "Spooler stopped in simulation."
    },
    [ordered]@{
        Name        = "Restart-Service"
        Alias       = ""
        Category    = "Services"
        Syntax      = "Restart-Service -Name <service>"
        Example     = "Restart-Service -Name Spooler"
        Explanation = "Restarts a Windows service."
        Practice    = "Type the command to restart Spooler."
        Answer      = "Restart-Service -Name Spooler"
        SimOutput   = "Spooler restarted in simulation."
    },
    [ordered]@{
        Name        = "Get-NetIPAddress"
        Alias       = ""
        Category    = "Networking"
        Syntax      = "Get-NetIPAddress"
        Example     = "Get-NetIPAddress"
        Explanation = "Shows IP address information on Windows."
        Practice    = "Type the command that shows IP address information."
        Answer      = "Get-NetIPAddress"
        SimOutput   = "IPAddress      InterfaceAlias`n---------      --------------`n192.168.1.25   Ethernet"
    },
    [ordered]@{
        Name        = "Test-NetConnection"
        Alias       = "tnc"
        Category    = "Networking"
        Syntax      = "Test-NetConnection <host> -Port <port>"
        Example     = "Test-NetConnection 192.168.1.1 -Port 443"
        Explanation = "Tests network connectivity to a host and optional port."
        Practice    = "Type the command to test 192.168.1.1 on port 443."
        Answer      = "Test-NetConnection 192.168.1.1 -Port 443"
        SimOutput   = "ComputerName: 192.168.1.1`nRemotePort: 443`nTcpTestSucceeded: True"
    },
    [ordered]@{
        Name        = "Get-Command"
        Alias       = "gcm"
        Category    = "Discovery"
        Syntax      = "Get-Command <name>"
        Example     = "Get-Command Get-Process"
        Explanation = "Finds commands available in PowerShell."
        Practice    = "Type the command to find Get-Process."
        Answer      = "Get-Command Get-Process"
        SimOutput   = "CommandType Name        Version Source`n----------- ----        ------- ------`nCmdlet      Get-Process 7.0.0   Microsoft.PowerShell.Management"
    },
    [ordered]@{
        Name        = "Get-Help"
        Alias       = "help, man"
        Category    = "Discovery"
        Syntax      = "Get-Help <command>"
        Example     = "Get-Help Get-Process"
        Explanation = "Shows help information for a command."
        Practice    = "Type the command to get help for Get-Service."
        Answer      = "Get-Help Get-Service"
        SimOutput   = "NAME`n    Get-Service`nSYNOPSIS`n    Gets services on a local or remote computer."
    },
    [ordered]@{
        Name        = "Get-FileHash"
        Alias       = ""
        Category    = "Security"
        Syntax      = "Get-FileHash <file>"
        Example     = "Get-FileHash .\tool.exe"
        Explanation = "Calculates a file hash."
        Practice    = "Type the command to get the hash of tool.exe."
        Answer      = "Get-FileHash .\tool.exe"
        SimOutput   = "Algorithm Hash                             Path`n--------- ----                             ----`nSHA256    A1B2C3D4E5F6...                  tool.exe"
    }
)

$Global:LinuxCommands = @(
    [ordered]@{
        Name        = "pwd"
        Category    = "Navigation"
        Syntax      = "pwd"
        Example     = "pwd"
        Explanation = "Prints the current working directory."
        Practice    = "Type the command that shows your current directory."
        Answer      = "pwd"
        SimOutput   = "/home/operator/training"
    },
    [ordered]@{
        Name        = "ls"
        Category    = "Files"
        Syntax      = "ls"
        Example     = "ls -la"
        Explanation = "Lists files and directories."
        Practice    = "Type the command to list all files with details."
        Answer      = "ls -la"
        SimOutput   = "drwxr-xr-x  logs`n-rw-r--r--  notes.txt`n-rw-r--r--  scan.txt"
    },
    [ordered]@{
        Name        = "cd"
        Category    = "Navigation"
        Syntax      = "cd <directory>"
        Example     = "cd /var/log"
        Explanation = "Changes the current directory."
        Practice    = "Type the command to move into /var/log."
        Answer      = "cd /var/log"
        SimOutput   = "Current directory changed to /var/log"
    },
    [ordered]@{
        Name        = "cat"
        Category    = "Files"
        Syntax      = "cat <file>"
        Example     = "cat auth.log"
        Explanation = "Displays the contents of a text file."
        Practice    = "Type the command to read auth.log."
        Answer      = "cat auth.log"
        SimOutput   = "sshd: Failed password for root`nsshd: Accepted password for operator"
    },
    [ordered]@{
        Name        = "touch"
        Category    = "Files"
        Syntax      = "touch <file>"
        Example     = "touch notes.txt"
        Explanation = "Creates an empty file or updates its timestamp."
        Practice    = "Type the command to create notes.txt."
        Answer      = "touch notes.txt"
        SimOutput   = "notes.txt created."
    },
    [ordered]@{
        Name        = "mkdir"
        Category    = "Files"
        Syntax      = "mkdir <directory>"
        Example     = "mkdir reports"
        Explanation = "Creates a directory."
        Practice    = "Type the command to create a folder named reports."
        Answer      = "mkdir reports"
        SimOutput   = "reports directory created."
    },
    [ordered]@{
        Name        = "cp"
        Category    = "Files"
        Syntax      = "cp <source> <destination>"
        Example     = "cp notes.txt backup.txt"
        Explanation = "Copies files or directories."
        Practice    = "Type the command to copy notes.txt to backup.txt."
        Answer      = "cp notes.txt backup.txt"
        SimOutput   = "notes.txt copied to backup.txt"
    },
    [ordered]@{
        Name        = "mv"
        Category    = "Files"
        Syntax      = "mv <source> <destination>"
        Example     = "mv old.txt archive/old.txt"
        Explanation = "Moves or renames files and directories."
        Practice    = "Type the command to move old.txt into archive/old.txt."
        Answer      = "mv old.txt archive/old.txt"
        SimOutput   = "old.txt moved to archive/old.txt"
    },
    [ordered]@{
        Name        = "rm"
        Category    = "Files"
        Syntax      = "rm <file>"
        Example     = "rm temp.txt"
        Explanation = "Deletes files. In this game it is simulated only."
        Practice    = "Type the command to remove temp.txt."
        Answer      = "rm temp.txt"
        SimOutput   = "temp.txt removed in simulation only."
    },
    [ordered]@{
        Name        = "grep"
        Category    = "Search"
        Syntax      = "grep <pattern> <file>"
        Example     = "grep failed auth.log"
        Explanation = "Searches for matching text in files."
        Practice    = "Type the command to search auth.log for failed."
        Answer      = "grep failed auth.log"
        SimOutput   = "auth.log:sshd: Failed password for root"
    },
    [ordered]@{
        Name        = "find"
        Category    = "Search"
        Syntax      = "find <path> -name <pattern>"
        Example     = "find /var/log -name *.log"
        Explanation = "Searches for files and directories."
        Practice    = "Type the command to find files named *.log under /var/log."
        Answer      = "find /var/log -name *.log"
        SimOutput   = "/var/log/auth.log`n/var/log/syslog"
    },
    [ordered]@{
        Name        = "chmod"
        Category    = "Permissions"
        Syntax      = "chmod <mode> <file>"
        Example     = "chmod 755 script.sh"
        Explanation = "Changes file permissions."
        Practice    = "Type the command to set script.sh to 755."
        Answer      = "chmod 755 script.sh"
        SimOutput   = "Permissions for script.sh changed to 755."
    },
    [ordered]@{
        Name        = "chown"
        Category    = "Permissions"
        Syntax      = "chown <user>:<group> <file>"
        Example     = "chown operator:operator notes.txt"
        Explanation = "Changes file ownership."
        Practice    = "Type the command to make operator own notes.txt."
        Answer      = "chown operator:operator notes.txt"
        SimOutput   = "Owner of notes.txt changed to operator:operator."
    },
    [ordered]@{
        Name        = "ps"
        Category    = "Processes"
        Syntax      = "ps aux"
        Example     = "ps aux"
        Explanation = "Shows running processes."
        Practice    = "Type the command to show all running processes."
        Answer      = "ps aux"
        SimOutput   = "root       1  systemd`noperator 921 bash`noperator 944 sshd"
    },
    [ordered]@{
        Name        = "kill"
        Category    = "Processes"
        Syntax      = "kill <pid>"
        Example     = "kill 944"
        Explanation = "Sends a signal to stop a process by process ID."
        Practice    = "Type the command to kill process ID 944."
        Answer      = "kill 944"
        SimOutput   = "Process 944 stopped in simulation."
    },
    [ordered]@{
        Name        = "ip"
        Category    = "Networking"
        Syntax      = "ip a"
        Example     = "ip a"
        Explanation = "Shows network interface and IP address information."
        Practice    = "Type the command to show IP addresses."
        Answer      = "ip a"
        SimOutput   = "eth0: inet 192.168.1.50/24`nlo: inet 127.0.0.1/8"
    },
    [ordered]@{
        Name        = "ping"
        Category    = "Networking"
        Syntax      = "ping <host>"
        Example     = "ping 8.8.8.8"
        Explanation = "Tests network reachability."
        Practice    = "Type the command to ping 8.8.8.8."
        Answer      = "ping 8.8.8.8"
        SimOutput   = "64 bytes from 8.8.8.8: icmp_seq=1 ttl=117 time=12 ms"
    },
    [ordered]@{
        Name        = "ss"
        Category    = "Networking"
        Syntax      = "ss -tuln"
        Example     = "ss -tuln"
        Explanation = "Shows listening TCP and UDP ports."
        Practice    = "Type the command to show listening TCP/UDP ports."
        Answer      = "ss -tuln"
        SimOutput   = "tcp LISTEN 0.0.0.0:22`ntcp LISTEN 0.0.0.0:80"
    },
    [ordered]@{
        Name        = "systemctl"
        Category    = "Services"
        Syntax      = "systemctl status <service>"
        Example     = "systemctl status ssh"
        Explanation = "Checks the status of a Linux service."
        Practice    = "Type the command to check the ssh service."
        Answer      = "systemctl status ssh"
        SimOutput   = "ssh.service - OpenBSD Secure Shell server`nActive: active running"
    },
    [ordered]@{
        Name        = "journalctl"
        Category    = "Logs"
        Syntax      = "journalctl -u <service>"
        Example     = "journalctl -u ssh"
        Explanation = "Views systemd logs for a service."
        Practice    = "Type the command to view ssh service logs."
        Answer      = "journalctl -u ssh"
        SimOutput   = "Started OpenBSD Secure Shell server.`nAccepted password for operator."
    }
)

function Show-CLITrainingMenu {
    while ($true) {
        Show-SectionHeader "CLI Training Grounds"

        Write-Host "Train inside a safe simulated terminal." -ForegroundColor DarkGray
        Write-Host ""
        Write-Host "1. PowerShell Practice"
        Write-Host "2. Linux Practice"
        Write-Host "3. PowerShell Command Library"
        Write-Host "4. Linux Command Library"
        Write-Host "5. Random Command Drill"
        Write-Host "6. Free Practice Sandbox"
        Write-Host "7. Return to Main Menu"
        Write-Host ""

        $choice = Read-Host "Select an option"

        switch ($choice) {
            "1" { Start-CommandPractice -ShellType "PowerShell" }
            "2" { Start-CommandPractice -ShellType "Linux" }
            "3" { Show-CommandLibrary -ShellType "PowerShell" }
            "4" { Show-CommandLibrary -ShellType "Linux" }
            "5" { Start-RandomCommandDrill }
            "6" { Start-FreePracticeSandbox }
            "7" { return }
            default {
                Write-Host ""
                Write-Host "Invalid selection. Even the command line deserves better." -ForegroundColor Red
                Pause-Game
            }
        }
    }
}

function Get-CommandSet {
    param (
        [string]$ShellType
    )

    if ($ShellType -eq "PowerShell") {
        return $Global:PowerShellCommands
    }

    return $Global:LinuxCommands
}

function Normalize-CommandAnswer {
    param (
        [string]$Text
    )

    return ($Text.Trim() -replace "\s+", " ").ToLower()
}

function Start-CommandPractice {
    param (
        [string]$ShellType
    )

    $commands = Get-CommandSet -ShellType $ShellType

    while ($true) {
        Show-SectionHeader "$ShellType Practice"

        Write-Host "Choose a category:" -ForegroundColor Cyan
        Write-Host ""

        $categories = $commands | ForEach-Object { $_.Category } | Sort-Object -Unique

        for ($i = 0; $i -lt $categories.Count; $i++) {
            $number = $i + 1
            Write-Host "$number. $($categories[$i])"
        }

        $exitNumber = $categories.Count + 1
        Write-Host "$exitNumber. Return"
        Write-Host ""

        $choice = Read-Host "Select a category"

        if ($choice -eq "$exitNumber") {
            return
        }

        if (-not ($choice -as [int]) -or [int]$choice -lt 1 -or [int]$choice -gt $categories.Count) {
            Write-Host "Invalid category." -ForegroundColor Red
            Pause-Game
            continue
        }

        $selectedCategory = $categories[[int]$choice - 1]
        $categoryCommands = @($commands | Where-Object { $_.Category -eq $selectedCategory })

        Start-CategoryPractice -ShellType $ShellType -Category $selectedCategory -Commands $categoryCommands
    }
}

function Start-CategoryPractice {
    param (
        [string]$ShellType,
        [string]$Category,
        [array]$Commands
    )

    foreach ($cmd in $Commands) {
        Show-SectionHeader "$ShellType Practice: $Category"

        Write-Host "Command:" -ForegroundColor Cyan
        Write-Host "  $($cmd.Name)" -ForegroundColor White
        Write-Host ""

        if ($ShellType -eq "PowerShell" -and -not [string]::IsNullOrWhiteSpace($cmd.Alias)) {
            Write-Host "Alias:" -ForegroundColor Cyan
            Write-Host "  $($cmd.Alias)" -ForegroundColor White
            Write-Host ""
        }

        Write-Host "Syntax:" -ForegroundColor Cyan
        Write-Host "  $($cmd.Syntax)" -ForegroundColor White
        Write-Host ""

        Write-Host "Example:" -ForegroundColor Cyan
        Write-Host "  $($cmd.Example)" -ForegroundColor Yellow
        Write-Host ""

        Write-Host "Explanation:" -ForegroundColor Cyan
        Write-Host "  $($cmd.Explanation)" -ForegroundColor Gray
        Write-Host ""

        Write-Host "Practice Task:" -ForegroundColor Green
        Write-Host "  $($cmd.Practice)" -ForegroundColor White
        Write-Host ""

        if ($ShellType -eq "PowerShell") {
            $inputCommand = Read-Host "PS CyberLab>"
        }
        else {
            $inputCommand = Read-Host "operator@cyberlab:~$"
        }

        $expected = Normalize-CommandAnswer $cmd.Answer
        $actual = Normalize-CommandAnswer $inputCommand

        if ($actual -eq $expected) {
            Write-Host ""
            Write-Host "Correct command." -ForegroundColor Green
            Write-Host ""
            Write-Host "Simulated Output:" -ForegroundColor Cyan
            Write-Host $cmd.SimOutput -ForegroundColor Gray

            Add-XP 10
            Add-Credits 2
            Save-Player

            if (Get-Command Submit-LeaderboardScore -ErrorAction SilentlyContinue) {
                Submit-LeaderboardScore
            }
        }
        else {
            Write-Host ""
            Write-Host "Not quite." -ForegroundColor Yellow
            Write-Host "Expected:" -ForegroundColor Cyan
            Write-Host "  $($cmd.Answer)" -ForegroundColor White
            Write-Host ""
            Write-Host "What you typed:" -ForegroundColor Cyan
            Write-Host "  $inputCommand" -ForegroundColor White
            Write-Host ""
            Write-Host "The machine forgives you. This time." -ForegroundColor DarkGray
        }

        Pause-Game
    }
}

function Show-CommandLibrary {
    param (
        [string]$ShellType
    )

    $commands = Get-CommandSet -ShellType $ShellType

    while ($true) {
        Show-SectionHeader "$ShellType Command Library"

        Write-Host "Categories:" -ForegroundColor Cyan
        Write-Host ""

        $categories = $commands | ForEach-Object { $_.Category } | Sort-Object -Unique

        for ($i = 0; $i -lt $categories.Count; $i++) {
            $number = $i + 1
            Write-Host "$number. $($categories[$i])"
        }

        $exitNumber = $categories.Count + 1
        Write-Host "$exitNumber. Return"
        Write-Host ""

        $choice = Read-Host "Select a category"

        if ($choice -eq "$exitNumber") {
            return
        }

        if (-not ($choice -as [int]) -or [int]$choice -lt 1 -or [int]$choice -gt $categories.Count) {
            Write-Host "Invalid category." -ForegroundColor Red
            Pause-Game
            continue
        }

        $selectedCategory = $categories[[int]$choice - 1]
        $selectedCommands = @($commands | Where-Object { $_.Category -eq $selectedCategory })

        Show-CommandLibraryCategory -ShellType $ShellType -Category $selectedCategory -Commands $selectedCommands
    }
}

function Show-CommandLibraryCategory {
    param (
        [string]$ShellType,
        [string]$Category,
        [array]$Commands
    )

    Show-SectionHeader "$ShellType Library: $Category"

    foreach ($cmd in $Commands) {
        Write-Host "Command: $($cmd.Name)" -ForegroundColor Green

        if ($ShellType -eq "PowerShell" -and -not [string]::IsNullOrWhiteSpace($cmd.Alias)) {
            Write-Host "Alias:   $($cmd.Alias)" -ForegroundColor DarkGray
        }

        Write-Host "Syntax:  $($cmd.Syntax)" -ForegroundColor Yellow
        Write-Host "Example: $($cmd.Example)" -ForegroundColor White
        Write-Host "Use:     $($cmd.Explanation)" -ForegroundColor Gray
        Write-Host ""
    }

    Pause-Game
}

function Start-RandomCommandDrill {
    Show-SectionHeader "Random Command Drill"

    Write-Host "Choose drill type:" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "1. PowerShell only"
    Write-Host "2. Linux only"
    Write-Host "3. Mixed"
    Write-Host "4. Return"
    Write-Host ""

    $choice = Read-Host "Select an option"

    switch ($choice) {
        "1" {
            $pool = $Global:PowerShellCommands
        }
        "2" {
            $pool = $Global:LinuxCommands
        }
        "3" {
            $pool = @()
            $pool += $Global:PowerShellCommands
            $pool += $Global:LinuxCommands
        }
        "4" {
            return
        }
        default {
            Write-Host "Invalid selection." -ForegroundColor Red
            Pause-Game
            return
        }
    }

    $score = 0
    $rounds = 10

    for ($round = 1; $round -le $rounds; $round++) {
        $cmd = $pool | Get-Random

        Show-SectionHeader "Random Command Drill: Round $round of $rounds"

        Write-Host "Practice Task:" -ForegroundColor Green
        Write-Host "  $($cmd.Practice)" -ForegroundColor White
        Write-Host ""
        Write-Host "Hint Category: $($cmd.Category)" -ForegroundColor DarkGray
        Write-Host ""

        $inputCommand = Read-Host "CyberLab"

        $expected = Normalize-CommandAnswer $cmd.Answer
        $actual = Normalize-CommandAnswer $inputCommand

        if ($actual -eq $expected) {
            Write-Host ""
            Write-Host "Correct." -ForegroundColor Green
            $score++
            Add-XP 15
            Add-Credits 3
        }
        else {
            Write-Host ""
            Write-Host "Incorrect." -ForegroundColor Red
            Write-Host "Expected: $($cmd.Answer)" -ForegroundColor Yellow
        }

        Pause-Game
    }

    Show-SectionHeader "Drill Complete"

    Write-Host "Final Drill Score: $score / $rounds" -ForegroundColor Cyan

    if ($score -eq 10) {
        Write-Host "Perfect drill. The terminal is suspiciously proud." -ForegroundColor Green
        Add-Reputation 10
    }
    elseif ($score -ge 7) {
        Write-Host "Good work. You are building actual CLI muscle memory." -ForegroundColor Green
        Add-Reputation 5
    }
    elseif ($score -ge 4) {
        Write-Host "Passing. Still rough, but less tragic than when we started." -ForegroundColor Yellow
        Add-Reputation 2
    }
    else {
        Write-Host "Needs more practice. The keyboard remains undefeated." -ForegroundColor Red
    }

    Save-Player

    if (Get-Command Submit-LeaderboardScore -ErrorAction SilentlyContinue) {
        Submit-LeaderboardScore
    }

    Pause-Game
}

function Start-FreePracticeSandbox {
    Show-SectionHeader "Free Practice Sandbox"

    Write-Host "Choose sandbox:" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "1. PowerShell Sandbox"
    Write-Host "2. Linux Sandbox"
    Write-Host "3. Return"
    Write-Host ""

    $choice = Read-Host "Select an option"

    switch ($choice) {
        "1" {
            Start-SimulatedShell -ShellType "PowerShell"
        }
        "2" {
            Start-SimulatedShell -ShellType "Linux"
        }
        "3" {
            return
        }
        default {
            Write-Host "Invalid selection." -ForegroundColor Red
            Pause-Game
        }
    }
}

function Start-SimulatedShell {
    param (
        [string]$ShellType
    )

    $commands = Get-CommandSet -ShellType $ShellType

    Show-SectionHeader "$ShellType Free Practice Sandbox"

    Write-Host "Type commands from the library." -ForegroundColor Gray
    Write-Host "Type help to see supported commands." -ForegroundColor Gray
    Write-Host "Type exit to leave the sandbox." -ForegroundColor Gray
    Write-Host ""

    while ($true) {
        if ($ShellType -eq "PowerShell") {
            $inputCommand = Read-Host "PS CyberLab>"
        }
        else {
            $inputCommand = Read-Host "operator@cyberlab:~$"
        }

        $normalizedInput = Normalize-CommandAnswer $inputCommand

        if ($normalizedInput -eq "exit") {
            return
        }

        if ($normalizedInput -eq "help") {
            Write-Host ""
            Write-Host "Supported commands:" -ForegroundColor Cyan

            foreach ($cmd in $commands) {
                Write-Host " - $($cmd.Answer)" -ForegroundColor Gray
            }

            Write-Host ""
            continue
        }

        if ($normalizedInput -eq "clear") {
            Show-SectionHeader "$ShellType Free Practice Sandbox"
            continue
        }

        $match = $commands | Where-Object {
            (Normalize-CommandAnswer $_.Answer) -eq $normalizedInput -or
            (Normalize-CommandAnswer $_.Name) -eq $normalizedInput
        } | Select-Object -First 1

        if ($null -ne $match) {
            Write-Host ""
            Write-Host $match.SimOutput -ForegroundColor Gray
            Write-Host ""

            Add-XP 5
            Save-Player
        }
        else {
            Write-Host ""
            Write-Host "Command not recognized in this simulator." -ForegroundColor Yellow
            Write-Host "Type help to see supported commands." -ForegroundColor DarkGray
            Write-Host ""
        }
    }
}