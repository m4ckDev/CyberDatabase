#!/usr/bin/env bash

set -e

echo "========================================"
echo " EXPANDING JEDI ARCHIVES"
echo " 100 PowerShell + 100 CMD + 100 Linux"
echo "========================================"

mkdir -p engine data backups
BACKUP_DIR="backups/jedi-archives-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$BACKUP_DIR"

cp Start-CyberShell.ps1 "$BACKUP_DIR/" 2>/dev/null || true
cp engine/HolocronAcademy.ps1 "$BACKUP_DIR/" 2>/dev/null || true
cp engine/JediArchives.ps1 "$BACKUP_DIR/" 2>/dev/null || true
cp data/jedi-archives.json "$BACKUP_DIR/" 2>/dev/null || true

python3 - <<'PY'
import json
from pathlib import Path

archives = []

def add(track, category, command, purpose, example, tier="Beginner"):
    archives.append({
        "Track": track,
        "Category": category,
        "Command": command,
        "Purpose": purpose,
        "Example": example,
        "Tier": tier
    })

powershell = [
("Basics","Get-Help","Shows help for a command","Get-Help Get-Process -Examples"),
("Basics","Get-Command","Lists available commands","Get-Command"),
("Basics","Get-Alias","Shows aliases","Get-Alias"),
("Basics","Get-Host","Shows PowerShell host info","Get-Host"),
("Basics","$PSVersionTable","Shows PowerShell version information","$PSVersionTable"),
("Navigation","Get-Location","Shows current path","Get-Location"),
("Navigation","Set-Location","Changes current path","Set-Location $HOME"),
("Navigation","Push-Location","Saves current path and moves","Push-Location C:\\"),
("Navigation","Pop-Location","Returns to saved path","Pop-Location"),
("Files","Get-ChildItem","Lists files and folders","Get-ChildItem"),
("Files","New-Item","Creates files or folders","New-Item -ItemType Directory -Name Lab"),
("Files","Remove-Item","Deletes files or folders","Remove-Item old.txt"),
("Files","Copy-Item","Copies files or folders","Copy-Item a.txt b.txt"),
("Files","Move-Item","Moves or renames items","Move-Item a.txt archive.txt"),
("Files","Rename-Item","Renames an item","Rename-Item old.txt new.txt"),
("Files","Get-Content","Reads file content","Get-Content notes.txt"),
("Files","Set-Content","Writes file content","Set-Content notes.txt 'hello'"),
("Files","Add-Content","Appends file content","Add-Content notes.txt 'more'"),
("Files","Clear-Content","Clears file contents","Clear-Content notes.txt"),
("Files","Test-Path","Checks if path exists","Test-Path C:\\Windows"),
("Files","Resolve-Path","Resolves a path","Resolve-Path ."),
("Files","Split-Path","Splits path components","Split-Path C:\\Temp\\a.txt"),
("Files","Join-Path","Combines path components","Join-Path C:\\Temp a.txt"),
("Files","Get-Item","Gets a file or folder object","Get-Item .\\notes.txt"),
("Files","Get-ItemProperty","Gets item properties","Get-ItemProperty .\\notes.txt"),
("Processes","Get-Process","Lists running processes","Get-Process"),
("Processes","Stop-Process","Stops a process","Stop-Process -Name notepad"),
("Processes","Start-Process","Starts a process","Start-Process notepad.exe"),
("Processes","Wait-Process","Waits for a process to stop","Wait-Process -Name notepad"),
("Services","Get-Service","Lists services","Get-Service"),
("Services","Start-Service","Starts a service","Start-Service Spooler"),
("Services","Stop-Service","Stops a service","Stop-Service Spooler"),
("Services","Restart-Service","Restarts a service","Restart-Service Spooler"),
("Services","Set-Service","Changes service settings","Set-Service Spooler -StartupType Manual"),
("System","Get-ComputerInfo","Shows computer information","Get-ComputerInfo"),
("System","Get-LocalUser","Lists local users","Get-LocalUser"),
("System","Get-LocalGroup","Lists local groups","Get-LocalGroup"),
("System","Get-LocalGroupMember","Lists local group members","Get-LocalGroupMember Administrators"),
("System","New-LocalUser","Creates local user","New-LocalUser testuser"),
("System","Disable-LocalUser","Disables local user","Disable-LocalUser testuser"),
("System","Enable-LocalUser","Enables local user","Enable-LocalUser testuser"),
("Networking","Get-NetIPAddress","Shows IP addresses","Get-NetIPAddress"),
("Networking","Get-NetAdapter","Shows network adapters","Get-NetAdapter"),
("Networking","Get-NetIPConfiguration","Shows IP configuration","Get-NetIPConfiguration"),
("Networking","Get-NetRoute","Shows routes","Get-NetRoute"),
("Networking","Test-NetConnection","Tests network connection","Test-NetConnection google.com"),
("Networking","Resolve-DnsName","Queries DNS","Resolve-DnsName example.com"),
("Networking","Get-NetTCPConnection","Shows TCP connections","Get-NetTCPConnection"),
("Networking","Get-NetUDPEndpoint","Shows UDP endpoints","Get-NetUDPEndpoint"),
("Firewall","Get-NetFirewallRule","Lists firewall rules","Get-NetFirewallRule"),
("Firewall","Enable-NetFirewallRule","Enables firewall rule","Enable-NetFirewallRule -DisplayName 'Rule'"),
("Firewall","Disable-NetFirewallRule","Disables firewall rule","Disable-NetFirewallRule -DisplayName 'Rule'"),
("Firewall","New-NetFirewallRule","Creates firewall rule","New-NetFirewallRule -DisplayName Test -Direction Inbound -Action Allow"),
("Security","Get-MpComputerStatus","Shows Defender status","Get-MpComputerStatus"),
("Security","Start-MpScan","Starts Defender scan","Start-MpScan -ScanType QuickScan"),
("Security","Update-MpSignature","Updates Defender signatures","Update-MpSignature"),
("Security","Get-MpPreference","Shows Defender preferences","Get-MpPreference"),
("Security","Set-MpPreference","Changes Defender preferences","Set-MpPreference"),
("Security","Get-FileHash","Calculates file hash","Get-FileHash file.txt"),
("Events","Get-WinEvent","Reads Windows event logs","Get-WinEvent -LogName Security -MaxEvents 10"),
("Events","Get-EventLog","Reads classic event logs","Get-EventLog -LogName System -Newest 10"),
("Events","Clear-EventLog","Clears classic event log","Clear-EventLog -LogName Application"),
("Objects","Select-Object","Selects object properties","Get-Process | Select-Object Name,Id"),
("Objects","Where-Object","Filters objects","Get-Process | Where-Object CPU -gt 10"),
("Objects","Sort-Object","Sorts objects","Get-Process | Sort-Object CPU"),
("Objects","Group-Object","Groups objects","Get-Service | Group-Object Status"),
("Objects","Measure-Object","Measures objects","Get-Process | Measure-Object"),
("Objects","ForEach-Object","Runs action for each object","Get-Service | ForEach-Object Name"),
("Output","Out-File","Writes output to file","Get-Process | Out-File proc.txt"),
("Output","Export-Csv","Exports CSV","Get-Process | Export-Csv proc.csv"),
("Output","Import-Csv","Imports CSV","Import-Csv proc.csv"),
("Output","ConvertTo-Json","Converts object to JSON","Get-Process | Select -First 1 | ConvertTo-Json"),
("Output","ConvertFrom-Json","Converts JSON to object","Get-Content data.json | ConvertFrom-Json"),
("Scripting","New-Variable","Creates variable","New-Variable -Name x -Value 1"),
("Scripting","Set-Variable","Sets variable","Set-Variable -Name x -Value 2"),
("Scripting","Get-Variable","Gets variables","Get-Variable"),
("Scripting","Remove-Variable","Removes variable","Remove-Variable x"),
("Scripting","Read-Host","Reads user input","Read-Host 'Name'"),
("Scripting","Write-Host","Prints text to screen","Write-Host 'Ready'"),
("Scripting","Write-Output","Writes pipeline output","Write-Output 'Ready'"),
("Scripting","Start-Sleep","Pauses script","Start-Sleep -Seconds 2"),
("Jobs","Start-Job","Starts background job","Start-Job { Get-Process }"),
("Jobs","Get-Job","Lists jobs","Get-Job"),
("Jobs","Receive-Job","Gets job results","Receive-Job 1"),
("Jobs","Stop-Job","Stops job","Stop-Job 1"),
("Jobs","Remove-Job","Removes job","Remove-Job 1"),
("Modules","Get-Module","Lists modules","Get-Module -ListAvailable"),
("Modules","Import-Module","Loads module","Import-Module NetSecurity"),
("Modules","Remove-Module","Unloads module","Remove-Module ModuleName"),
("Remoting","Enter-PSSession","Starts remote session","Enter-PSSession -ComputerName PC01"),
("Remoting","Invoke-Command","Runs remote command","Invoke-Command -ComputerName PC01 -ScriptBlock { hostname }"),
("Remoting","New-PSSession","Creates session","New-PSSession -ComputerName PC01"),
("Remoting","Get-PSSession","Lists sessions","Get-PSSession"),
("Remoting","Remove-PSSession","Removes session","Remove-PSSession 1"),
("Registry","Get-ItemProperty HKLM:","Reads registry properties","Get-ItemProperty HKLM:\\Software"),
("Registry","New-ItemProperty","Creates registry property","New-ItemProperty"),
("Registry","Set-ItemProperty","Sets registry property","Set-ItemProperty"),
("Registry","Remove-ItemProperty","Removes registry property","Remove-ItemProperty"),
("Errors","Try/Catch","Handles errors","try { Get-Item bad } catch { Write-Host 'failed' }"),
("Errors","$Error","Shows error list","$Error[0]"),
]

