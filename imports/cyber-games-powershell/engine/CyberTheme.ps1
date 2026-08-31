function Clear-Screen {
    Clear-Host
}

function Write-Line {
    param([string]$Color = "Cyan")
    Write-Host "====================================================================" -ForegroundColor $Color
}

function Write-BoxLine {
    param([string]$Color = "DarkGray")
    Write-Host "┌──────────────────────────────────────────────────────────────────┐" -ForegroundColor $Color
}

function Write-BoxEnd {
    param([string]$Color = "DarkGray")
    Write-Host "└──────────────────────────────────────────────────────────────────┘" -ForegroundColor $Color
}

function Write-BoxText {
    param(
        [string]$Text,
        [string]$Color = "White"
    )

    $max = 64

    if ($null -eq $Text) {
        $Text = ""
    }

    if ($Text.Length -gt $max) {
        $Text = $Text.Substring(0, $max)
    }

    $pad = " " * ($max - $Text.Length)

    Write-Host "│ " -NoNewline -ForegroundColor DarkGray
    Write-Host "$Text$pad" -NoNewline -ForegroundColor $Color
    Write-Host " │" -ForegroundColor DarkGray
}

function Write-CyberHeader {
    param(
        [string]$Title = "CYBERSHELL ACADEMY",
        [string]$Subtitle = "Terminal-based cyber training RPG",
        [string]$Theme = "Neutral"
    )

    $main = "Cyan"
    $accent = "DarkCyan"

    if ($Theme -eq "Light") {
        $main = "Cyan"
        $accent = "Green"
    }

    if ($Theme -eq "Shadow") {
        $main = "Red"
        $accent = "DarkRed"
    }

    Clear-Screen
    Write-Host ""
    Write-Line -Color $accent
    Write-Host "   ██████╗██╗   ██╗██████╗ ███████╗██████╗ ███████╗██╗  ██╗███████╗██╗     ██╗     " -ForegroundColor $main
    Write-Host "  ██╔════╝╚██╗ ██╔╝██╔══██╗██╔════╝██╔══██╗██╔════╝██║  ██║██╔════╝██║     ██║     " -ForegroundColor $main
    Write-Host "  ██║      ╚████╔╝ ██████╔╝█████╗  ██████╔╝███████╗███████║█████╗  ██║     ██║     " -ForegroundColor $main
    Write-Host "  ██║       ╚██╔╝  ██╔══██╗██╔══╝  ██╔══██╗╚════██║██╔══██║██╔══╝  ██║     ██║     " -ForegroundColor $main
    Write-Host "  ╚██████╗   ██║   ██████╔╝███████╗██║  ██║███████║██║  ██║███████╗███████╗███████╗" -ForegroundColor $main
    Write-Host "   ╚═════╝   ╚═╝   ╚═════╝ ╚══════╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚══════╝╚══════╝╚══════╝" -ForegroundColor $main
    Write-Line -Color $accent
    Write-Host "   $Title" -ForegroundColor $main
    Write-Host "   $Subtitle" -ForegroundColor $accent
    Write-Line -Color $accent
    Write-Host ""
}

function Read-Menu {
    param([string]$Prompt = "Choose")
    return (Read-Host $Prompt).Trim()
}

function Pause-Game {
    Write-Host ""
    Read-Host "Press ENTER to continue"
}

function Write-MenuOption {
    param(
        [string]$Key,
        [string]$Text,
        [string]$Color = "White"
    )

    Write-Host "   [$Key] " -NoNewline -ForegroundColor DarkGray
    Write-Host $Text -ForegroundColor $Color
}

function Get-ThemeForTrack {
    param([string]$Track)

    if ($Track -eq "Windows") {
        return "Light"
    }

    if ($Track -eq "Linux") {
        return "Shadow"
    }

    return "Neutral"
}
