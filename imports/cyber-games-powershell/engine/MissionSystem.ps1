# MissionSystem.ps1
# Handles mission menu and mission loading

function Show-MissionMenu {
    Show-SectionHeader "Mission Board"

    Write-Host "Available Missions:" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "1. First Login"
    Write-Host "2. Phishing Alert"
    Write-Host "3. Port Scan Simulation"
    Write-Host "4. Return to Main Menu"
    Write-Host ""

    $choice = Read-Host "Select a mission"

    switch ($choice) {
        "1" { Start-Mission-FirstLogin }
        "2" { Start-Mission-PhishingAlert }
        "3" { Start-Mission-PortScanSim }
        "4" { Show-MainMenu }
        default {
            Write-Host "Invalid selection. The terminal rejects your nonsense." -ForegroundColor Red
            Pause-Game
            Show-MissionMenu
        }
    }
}

function Complete-Mission {
    param (
        [string]$MissionName,
        [int]$XPReward,
        [int]$CreditReward,
        [int]$ReputationReward
    )

    if ($Global:Player.MissionsCompleted -notcontains $MissionName) {
        $Global:Player.MissionsCompleted += $MissionName
    }

    Add-XP $XPReward
    Add-Credits $CreditReward
    Add-Reputation $ReputationReward

    Save-Player

    Write-Host ""
    Write-Host "Mission complete: $MissionName" -ForegroundColor Green

    Pause-Game
}

function Start-Mission-FirstLogin {
    Show-SectionHeader "Mission 001: First Login"

    Show-MessageBox "ORACLE" "Operator, before you touch anything important, prove you can identify basic cyber hygiene." "Green"

    Write-Host "Question:" -ForegroundColor Cyan
    Write-Host "Which password is strongest?"
    Write-Host ""
    Write-Host "1. password123"
    Write-Host "2. Marine2026"
    Write-Host "3. T9!qL7#vR2@p"
    Write-Host "4. qwerty"
    Write-Host ""

    $answer = Read-Host "Enter your answer"

    if ($answer -eq "3") {
        Write-Host ""
        Write-Host "Correct. You chose the password that was not assembled by a sleep-deprived raccoon." -ForegroundColor Green

        Complete-Mission "First Login" 50 25 5
    }
    else {
        Write-Host ""
        Write-Host "Incorrect. That password belongs in a museum of bad decisions." -ForegroundColor Red
        $Global:Player.Health -= 10
        Save-Player
        Pause-Game
    }

    Show-MissionMenu
}

function Start-Mission-PhishingAlert {
    Show-SectionHeader "Mission 002: Phishing Alert"

    Show-MessageBox "ORACLE" "A user received a suspicious email. Identify the red flags before they donate their credentials to the internet goblins." "Green"

    Write-Host "EMAIL SAMPLE:" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "From: security-alert@micros0ft-support-login.com"
    Write-Host "Subject: URGENT ACCOUNT LOCKED"
    Write-Host ""
    Write-Host "Dear User,"
    Write-Host "Your account will be deleted in 10 minutes."
    Write-Host "Click the link below and enter your password to verify your mailbox."
    Write-Host ""
    Write-Host "What is the biggest red flag?"
    Write-Host ""
    Write-Host "1. Urgent fear-based language"
    Write-Host "2. Suspicious sender domain"
    Write-Host "3. Request for password"
    Write-Host "4. All of the above"
    Write-Host ""

    $answer = Read-Host "Enter your answer"

    if ($answer -eq "4") {
        Write-Host ""
        Write-Host "Correct. It is phishing soup, with extra nonsense sprinkled on top." -ForegroundColor Green

        Complete-Mission "Phishing Alert" 75 35 10
    }
    else {
        Write-Host ""
        Write-Host "Incorrect. The email was basically wearing a fake mustache." -ForegroundColor Red
        $Global:Player.Health -= 15
        Save-Player
        Pause-Game
    }

    Show-MissionMenu
}

function Start-Mission-PortScanSim {
    Show-SectionHeader "Mission 003: Port Scan Simulation"

    Show-MessageBox "ORACLE" "This is a safe simulation. No real scanning. No angry emails from network admins. How tragic." "Green"

    Write-Host "Simulated scan result:" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "HOST: 10.10.10.25"
    Write-Host "PORT     STATE    SERVICE"
    Write-Host "22/tcp   open     ssh"
    Write-Host "80/tcp   open     http"
    Write-Host "443/tcp  open     https"
    Write-Host "3389/tcp open     rdp"
    Write-Host ""

    Write-Host "Question:"
    Write-Host "Which open port could indicate Remote Desktop access on a Windows system?"
    Write-Host ""
    Write-Host "1. 22"
    Write-Host "2. 80"
    Write-Host "3. 443"
    Write-Host "4. 3389"
    Write-Host ""

    $answer = Read-Host "Enter your answer"

    if ($answer -eq "4") {
        Write-Host ""
        Write-Host "Correct. RDP commonly uses port 3389." -ForegroundColor Green

        Complete-Mission "Port Scan Simulation" 100 50 15
    }
    else {
        Write-Host ""
        Write-Host "Incorrect. The tiny numbered door you wanted was 3389." -ForegroundColor Red
        $Global:Player.Health -= 15
        Save-Player
        Pause-Game
    }

    Show-MissionMenu
}