cmd = [
("Basics","help","Shows command help","help"),
("Basics","cls","Clears screen","cls"),
("Basics","echo","Prints text","echo hello"),
("Basics","ver","Shows Windows version","ver"),
("Basics","date","Shows or sets date","date /t"),
("Basics","time","Shows or sets time","time /t"),
("Navigation","cd","Changes directory","cd C:\\Users"),
("Navigation","dir","Lists files and folders","dir"),
("Navigation","tree","Shows folder tree","tree /f"),
("Navigation","pushd","Saves path and changes directory","pushd C:\\Temp"),
("Navigation","popd","Returns to saved path","popd"),
("Files","type","Reads file content","type notes.txt"),
("Files","copy","Copies files","copy a.txt b.txt"),
("Files","xcopy","Copies files and directories","xcopy source dest /E"),
("Files","robocopy","Advanced file copy","robocopy source dest /MIR"),
("Files","move","Moves files","move a.txt C:\\Temp"),
("Files","ren","Renames files","ren old.txt new.txt"),
("Files","del","Deletes files","del old.txt"),
("Files","erase","Deletes files","erase old.txt"),
("Files","mkdir","Creates directory","mkdir lab"),
("Files","rmdir","Removes directory","rmdir lab"),
("Files","attrib","Views or changes attributes","attrib +h secret.txt"),
("Files","fc","Compares files","fc a.txt b.txt"),
("Files","find","Searches text","find 'error' log.txt"),
("Files","findstr","Searches text with patterns","findstr /i error log.txt"),
("Files","where","Finds executable path","where python"),
("Files","compact","Shows or changes compression","compact /c file.txt"),
("Files","cipher","Encryption and wipe utility","cipher /w:C:\\Temp"),
("System","hostname","Shows computer name","hostname"),
("System","whoami","Shows current user","whoami"),
("System","systeminfo","Shows system info","systeminfo"),
("System","set","Shows environment variables","set"),
("System","path","Shows or sets path","path"),
("System","wmic","Windows Management Instrumentation CLI","wmic os get caption"),
("System","driverquery","Lists drivers","driverquery"),
("System","tasklist","Lists running processes","tasklist"),
("System","taskkill","Kills process","taskkill /PID 1234 /F"),
("System","shutdown","Shuts down or restarts","shutdown /r /t 0"),
("System","logoff","Logs off user","logoff"),
("System","gpupdate","Updates group policy","gpupdate /force"),
("System","gpresult","Shows group policy result","gpresult /r"),
("System","sfc","System file checker","sfc /scannow"),
("System","dism","Windows image servicing","dism /online /cleanup-image /restorehealth"),
("System","chkdsk","Checks disk","chkdsk C: /f"),
("System","fsutil","File system utility","fsutil fsinfo drives"),
("Users","net user","Lists or manages users","net user"),
("Users","net localgroup","Lists or manages groups","net localgroup"),
("Users","net accounts","Shows account policy","net accounts"),
("Users","runas","Runs command as another user","runas /user:Admin cmd"),
("Networking","ipconfig","Shows IP configuration","ipconfig /all"),
("Networking","ping","Tests connectivity","ping 8.8.8.8"),
("Networking","tracert","Traces route","tracert google.com"),
("Networking","pathping","Trace and packet loss tool","pathping google.com"),
("Networking","nslookup","DNS lookup","nslookup example.com"),
("Networking","netstat","Shows network connections","netstat -ano"),
("Networking","arp","Shows ARP table","arp -a"),
("Networking","route","Shows or edits routes","route print"),
("Networking","nbtstat","NetBIOS over TCP/IP info","nbtstat -n"),
("Networking","getmac","Shows MAC addresses","getmac"),
("Networking","netsh","Network shell","netsh advfirewall show allprofiles"),
("Networking","telnet","Tests TCP services if enabled","telnet host 80"),
("Networking","ftp","FTP client","ftp server"),
("Networking","tftp","TFTP client if enabled","tftp"),
("Networking","net view","Views network resources","net view"),
("Networking","net use","Maps network drives","net use Z: \\\\server\\share"),
("Networking","net share","Manages shares","net share"),
("Networking","net session","Shows sessions","net session"),
("Networking","net file","Shows open shared files","net file"),
("Firewall","netsh advfirewall show","Shows firewall profiles","netsh advfirewall show allprofiles"),
("Firewall","netsh advfirewall set","Changes firewall state","netsh advfirewall set allprofiles state on"),
("Firewall","netsh advfirewall firewall add rule","Adds firewall rule","netsh advfirewall firewall add rule name=Test dir=in action=allow protocol=TCP localport=8080"),
("Services","sc query","Queries services","sc query"),
("Services","sc start","Starts service","sc start Spooler"),
("Services","sc stop","Stops service","sc stop Spooler"),
("Services","sc config","Configures service","sc config Spooler start= demand"),
("Services","net start","Lists or starts services","net start"),
("Services","net stop","Stops service","net stop Spooler"),
("Events","wevtutil el","Lists event logs","wevtutil el"),
("Events","wevtutil qe","Queries event log","wevtutil qe Security /c:10 /f:text"),
("Events","eventcreate","Creates event log entry","eventcreate /T INFORMATION /ID 100 /L APPLICATION /D test"),
("Scheduling","schtasks","Manages scheduled tasks","schtasks /query"),
("Scheduling","at","Legacy task scheduler command","at"),
("Disks","diskpart","Disk partition tool","diskpart"),
("Disks","mountvol","Manages volume mount points","mountvol"),
("Disks","vol","Shows volume label","vol C:"),
("Disks","label","Changes volume label","label C: DATA"),
("Power","powercfg","Power configuration","powercfg /batteryreport"),
("Security","whoami /priv","Shows privileges","whoami /priv"),
("Security","whoami /groups","Shows groups","whoami /groups"),
("Security","certutil","Certificate and hashing utility","certutil -hashfile file.txt SHA256"),
("Security","icacls","Views or changes ACLs","icacls file.txt"),
("Security","takeown","Takes file ownership","takeown /f file.txt"),
("Security","auditpol","Shows audit policy","auditpol /get /category:*"),
("Troubleshooting","assoc","Shows file associations","assoc .txt"),
("Troubleshooting","ftype","Shows file type commands","ftype"),
("Troubleshooting","clip","Copies output to clipboard","ipconfig | clip"),
("Troubleshooting","more","Pages output","type log.txt | more"),
("Troubleshooting","sort","Sorts text","sort names.txt"),
("Troubleshooting","choice","Prompts for choice","choice /C YN"),
("Troubleshooting","timeout","Waits seconds","timeout /t 5"),
("Troubleshooting","start","Starts a program/window","start notepad"),
("Troubleshooting","call","Calls batch file","call script.bat"),
("Troubleshooting","exit","Exits CMD","exit"),
]

