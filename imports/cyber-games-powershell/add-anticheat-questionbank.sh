#!/usr/bin/env bash

set -e

echo "========================================"
echo " CYBERSHELL QUESTION BANK PATCH"
echo " Randomized questions + harder trials"
echo "========================================"

mkdir -p engine backups
BACKUP_DIR="backups/questionbank-backup-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$BACKUP_DIR"

echo "[1] Backing up files..."
cp Start-CyberShell.ps1 "$BACKUP_DIR/" 2>/dev/null || true
cp engine/GameSystems.ps1 "$BACKUP_DIR/" 2>/dev/null || true
cp engine/QuestionBank.ps1 "$BACKUP_DIR/" 2>/dev/null || true

echo "[2] Creating engine/QuestionBank.ps1..."
cat > engine/QuestionBank.ps1 <<'PS1'
$Global:QuestionBank = @(
    # =========================
    # WINDOWS BEGINNER
    # =========================
    [PSCustomObject]@{
        ID="QB-WIN-BEG-001"; Track="Windows"; Difficulty="Beginner"; Skill="Recon";
        Prompt="What command shows the current logged-in user?";
        Answers=@("whoami");
        Hint="It starts with who."
    },
    [PSCustomObject]@{
        ID="QB-WIN-BEG-002"; Track="Windows"; Difficulty="Beginner"; Skill="System";
        Prompt="What command shows the computer name in Command Prompt or PowerShell?";
        Answers=@("hostname");
        Hint="It literally asks for the host name."
    },
    [PSCustomObject]@{
        ID="QB-WIN-BEG-003"; Track="Windows"; Difficulty="Beginner"; Skill="Files";
        Prompt="What PowerShell command lists files and folders?";
        Answers=@("get-childitem","gci","dir","ls");
        Hint="PowerShell uses Get-ChildItem."
    },
    [PSCustomObject]@{
        ID="QB-WIN-BEG-004"; Track="Windows"; Difficulty="Beginner"; Skill="Location";
        Prompt="What PowerShell command shows your current directory?";
        Answers=@("get-location","pwd","gl");
        Hint="Get your current location."
    },
    [PSCustomObject]@{
        ID="QB-WIN-BEG-005"; Track="Windows"; Difficulty="Beginner"; Skill="Files";
        Prompt="What PowerShell command creates a new folder named test?";
        Answers=@("new-item -itemtype directory test","mkdir test","md test");
        Hint="mkdir still works."
    },
    [PSCustomObject]@{
        ID="QB-WIN-BEG-006"; Track="Windows"; Difficulty="Beginner"; Skill="Files";
        Prompt="What PowerShell command reads a text file named notes.txt?";
        Answers=@("get-content notes.txt","cat notes.txt","type notes.txt");
        Hint="Get the content."
    },
    [PSCustomObject]@{
        ID="QB-WIN-BEG-007"; Track="Windows"; Difficulty="Beginner"; Skill="Help";
        Prompt="What PowerShell command gives help for Get-Process?";
        Answers=@("get-help get-process","help get-process");
        Hint="Get help."
    },
    [PSCustomObject]@{
        ID="QB-WIN-BEG-008"; Track="Windows"; Difficulty="Beginner"; Skill="Clear";
        Prompt="What command clears the PowerShell screen?";
        Answers=@("clear-host","cls","clear");
        Hint="Clear the host."
    },
    [PSCustomObject]@{
        ID="QB-WIN-BEG-009"; Track="Windows"; Difficulty="Beginner"; Skill="Version";
        Prompt="What PowerShell variable shows version information?";
        Answers=@("$psversiontable","$PSVersionTable");
        Hint="It starts with dollar sign PS."
    },
    [PSCustomObject]@{
        ID="QB-WIN-BEG-010"; Track="Windows"; Difficulty="Beginner"; Skill="Commands";
        Prompt="What PowerShell command lists available commands?";
        Answers=@("get-command","gcm");
        Hint="Get command."
    },

    # =========================
    # WINDOWS INTERMEDIATE
    # =========================
    [PSCustomObject]@{
        ID="QB-WIN-INT-001"; Track="Windows"; Difficulty="Intermediate"; Skill="Processes";
        Prompt="What PowerShell command lists running processes?";
        Answers=@("get-process","gps");
        Hint="Get the processes."
    },
    [PSCustomObject]@{
        ID="QB-WIN-INT-002"; Track="Windows"; Difficulty="Intermediate"; Skill="Services";
        Prompt="What PowerShell command lists Windows services?";
        Answers=@("get-service","gsv");
        Hint="Get services."
    },
    [PSCustomObject]@{
        ID="QB-WIN-INT-003"; Track="Windows"; Difficulty="Intermediate"; Skill="Networking";
        Prompt="What classic Windows command shows IP configuration?";
        Answers=@("ipconfig","ipconfig /all");
        Hint="IP config."
    },
    [PSCustomObject]@{
        ID="QB-WIN-INT-004"; Track="Windows"; Difficulty="Intermediate"; Skill="Networking";
        Prompt="What command tests connectivity to 8.8.8.8?";
        Answers=@("ping 8.8.8.8");
        Hint="Ping the address."
    },
    [PSCustomObject]@{
        ID="QB-WIN-INT-005"; Track="Windows"; Difficulty="Intermediate"; Skill="Networking";
        Prompt="What command shows active network connections and listening ports?";
        Answers=@("netstat -ano","netstat");
        Hint="Net statistics."
    },
    [PSCustomObject]@{
        ID="QB-WIN-INT-006"; Track="Windows"; Difficulty="Intermediate"; Skill="Users";
        Prompt="What classic command lists local users?";
        Answers=@("net user");
        Hint="Net user."
    },
    [PSCustomObject]@{
        ID="QB-WIN-INT-007"; Track="Windows"; Difficulty="Intermediate"; Skill="Tasks";
        Prompt="What classic command lists running tasks?";
        Answers=@("tasklist");
        Hint="Task list."
    },
    [PSCustomObject]@{
        ID="QB-WIN-INT-008"; Track="Windows"; Difficulty="Intermediate"; Skill="Tasks";
        Prompt="What classic command kills a process by PID 1234?";
        Answers=@("taskkill /pid 1234","taskkill /pid 1234 /f");
        Hint="Task kill by PID."
    },
    [PSCustomObject]@{
        ID="QB-WIN-INT-009"; Track="Windows"; Difficulty="Intermediate"; Skill="DNS";
        Prompt="What command queries DNS records for example.com?";
        Answers=@("nslookup example.com","resolve-dnsname example.com");
        Hint="Name server lookup."
    },
    [PSCustomObject]@{
        ID="QB-WIN-INT-010"; Track="Windows"; Difficulty="Intermediate"; Skill="Filtering";
        Prompt="What PowerShell command filters processes for chrome?";
        Answers=@("get-process chrome","gps chrome");
        Hint="Get-Process can take a process name."
    },

    # =========================
    # WINDOWS ADVANCED
    # =========================
    [PSCustomObject]@{
        ID="QB-WIN-ADV-001"; Track="Windows"; Difficulty="Advanced"; Skill="Logs";
        Prompt="What PowerShell command reads modern Windows event logs?";
        Answers=@("get-winevent");
        Hint="Get Windows event."
    },
    [PSCustomObject]@{
        ID="QB-WIN-ADV-002"; Track="Windows"; Difficulty="Advanced"; Skill="Logs";
        Prompt="What older PowerShell command reads classic event logs?";
        Answers=@("get-eventlog");
        Hint="Get event log."
    },
    [PSCustomObject]@{
        ID="QB-WIN-ADV-003"; Track="Windows"; Difficulty="Advanced"; Skill="Hashing";
        Prompt="What PowerShell command gets a file hash for file.txt?";
        Answers=@("get-filehash file.txt");
        Hint="Get file hash."
    },
    [PSCustomObject]@{
        ID="QB-WIN-ADV-004"; Track="Windows"; Difficulty="Advanced"; Skill="Execution";
        Prompt="What PowerShell command shows the current execution policy?";
        Answers=@("get-executionpolicy");
        Hint="Get execution policy."
    },
    [PSCustomObject]@{
        ID="QB-WIN-ADV-005"; Track="Windows"; Difficulty="Advanced"; Skill="Modules";
        Prompt="What PowerShell command lists available modules?";
        Answers=@("get-module -listavailable","get-module -listavailable");
        Hint="Get modules, list available."
    },
    [PSCustomObject]@{
        ID="QB-WIN-ADV-006"; Track="Windows"; Difficulty="Advanced"; Skill="Firewall";
        Prompt="What PowerShell command lists firewall rules?";
        Answers=@("get-netfirewallrule");
        Hint="Get net firewall rule."
    },
    [PSCustomObject]@{
        ID="QB-WIN-ADV-007"; Track="Windows"; Difficulty="Advanced"; Skill="Networking";
        Prompt="What PowerShell command shows IP addresses?";
        Answers=@("get-netipaddress");
        Hint="Get net IP address."
    },
    [PSCustomObject]@{
        ID="QB-WIN-ADV-008"; Track="Windows"; Difficulty="Advanced"; Skill="Networking";
        Prompt="What PowerShell command shows TCP connections?";
        Answers=@("get-nettcpconnection");
        Hint="Get net TCP connection."
    },
    [PSCustomObject]@{
        ID="QB-WIN-ADV-009"; Track="Windows"; Difficulty="Advanced"; Skill="Scripting";
        Prompt="What symbol starts a PowerShell variable?";
        Answers=@("$");
        Hint="Money sign."
    },
    [PSCustomObject]@{
        ID="QB-WIN-ADV-010"; Track="Windows"; Difficulty="Advanced"; Skill="Pipeline";
        Prompt="What PowerShell command sorts objects by CPU?";
        Answers=@("sort-object cpu","sort cpu");
        Hint="Sort objects."
    },

    # =========================
    # LINUX BEGINNER
    # =========================
    [PSCustomObject]@{
        ID="QB-LIN-BEG-001"; Track="Linux"; Difficulty="Beginner"; Skill="Navigation";
        Prompt="What Linux command prints your current directory?";
        Answers=@("pwd");
        Hint="Print working directory."
    },
    [PSCustomObject]@{
        ID="QB-LIN-BEG-002"; Track="Linux"; Difficulty="Beginner"; Skill="Files";
        Prompt="What Linux command lists files?";
        Answers=@("ls","ls -l","ls -la");
        Hint="Two letters."
    },
    [PSCustomObject]@{
        ID="QB-LIN-BEG-003"; Track="Linux"; Difficulty="Beginner"; Skill="Users";
        Prompt="What Linux command shows the current user?";
        Answers=@("whoami","id -un");
        Hint="Same as Windows."
    },
    [PSCustomObject]@{
        ID="QB-LIN-BEG-004"; Track="Linux"; Difficulty="Beginner"; Skill="Files";
        Prompt="What Linux command reads file.txt?";
        Answers=@("cat file.txt");
        Hint="Cat the file."
    },
    [PSCustomObject]@{
        ID="QB-LIN-BEG-005"; Track="Linux"; Difficulty="Beginner"; Skill="Directories";
        Prompt="What Linux command creates a directory named test?";
        Answers=@("mkdir test");
        Hint="Make directory."
    },
    [PSCustomObject]@{
        ID="QB-LIN-BEG-006"; Track="Linux"; Difficulty="Beginner"; Skill="Files";
        Prompt="What Linux command creates an empty file named test.txt?";
        Answers=@("touch test.txt");
        Hint="Touch the file."
    },
    [PSCustomObject]@{
        ID="QB-LIN-BEG-007"; Track="Linux"; Difficulty="Beginner"; Skill="Clear";
        Prompt="What Linux command clears the terminal screen?";
        Answers=@("clear");
        Hint="Clear."
    },
    [PSCustomObject]@{
        ID="QB-LIN-BEG-008"; Track="Linux"; Difficulty="Beginner"; Skill="Help";
        Prompt="What Linux command opens the manual page for ls?";
        Answers=@("man ls");
        Hint="Manual."
    },
    [PSCustomObject]@{
        ID="QB-LIN-BEG-009"; Track="Linux"; Difficulty="Beginner"; Skill="Location";
        Prompt="What symbol represents the current directory in Linux?";
        Answers=@(".");
        Hint="Single dot."
    },
    [PSCustomObject]@{
        ID="QB-LIN-BEG-010"; Track="Linux"; Difficulty="Beginner"; Skill="Location";
        Prompt="What symbol represents the parent directory in Linux?";
        Answers=@("..");
        Hint="Two dots."
    },

    # =========================
    # LINUX INTERMEDIATE
    # =========================
    [PSCustomObject]@{
        ID="QB-LIN-INT-001"; Track="Linux"; Difficulty="Intermediate"; Skill="Processes";
        Prompt="What Linux command shows running processes in detail?";
        Answers=@("ps aux","ps -ef");
        Hint="Process status."
    },
    [PSCustomObject]@{
        ID="QB-LIN-INT-002"; Track="Linux"; Difficulty="Intermediate"; Skill="Processes";
        Prompt="What interactive Linux command shows live process usage?";
        Answers=@("top","htop");
        Hint="Top."
    },
    [PSCustomObject]@{
        ID="QB-LIN-INT-003"; Track="Linux"; Difficulty="Intermediate"; Skill="Permissions";
        Prompt="What command changes file permissions?";
        Answers=@("chmod");
        Hint="Change mode."
    },
    [PSCustomObject]@{
        ID="QB-LIN-INT-004"; Track="Linux"; Difficulty="Intermediate"; Skill="Ownership";
        Prompt="What command changes file ownership?";
        Answers=@("chown");
        Hint="Change owner."
    },
    [PSCustomObject]@{
        ID="QB-LIN-INT-005"; Track="Linux"; Difficulty="Intermediate"; Skill="Networking";
        Prompt="What modern Linux command shows IP addresses?";
        Answers=@("ip a","ip addr","ip address");
        Hint="Modern replacement for ifconfig."
    },
    [PSCustomObject]@{
        ID="QB-LIN-INT-006"; Track="Linux"; Difficulty="Intermediate"; Skill="Networking";
        Prompt="What command shows listening TCP and UDP ports?";
        Answers=@("ss -tulnp","ss -tulpn","netstat -tulnp");
        Hint="Socket statistics."
    },
    [PSCustomObject]@{
        ID="QB-LIN-INT-007"; Track="Linux"; Difficulty="Intermediate"; Skill="Search";
        Prompt="What command searches for text inside files?";
        Answers=@("grep","grep text file.txt");
        Hint="Global regular expression print."
    },
    [PSCustomObject]@{
        ID="QB-LIN-INT-008"; Track="Linux"; Difficulty="Intermediate"; Skill="Find";
        Prompt="What command finds files by name?";
        Answers=@("find","find . -name file.txt");
        Hint="Find."
    },
    [PSCustomObject]@{
        ID="QB-LIN-INT-009"; Track="Linux"; Difficulty="Intermediate"; Skill="Disk";
        Prompt="What command shows disk space usage?";
        Answers=@("df -h","df");
        Hint="Disk free."
    },
    [PSCustomObject]@{
        ID="QB-LIN-INT-010"; Track="Linux"; Difficulty="Intermediate"; Skill="Memory";
        Prompt="What command shows memory usage in human-readable format?";
        Answers=@("free -h","free");
        Hint="Free memory."
    },

    # =========================
    # LINUX ADVANCED
    # =========================
    [PSCustomObject]@{
        ID="QB-LIN-ADV-001"; Track="Linux"; Difficulty="Advanced"; Skill="Logs";
        Prompt="What command reads systemd journal logs?";
        Answers=@("journalctl");
        Hint="Journal control."
    },
    [PSCustomObject]@{
        ID="QB-LIN-ADV-002"; Track="Linux"; Difficulty="Advanced"; Skill="Services";
        Prompt="What command checks the status of ssh service?";
        Answers=@("systemctl status ssh","systemctl status sshd");
        Hint="System control."
    },
    [PSCustomObject]@{
        ID="QB-LIN-ADV-003"; Track="Linux"; Difficulty="Advanced"; Skill="Hashing";
        Prompt="What command calculates a SHA256 hash for file.txt?";
        Answers=@("sha256sum file.txt");
        Hint="SHA256 sum."
    },
    [PSCustomObject]@{
        ID="QB-LIN-ADV-004"; Track="Linux"; Difficulty="Advanced"; Skill="Networking";
        Prompt="What command traces the route to example.com?";
        Answers=@("traceroute example.com","tracepath example.com");
        Hint="Trace route."
    },
    [PSCustomObject]@{
        ID="QB-LIN-ADV-005"; Track="Linux"; Difficulty="Advanced"; Skill="DNS";
        Prompt="What command queries DNS for example.com using dig?";
        Answers=@("dig example.com");
        Hint="Dig."
    },
    [PSCustomObject]@{
        ID="QB-LIN-ADV-006"; Track="Linux"; Difficulty="Advanced"; Skill="Packages";
        Prompt="What Ubuntu command updates package lists?";
        Answers=@("sudo apt update","apt update");
        Hint="APT update."
    },
    [PSCustomObject]@{
        ID="QB-LIN-ADV-007"; Track="Linux"; Difficulty="Advanced"; Skill="Packages";
        Prompt="What Ubuntu command installs git?";
        Answers=@("sudo apt install git","sudo apt install -y git","apt install git");
        Hint="APT install git."
    },
    [PSCustomObject]@{
        ID="QB-LIN-ADV-008"; Track="Linux"; Difficulty="Advanced"; Skill="Scripting";
        Prompt="What characters start a bash script shebang?";
        Answers=@("#!/bin/bash","#!/usr/bin/env bash");
        Hint="Hash bang."
    },
    [PSCustomObject]@{
        ID="QB-LIN-ADV-009"; Track="Linux"; Difficulty="Advanced"; Skill="Archives";
        Prompt="What command extracts archive.tar.gz?";
        Answers=@("tar -xzf archive.tar.gz","tar xzf archive.tar.gz");
        Hint="tar extract gzip file."
    },
    [PSCustomObject]@{
        ID="QB-LIN-ADV-010"; Track="Linux"; Difficulty="Advanced"; Skill="Privileges";
        Prompt="What command runs another command as root?";
        Answers=@("sudo");
        Hint="Superuser do."
    }
)

