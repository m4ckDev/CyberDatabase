$Global:ProfileFile = Join-Path $PSScriptRoot "../data/profiles.json"

function Initialize-ProfileStore {
    $dataDir = Split-Path $Global:ProfileFile
    if (!(Test-Path $dataDir)) {
        New-Item -ItemType Directory -Path $dataDir -Force | Out-Null
    }

    if (!(Test-Path $Global:ProfileFile)) {
        @() | ConvertTo-Json | Set-Content $Global:ProfileFile
    }
}

function Get-Profiles {
    Initialize-ProfileStore

    $raw = Get-Content $Global:ProfileFile -Raw

    if ([string]::IsNullOrWhiteSpace($raw)) {
        return @()
    }

    $profiles = $raw | ConvertFrom-Json

    if ($null -eq $profiles) {
        return @()
    }

    if ($profiles -isnot [System.Array]) {
        return @($profiles)
    }

    return $profiles
}

function Save-Profiles {
    param(
        [array]$Profiles
    )

    $Profiles | ConvertTo-Json -Depth 10 | Set-Content $Global:ProfileFile
}

function New-CyberProfile {
    Clear-Host
    Write-Host "====================================" -ForegroundColor Cyan
    Write-Host " CREATE ANONYMOUS OPERATOR PROFILE" -ForegroundColor Cyan
    Write-Host "====================================" -ForegroundColor Cyan
    Write-Host ""

    do {
        $name = Read-Host "Enter anonymous operator name"
    } while ([string]::IsNullOrWhiteSpace($name))

    $profiles = @(Get-Profiles)

    $existing = $profiles | Where-Object { $_.Name -eq $name }

    if ($existing) {
        Write-Host ""
        Write-Host "That operator name already exists. Loading existing profile." -ForegroundColor Yellow
        Start-Sleep -Seconds 1
        return $existing
    }

    $profile = [PSCustomObject]@{
        Name = $name
        Created = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
        LastLogin = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
        WindowsXP = 0
        LinuxXP = 0
        TotalXP = 0
        CompletedMissions = @()
    }

    $profiles += $profile
    Save-Profiles -Profiles $profiles

    Write-Host ""
    Write-Host "Profile created for: $name" -ForegroundColor Green
    Start-Sleep -Seconds 1

    return $profile
}

function Select-CyberProfile {
    Clear-Host
    Initialize-ProfileStore

    $profiles = @(Get-Profiles)

    Write-Host "====================================" -ForegroundColor Cyan
    Write-Host " CYBERGAME PROFILE LOGIN" -ForegroundColor Cyan
    Write-Host "====================================" -ForegroundColor Cyan
    Write-Host ""

    if ($profiles.Count -eq 0) {
        Write-Host "No profiles found. Creating your first operator profile." -ForegroundColor Yellow
        Start-Sleep -Seconds 1
        return New-CyberProfile
    }

    for ($i = 0; $i -lt $profiles.Count; $i++) {
        $num = $i + 1
        Write-Host "[$num] $($profiles[$i].Name) | Total XP: $($profiles[$i].TotalXP)"
    }

    Write-Host ""
    Write-Host "[N] Create new profile"
    Write-Host ""

    $choice = Read-Host "Select profile"

    if ($choice -match '^[Nn]$') {
        return New-CyberProfile
    }

    if ($choice -match '^\d+$') {
        $index = [int]$choice - 1

        if ($index -ge 0 -and $index -lt $profiles.Count) {
            $profile = $profiles[$index]
            $profile = Repair-CyberProfile -Profile $profile
            $profile.LastLogin = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
            Update-CyberProfile -Profile $profile
            return $profile
        }
    }

    Write-Host "Invalid selection. Loading first profile." -ForegroundColor Yellow
    Start-Sleep -Seconds 1
    return $profiles[0]
}

function Update-CyberProfile {
    param(
        [object]$Profile
    )

    $profiles = @(Get-Profiles)

    for ($i = 0; $i -lt $profiles.Count; $i++) {
        if ($profiles[$i].Name -eq $Profile.Name) {
            $profiles[$i] = $Profile
        }
    }

    Save-Profiles -Profiles $profiles
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



function Repair-CyberProfileSafe {
    param([object]$Profile)

    $props = @($Profile.PSObject.Properties.Name)

    if ($props -notcontains "CompletedMissions") {
        $Profile | Add-Member -NotePropertyName CompletedMissions -NotePropertyValue @() -Force
    }

    if ($props -notcontains "Badges") {
        $Profile | Add-Member -NotePropertyName Badges -NotePropertyValue @() -Force
    }

    if ($props -notcontains "WindowsXP") {
        $Profile | Add-Member -NotePropertyName WindowsXP -NotePropertyValue 0 -Force
    }

    if ($props -notcontains "LinuxXP") {
        $Profile | Add-Member -NotePropertyName LinuxXP -NotePropertyValue 0 -Force
    }

    if ($props -notcontains "TotalXP") {
        $Profile | Add-Member -NotePropertyName TotalXP -NotePropertyValue 0 -Force
    }

    if ($props -notcontains "CurrentStreak") {
        $Profile | Add-Member -NotePropertyName CurrentStreak -NotePropertyValue 0 -Force
    }

    if ($props -notcontains "BestStreak") {
        $Profile | Add-Member -NotePropertyName BestStreak -NotePropertyValue 0 -Force
    }

    if ($props -notcontains "LastDailyDate") {
        $Profile | Add-Member -NotePropertyName LastDailyDate -NotePropertyValue "" -Force
    }

    if ($props -notcontains "PlacementComplete") {
        $Profile | Add-Member -NotePropertyName PlacementComplete -NotePropertyValue $false -Force
    }

    if ($null -eq $Profile.CompletedMissions) {
        $Profile.CompletedMissions = @()
    }

    if ($Profile.CompletedMissions -isnot [System.Array]) {
        $Profile.CompletedMissions = @($Profile.CompletedMissions)
    }

    if ($null -eq $Profile.Badges) {
        $Profile.Badges = @()
    }

    if ($Profile.Badges -isnot [System.Array]) {
        $Profile.Badges = @($Profile.Badges)
    }

    return $Profile
}