linux = [
("Basics","pwd","Shows current directory","pwd"),
("Basics","ls","Lists files","ls -la"),
("Basics","cd","Changes directory","cd /var/log"),
("Basics","clear","Clears terminal","clear"),
("Basics","history","Shows command history","history"),
("Basics","man","Shows manual page","man ls"),
("Basics","whatis","One-line command description","whatis ls"),
("Basics","apropos","Searches manual page names","apropos network"),
("Basics","which","Shows command path","which python3"),
("Basics","whereis","Locates binary/source/man","whereis bash"),
("Files","touch","Creates empty file","touch notes.txt"),
("Files","cat","Reads file","cat notes.txt"),
("Files","less","Pages through file","less /var/log/syslog"),
("Files","more","Pages through file","more file.txt"),
("Files","head","Shows first lines","head file.txt"),
("Files","tail","Shows last lines","tail -f /var/log/syslog"),
("Files","cp","Copies files","cp a.txt b.txt"),
("Files","mv","Moves or renames","mv old.txt new.txt"),
("Files","rm","Removes files","rm old.txt"),
("Files","mkdir","Creates directory","mkdir lab"),
("Files","rmdir","Removes empty directory","rmdir lab"),
("Files","ln","Creates links","ln -s target link"),
("Files","file","Identifies file type","file unknown.bin"),
("Files","stat","Shows file metadata","stat file.txt"),
("Files","du","Shows disk usage","du -sh ."),
("Files","df","Shows filesystem free space","df -h"),
("Search","find","Finds files","find . -name '*.log'"),
("Search","locate","Finds files via database","locate passwd"),
("Search","grep","Searches text","grep -R error ."),
("Search","egrep","Extended grep","egrep 'error|fail' log.txt"),
("Search","awk","Text processing","awk '{print $1}' file.txt"),
("Search","sed","Stream editor","sed 's/old/new/g' file.txt"),
("Search","cut","Cuts columns","cut -d: -f1 /etc/passwd"),
("Search","sort","Sorts lines","sort names.txt"),
("Search","uniq","Filters repeated lines","sort file | uniq"),
("Search","wc","Counts lines/words/bytes","wc -l file.txt"),
("Permissions","chmod","Changes permissions","chmod 600 secret.txt"),
("Permissions","chown","Changes owner","sudo chown user file.txt"),
("Permissions","chgrp","Changes group","chgrp group file.txt"),
("Permissions","umask","Shows default permissions","umask"),
("Permissions","id","Shows user/group IDs","id"),
("Permissions","whoami","Shows current user","whoami"),
("Permissions","groups","Shows groups","groups"),
("Permissions","sudo","Runs as elevated user","sudo apt update"),
("Users","useradd","Adds user","sudo useradd testuser"),
("Users","usermod","Modifies user","sudo usermod -aG sudo testuser"),
("Users","userdel","Deletes user","sudo userdel testuser"),
("Users","passwd","Changes password","passwd"),
("Users","su","Switches user","su -"),
("Users","who","Shows logged-in users","who"),
("Users","w","Shows logged-in users/activity","w"),
("Users","last","Shows login history","last"),
("Processes","ps","Lists processes","ps aux"),
("Processes","top","Live process viewer","top"),
("Processes","htop","Better live process viewer","htop"),
("Processes","kill","Kills by PID","kill 1234"),
("Processes","killall","Kills by name","killall firefox"),
("Processes","pkill","Kills by pattern","pkill -f script.py"),
("Processes","pgrep","Finds process IDs","pgrep ssh"),
("Processes","nice","Runs with priority","nice -n 10 command"),
("Processes","renice","Changes process priority","renice 5 -p 1234"),
("Networking","ip","Shows/manages network","ip a"),
("Networking","ping","Tests connectivity","ping 8.8.8.8"),
("Networking","ss","Shows sockets","ss -tulnp"),
("Networking","netstat","Legacy sockets/routes","netstat -tulnp"),
("Networking","curl","Makes web requests","curl https://example.com"),
("Networking","wget","Downloads files","wget https://example.com/file"),
("Networking","dig","DNS query","dig example.com"),
("Networking","nslookup","DNS lookup","nslookup example.com"),
("Networking","traceroute","Traces route","traceroute example.com"),
("Networking","tracepath","Traces route","tracepath example.com"),
("Networking","hostname","Shows/sets hostname","hostname"),
("Networking","resolvectl","DNS resolver status","resolvectl status"),
("Networking","nmcli","NetworkManager CLI","nmcli device status"),
("Networking","scp","Secure copy over SSH","scp file user@host:/tmp"),
("Networking","ssh","Secure shell remote login","ssh user@host"),
("Services","systemctl","Controls services","systemctl status ssh"),
("Services","service","Legacy service command","service ssh status"),
("Services","journalctl","Reads systemd logs","journalctl -xe"),
("Services","dmesg","Kernel ring buffer","dmesg"),
("Services","crontab","Schedules jobs","crontab -e"),
("Packages","apt","Debian/Ubuntu package tool","sudo apt update"),
("Packages","apt-cache","Searches package cache","apt-cache search nginx"),
("Packages","dpkg","Debian package manager","dpkg -l"),
("Packages","snap","Snap package manager","snap list"),
("Archives","tar","Archives/extracts files","tar -xzf archive.tar.gz"),
("Archives","gzip","Compresses files","gzip file.txt"),
("Archives","gunzip","Decompresses gzip","gunzip file.txt.gz"),
("Archives","zip","Creates zip archive","zip files.zip *.txt"),
("Archives","unzip","Extracts zip","unzip files.zip"),
("System","uname","Shows system info","uname -a"),
("System","uptime","Shows uptime/load","uptime"),
("System","free","Shows memory","free -h"),
("System","lscpu","Shows CPU info","lscpu"),
("System","lsblk","Shows block devices","lsblk"),
("System","blkid","Shows block IDs","blkid"),
("System","mount","Shows/mounts filesystems","mount"),
("System","umount","Unmounts filesystem","umount /mnt/usb"),
("System","env","Shows environment","env"),
("System","printenv","Prints env variable","printenv PATH"),
("Scripting","bash","Runs Bash shell/script","bash script.sh"),
("Scripting","sh","Runs POSIX shell","sh script.sh"),
("Scripting","echo","Prints text","echo hello"),
("Scripting","printf","Formatted output","printf '%s\n' hello"),
("Scripting","xargs","Builds command args","cat list | xargs rm"),
]

