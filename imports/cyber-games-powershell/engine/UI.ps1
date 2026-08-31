# UI.ps1
# CyberShell: Terminal Ops UI System
# Full immersive terminal interface for Cyber Games by MackinnonTech

function Write-Line {
    param (
        [string]$Text = "",
        [string]$Color = "White"
    )

    Write-Host $Text -ForegroundColor $Color
}

function Write-Slow {
    param (
        [string]$Text,
        [int]$Delay = 10,
        [string]$Color = "White"
    )

    foreach ($char in $Text.ToCharArray()) {
        Write-Host -NoNewline $char -ForegroundColor $Color
        Start-Sleep -Milliseconds $Delay
    }

    Write-Host ""
}

function Write-GlitchLine {
    param (
        [string]$Text,
        [string]$Color = "Cyan"
    )

    $glitchChars = @("#", "@", "%", "&", "0", "1", "/", "\", "|", "<", ">", "[", "]")

    foreach ($char in $Text.ToCharArray()) {
        $roll = Get-Random -Minimum 1 -Maximum 18

        if ($roll -eq 1 -and $char -ne " ") {
            $fake = $glitchChars | Get-Random
            Write-Host -NoNewline $fake -ForegroundColor DarkGray
            Start-Sleep -Milliseconds 8
            Write-Host -NoNewline "`b$char" -ForegroundColor $Color
        }
        else {
            Write-Host -NoNewline $char -ForegroundColor $Color
        }

        Start-Sleep -Milliseconds 1
    }

    Write-Host ""
}

function Write-CenteredText {
    param (
        [string]$Text,
        [int]$Width = 78,
        [string]$Color = "White"
    )

    if ($Text.Length -gt $Width) {
        $Text = $Text.Substring(0, $Width)
    }

    $leftPadding = [math]::Floor(($Width - $Text.Length) / 2)
    $rightPadding = $Width - $Text.Length - $leftPadding

    $line = "║" + (" " * $leftPadding) + $Text + (" " * $rightPadding) + "║"
    Write-Host $line -ForegroundColor $Color
}

function Write-BoxLine {
    param (
        [string]$Color = "DarkCyan"
    )

    Write-Host "║                                                                              ║" -ForegroundColor $Color
}

function Show-Banner {
    Clear-Host

    Write-Host ""
    Write-Host "╔══════════════════════════════════════════════════════════════════════════════╗" -ForegroundColor DarkCyan
    Write-BoxLine
    Write-CenteredText "██████╗██╗   ██╗██████╗ ███████╗██████╗ ███████╗██╗  ██╗███████╗██╗     ██╗" 78 "Cyan"
    Write-CenteredText "██╔════╝╚██╗ ██╔╝██╔══██╗██╔════╝██╔══██╗██╔════╝██║  ██║██╔════╝██║     ██║" 78 "Cyan"
    Write-CenteredText "██║      ╚████╔╝ ██████╔╝█████╗  ██████╔╝███████╗███████║█████╗  ██║     ██║" 78 "Cyan"
    Write-CenteredText "██║       ╚██╔╝  ██╔══██╗██╔══╝  ██╔══██╗╚════██║██╔══██║██╔══╝  ██║     ██║" 78 "Cyan"
    Write-CenteredText "╚██████╗   ██║   ██████╔╝███████╗██║  ██║███████║██║  ██║███████╗███████╗███████╗" 78 "Cyan"
    Write-CenteredText " ╚═════╝   ╚═╝   ╚═════╝ ╚══════╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚══════╝╚══════╝╚══════╝" 78 "Cyan"
    Write-BoxLine
    Write-CenteredText "CyberShell" 78 "Green"
    Write-CenteredText "Terminal Ops Simulator" 78 "Green"
    Write-BoxLine
    Write-CenteredText "Welcome to Cyber Games by MackinnonTech" 78 "Yellow"
    Write-BoxLine
    Write-CenteredText "PowerShell  |  Linux  |  Cyber Defense  |  CLI Training" 78 "Gray"
    Write-BoxLine
    Write-Host "╠══════════════════════════════════════════════════════════════════════════════╣" -ForegroundColor DarkCyan
    Write-CenteredText "NODE: MACKINNONTECH-001     MODE: TRAINING SIMULATION     STATUS: ONLINE" 78 "Green"
    Write-Host "╚══════════════════════════════════════════════════════════════════════════════╝" -ForegroundColor DarkCyan
    Write-Host ""
}

function Show-StartupSequence {
    Show-Banner

    Write-GlitchLine "[BOOT] Loading CyberShell interface..." "Green"
    Start-Sleep -Milliseconds 160

    Write-GlitchLine "[OK]   Terminal rendering engine online." "Green"
    Start-Sleep -Milliseconds 160

    Write-GlitchLine "[OK]   Mission system linked." "Green"
    Start-Sleep -Milliseconds 160

    Write-GlitchLine "[OK]   CLI training grounds mounted." "Green"
    Start-Sleep -Milliseconds 160

    Write-GlitchLine "[OK]   Leaderboard service initialized." "Green"
    Start-Sleep -Milliseconds 160

    Write-Host ""
    Write-Slow -Text "Welcome to Cyber Games by MackinnonTech!" -Delay 8 -Color "Cyan"
    Start-Sleep -Milliseconds 250

    Write-Slow -Text "Operator session ready." -Delay 8 -Color "Green"
    Start-Sleep -Milliseconds 500
}

function Pause-Game {
    Write-Host ""
    Read-Host "Press Enter to continue"
}

function Show-SectionHeader {
    param (
        [string]$Title
    )

    Clear-Host

    Write-Host ""
    Write-Host "╔══════════════════════════════════════════════════════════════════════════════╗" -ForegroundColor DarkCyan
    Write-CenteredText "CyberShell Terminal Ops" 78 "Cyan"
    Write-Host "╠══════════════════════════════════════════════════════════════════════════════╣" -ForegroundColor DarkCyan
    Write-CenteredText $Title 78 "Green"
    Write-Host "╚══════════════════════════════════════════════════════════════════════════════╝" -ForegroundColor DarkCyan
    Write-Host ""
}

function Show-MenuOption {
    param (
        [string]$Number,
        [string]$Text
    )

    Write-Host "  [" -NoNewline -ForegroundColor DarkGray
    Write-Host $Number -NoNewline -ForegroundColor Cyan
    Write-Host "] " -NoNewline -ForegroundColor DarkGray
    Write-Host $Text -ForegroundColor White
}

function Show-MenuTitle {
    param (
        [string]$Title
    )

    Write-Host ""
    Write-Host "┌─ $Title ───────────────────────────────────────────────────────────────────" -ForegroundColor DarkCyan
}

function Show-MenuFooter {
    Write-Host "└────────────────────────────────────────────────────────────────────────────" -ForegroundColor DarkCyan
    Write-Host ""
}

function Show-MessageBox {
    param (
        [string]$Speaker,
        [string]$Message,
        [string]$Color = "Green"
    )

    Write-Host ""
    Write-Host "┌────────────────────────────────────────────────────────────────────────────┐" -ForegroundColor DarkGray
    Write-Host "│ [$Speaker]" -ForegroundColor $Color
    Write-Host "├────────────────────────────────────────────────────────────────────────────┤" -ForegroundColor DarkGray

    Write-Host "│ " -NoNewline -ForegroundColor DarkGray
    Write-Slow -Text $Message -Delay 8 -Color "White"

    Write-Host "└────────────────────────────────────────────────────────────────────────────┘" -ForegroundColor DarkGray
    Write-Host ""
}

function Show-SystemDivider {
    Write-Host ""
    Write-Host "──────────────────────────────────────────────────────────────────────────────" -ForegroundColor DarkGray
    Write-Host ""
}

function Show-AccessGranted {
    Write-Host ""
    Write-Host "╔════════════════════════════════════╗" -ForegroundColor DarkCyan
    Write-Host "║          ACCESS GRANTED            ║" -ForegroundColor Green
    Write-Host "╚════════════════════════════════════╝" -ForegroundColor DarkCyan
    Write-Host ""
}

function Show-AccessDenied {
    Write-Host ""
    Write-Host "╔════════════════════════════════════╗" -ForegroundColor DarkRed
    Write-Host "║           ACCESS DENIED            ║" -ForegroundColor Red
    Write-Host "╚════════════════════════════════════╝" -ForegroundColor DarkRed
    Write-Host ""
}

function Show-MiniStatusBar {
    Write-Host ""
    Write-Host "┌─ OPERATOR STATUS ──────────────────────────────────────────────────────────┐" -ForegroundColor DarkCyan

    if ($Global:Player) {
        $status = "Name: $($Global:Player.Name) | Rank: $($Global:Player.Rank) | Level: $($Global:Player.Level) | Health: $($Global:Player.Health)"
        Write-Host "│ $status" -ForegroundColor Gray
    }
    else {
        Write-Host "│ No operator profile loaded." -ForegroundColor DarkGray
    }

    Write-Host "└────────────────────────────────────────────────────────────────────────────┘" -ForegroundColor DarkCyan
    Write-Host ""
}

function Show-ErrorBox {
    param (
        [string]$Message
    )

    Write-Host ""
    Write-Host "┌─ ERROR ────────────────────────────────────────────────────────────────────┐" -ForegroundColor DarkRed
    Write-Host "│ $Message" -ForegroundColor Red
    Write-Host "└────────────────────────────────────────────────────────────────────────────┘" -ForegroundColor DarkRed
    Write-Host ""
}

function Show-SuccessBox {
    param (
        [string]$Message
    )

    Write-Host ""
    Write-Host "┌─ SUCCESS ──────────────────────────────────────────────────────────────────┐" -ForegroundColor DarkGreen
    Write-Host "│ $Message" -ForegroundColor Green
    Write-Host "└────────────────────────────────────────────────────────────────────────────┘" -ForegroundColor DarkGreen
    Write-Host ""
}

function Show-WarningBox {
    param (
        [string]$Message
    )

    Write-Host ""
    Write-Host "┌─ WARNING ──────────────────────────────────────────────────────────────────┐" -ForegroundColor DarkYellow
    Write-Host "│ $Message" -ForegroundColor Yellow
    Write-Host "└────────────────────────────────────────────────────────────────────────────┘" -ForegroundColor DarkYellow
    Write-Host ""
}
