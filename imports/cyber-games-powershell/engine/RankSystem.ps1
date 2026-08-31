function Get-WindowsRank {
    param(
        [int]$XP
    )

    if ($XP -lt 50) { return "Padawan" }
    elseif ($XP -lt 150) { return "Jedi Initiate" }
    elseif ($XP -lt 300) { return "Jedi Knight" }
    elseif ($XP -lt 500) { return "Jedi Sentinel" }
    else { return "Jedi Master" }
}

function Get-LinuxRank {
    param(
        [int]$XP
    )

    if ($XP -lt 50) { return "Dark Side Acolyte" }
    elseif ($XP -lt 150) { return "Sith Apprentice" }
    elseif ($XP -lt 300) { return "Shadow Operator" }
    elseif ($XP -lt 500) { return "Imperial Inquisitor" }
    else { return "Sith Lord" }
}

function Show-OperatorStatus {
    param(
        [object]$Profile
    )

    $windowsRank = Get-WindowsRank -XP $Profile.WindowsXP
    $linuxRank = Get-LinuxRank -XP $Profile.LinuxXP

    Write-Host "====================================" -ForegroundColor DarkCyan
    Write-Host " OPERATOR: $($Profile.Name)" -ForegroundColor Cyan
    Write-Host "====================================" -ForegroundColor DarkCyan
    Write-Host "Windows Path : $windowsRank | XP: $($Profile.WindowsXP)"
    Write-Host "Linux Path   : $linuxRank | XP: $($Profile.LinuxXP)"
    Write-Host "Total XP     : $($Profile.TotalXP)"
    Write-Host "Last Login   : $($Profile.LastLogin)"
    Write-Host "====================================" -ForegroundColor DarkCyan
}