for row in powershell[:100]:
    add("Windows PowerShell", row[0], row[1], row[2], row[3])
for row in cmd[:100]:
    add("Windows CMD", row[0], row[1], row[2], row[3])
for row in linux[:100]:
    add("Linux Terminal", row[0], row[1], row[2], row[3])

out = Path("data/jedi-archives.json")
out.write_text(json.dumps(archives, indent=2))
print(f"Wrote {len(archives)} archive entries to {out}")
PY

cat > engine/JediArchives.ps1 <<'PS1'
$Global:JediArchivesFile = Join-Path $PSScriptRoot "../data/jedi-archives.json"

function Get-JediArchiveEntries {
    if (!(Test-Path $Global:JediArchivesFile)) {
        Write-Host "Archive data file missing: $Global:JediArchivesFile" -ForegroundColor Red
        return @()
    }

    $raw = Get-Content $Global:JediArchivesFile -Raw

    if ([string]::IsNullOrWhiteSpace($raw)) {
        return @()
    }

    return @($raw | ConvertFrom-Json)
}

function Show-ArchiveEntries {
    param(
        [array]$Entries,
        [string]$Title = "JEDI ARCHIVES"
    )

    $page = 0
    $pageSize = 20

    while ($true) {
        Write-CyberHeader -Title $Title -Subtitle "Searchable command reference" -Theme "Neutral"

        if ($Entries.Count -eq 0) {
            Write-Host "No archive entries found." -ForegroundColor Yellow
            Pause-Game
            return
        }

        $totalPages = [math]::Ceiling($Entries.Count / $pageSize)
        $start = $page * $pageSize
        $end = [math]::Min($start + $pageSize - 1, $Entries.Count - 1)

        Write-Host "Showing $($start + 1)-$($end + 1) of $($Entries.Count). Page $($page + 1)/$totalPages" -ForegroundColor Yellow
        Write-Host ""

        for ($i = $start; $i -le $end; $i++) {
            $entry = $Entries[$i]
            Write-Host "[$($i + 1)] $($entry.Command)" -ForegroundColor Cyan
            Write-Host "    Track   : $($entry.Track)" -ForegroundColor DarkGray
            Write-Host "    Category: $($entry.Category)" -ForegroundColor DarkGray
            Write-Host "    Purpose : $($entry.Purpose)" -ForegroundColor White
            Write-Host "    Example : $($entry.Example)" -ForegroundColor Green
            Write-Host ""
        }

        Write-Host "[N] Next page  [P] Previous page  [S] Search  [B] Back" -ForegroundColor DarkGray
        $choice = Read-Menu -Prompt "Archive"

        if ([string]::IsNullOrWhiteSpace($choice)) {
            continue
        }

        switch ($choice.ToUpper()) {
            "N" {
                if ($page -lt ($totalPages - 1)) { $page++ }
            }
            "P" {
                if ($page -gt 0) { $page-- }
            }
            "S" {
                Search-JediArchives
                return
            }
            "B" {
                return
            }
            default {
                continue
            }
        }
    }
}

