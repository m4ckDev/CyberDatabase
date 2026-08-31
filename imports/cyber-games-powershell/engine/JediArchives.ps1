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