function Get-RandomQuestions {
    param(
        [string]$Track,
        [int]$Count = 10,
        [string]$Difficulty = ""
    )

    $pool = $Global:QuestionBank | Where-Object { $_.Track -eq $Track }

    if ($Difficulty -ne "") {
        $pool = $pool | Where-Object { $_.Difficulty -eq $Difficulty }
    }

    return $pool | Get-Random -Count ([Math]::Min($Count, @($pool).Count))
}
PS1

echo "[3] Patching Start-CyberShell.ps1 to load QuestionBank..."
python3 - <<'PY'
from pathlib import Path

file = Path("Start-CyberShell.ps1")
text = file.read_text()

line = '. "$PSScriptRoot/engine/QuestionBank.ps1"'

if line not in text:
    text = text.replace(
        '. "$PSScriptRoot/engine/GameSystems.ps1"',
        '. "$PSScriptRoot/engine/QuestionBank.ps1"\n. "$PSScriptRoot/engine/GameSystems.ps1"'
    )

file.write_text(text)
PY

echo "[4] Patching GameSystems.ps1 boss trials + speed round..."
python3 - <<'PY'
from pathlib import Path

file = Path("engine/GameSystems.ps1")
text = file.read_text()

start = text.find("function Start-BossTrial")
end = text.find("function Start-DailyChallenge")