function Search-JediArchives {
    $all = @(Get-JediArchiveEntries)

    Write-CyberHeader -Title "SEARCH JEDI ARCHIVES" -Subtitle "Search command, purpose, category, or example" -Theme "Neutral"

    $term = Read-Menu -Prompt "Search"

    if ([string]::IsNullOrWhiteSpace($term)) {
        return
    }

    $clean = $term.ToLower()

    $matches = @(
        $all | Where-Object {
            ($_.Command.ToLower().Contains($clean)) -or
            ($_.Purpose.ToLower().Contains($clean)) -or
            ($_.Category.ToLower().Contains($clean)) -or
            ($_.Example.ToLower().Contains($clean)) -or
            ($_.Track.ToLower().Contains($clean))
        }
    )

    Show-ArchiveEntries -Entries $matches -Title "SEARCH RESULTS: $term"
}

function Show-JediArchives {
    while ($true) {
        $all = @(Get-JediArchiveEntries)

        $ps = @($all | Where-Object { $_.Track -eq "Windows PowerShell" })
        $cmd = @($all | Where-Object { $_.Track -eq "Windows CMD" })
        $linux = @($all | Where-Object { $_.Track -eq "Linux Terminal" })

        Write-CyberHeader -Title "JEDI ARCHIVES" -Subtitle "PowerShell, CMD, and Linux command library" -Theme "Neutral"

        Write-BoxLine
        Write-BoxText -Text "COMMAND LIBRARY" -Color Yellow
        Write-BoxText -Text "[1] Windows PowerShell Archives, $($ps.Count) commands"
        Write-BoxText -Text "[2] Windows CMD Archives, $($cmd.Count) commands"
        Write-BoxText -Text "[3] Linux Terminal Archives, $($linux.Count) commands"
        Write-BoxText -Text "[4] Search All Archives, $($all.Count) total commands"
        Write-BoxText -Text "[B] Back"
        Write-BoxEnd
        Write-Host ""

        Write-Host "STRUCTURE NOTE:" -ForegroundColor Cyan
        Write-Host " Linux is an operating system. Bash/Zsh are common Linux shells." -ForegroundColor White
        Write-Host " PowerShell and CMD are Windows command shells, not operating systems." -ForegroundColor White
        Write-Host ""

        $choice = Read-Menu -Prompt "Choose"

        if ([string]::IsNullOrWhiteSpace($choice)) {
            continue
        }

        switch ($choice.ToUpper()) {
            "1" { Show-ArchiveEntries -Entries $ps -Title "WINDOWS POWERSHELL ARCHIVES" }
            "2" { Show-ArchiveEntries -Entries $cmd -Title "WINDOWS CMD ARCHIVES" }
            "3" { Show-ArchiveEntries -Entries $linux -Title "LINUX TERMINAL ARCHIVES" }
            "4" { Search-JediArchives }
            "B" { return }
            default {
                Write-Host "Invalid selection." -ForegroundColor Red
                Start-Sleep -Seconds 1
            }
        }
    }
}
PS1

python3 - <<'PY'
from pathlib import Path

file = Path("Start-CyberShell.ps1")
text = file.read_text()

import_line = '. "$PSScriptRoot/engine/JediArchives.ps1"'

if import_line not in text:
    text = text.replace(
        '. "$PSScriptRoot/engine/HolocronAcademy.ps1"',
        '. "$PSScriptRoot/engine/HolocronAcademy.ps1"\n. "$PSScriptRoot/engine/JediArchives.ps1"'
    )

file.write_text(text)
PY

echo "========================================"
echo " JEDI ARCHIVES EXPANDED"
echo "========================================"
echo "PowerShell: 100"
echo "CMD:        100"
echo "Linux:      100"
echo "Total:      300"
echo ""
echo "Test with:"
echo "pwsh -NoProfile -ExecutionPolicy Bypass -File ./Start-CyberShell.ps1"