if start == -1 or end == -1:
    raise SystemExit("Could not find Start-BossTrial or Start-DailyChallenge block.")

new_boss = r'''
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

'''

text = text[:start] + new_boss + "\n" + text[end:]
file.write_text(text)
PY

echo "[5] Adding Speed Round menu to Start-CyberShell.ps1..."
python3 - <<'PY'
from pathlib import Path

file = Path("Start-CyberShell.ps1")
text = file.read_text()

text = text.replace(
    'Write-BoxText -Text "[5] Skill Tree            [6] Daily Challenge"',
    'Write-BoxText -Text "[5] Skill Tree            [6] Daily Challenge"'
)

text = text.replace(
    'Write-BoxText -Text "[7] Badges                [8] Leaderboard"',
    'Write-BoxText -Text "[7] Badges                [8] Leaderboard"'
)

if "Speed Round" not in text:
    text = text.replace(
        'Write-BoxText -Text "[9] Switch Profile        [0] Exit and Save"',
        'Write-BoxText -Text "[9] Switch Profile        [S] Speed Round"\n    Write-BoxText -Text "[0] Exit and Save"'
    )

speed_menu = r'''
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

'''

if "function Start-SpeedRoundMenu" not in text:
    text = text.replace("$CurrentProfile = Select-CyberProfile", speed_menu + "\n$CurrentProfile = Select-CyberProfile")

if '"S"' not in text:
    text = text.replace(
        '''"9" {
            $CurrentProfile = Select-CyberProfile
        }''',
        '''"9" {
            $CurrentProfile = Select-CyberProfile
        }
        "S" {
            $CurrentProfile = Start-SpeedRoundMenu -Profile $CurrentProfile
        }
        "s" {
            $CurrentProfile = Start-SpeedRoundMenu -Profile $CurrentProfile
        }'''
    )

file.write_text(text)
PY

echo "[6] Removing answer reveal from mission failure..."
python3 - <<'PY'
from pathlib import Path

file = Path("engine/MissionCatalog.ps1")
text = file.read_text()

text = text.replace(
    'Write-Host "Accepted answers included: $($mission.Answers -join \', \')" -ForegroundColor DarkGray',
    'Write-Host "Review the lesson and try again." -ForegroundColor DarkGray'
)

file.write_text(text)
PY

echo ""
echo "========================================"
echo " PATCH COMPLETE"
echo "========================================"
echo "Test with:"
echo "pwsh -NoProfile -ExecutionPolicy Bypass -File ./Start-CyberShell.ps1"
