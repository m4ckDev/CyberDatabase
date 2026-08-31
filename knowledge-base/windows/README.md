# Windows Security and Hardening

This section provides a CyberDatabase workflow for reviewing Windows hosts while the full HackTricks Windows source remains available under the synchronized reference mirror.

## System inventory

Capture:

- Windows edition/build and patch level;
- hostname/domain membership;
- logged-on users and local groups;
- running services/processes;
- listening ports;
- installed software;
- endpoint-security products;
- PowerShell version and logging configuration.

Common inventory commands:

```powershell
Get-ComputerInfo
whoami /all
Get-LocalGroupMember Administrators
Get-Process
Get-Service
Get-NetTCPConnection -State Listen
Get-HotFix
```

## Privilege and identity review

Check:

- local Administrators membership;
- service-account privileges;
- token privileges;
- scheduled tasks;
- service executable/configuration permissions;
- credential material stored in scripts/configuration;
- local and domain policy;
- remote-management exposure;
- delegated rights and domain relationships.

A finding should identify the exact lower-privileged principal and the security boundary that can be crossed.

## Services and scheduled tasks

Review Windows services for:

- executable and directory permissions;
- service account;
- startup type;
- quoted/unquoted path behavior;
- writable configuration;
- DLL/search-path dependencies;
- unnecessary privileged services.

Review scheduled tasks for writable scripts, binaries, working directories, or configuration executed by a more privileged account.

## PowerShell

Defensive configuration should consider:

- Script Block Logging;
- Module Logging;
- transcription where appropriate;
- AMSI integration;
- constrained administration models;
- code-signing policy where operationally practical.

PowerShell activity should be correlated with process creation, network connections, authentication, and file changes.

## Credentials and secrets

Review exposure in:

- unattended-install files;
- scripts and configuration;
- browser/application stores;
- service configuration;
- scheduled tasks;
- registry values;
- deployment tooling;
- backups and exported profiles.

Do not collect credential material beyond what is necessary to prove an authorized finding.

## Remote access

Review:

- RDP exposure and Network Level Authentication;
- WinRM configuration;
- SMB signing and legacy SMB versions;
- local firewall scope;
- remote administrative shares;
- MFA/jump-host requirements;
- segmentation between user and administrative networks.

## Logging and detection

High-value Windows telemetry includes:

- process creation;
- authentication/logon events;
- account/group changes;
- service installation/change;
- scheduled task creation/change;
- PowerShell logs;
- Defender/EDR telemetry;
- SMB/RDP/WinRM activity;
- registry persistence changes;
- Windows Firewall events.

## Forensics connection

Windows forensic artifacts are documented separately under `../forensics/`, including registry, event-log, execution, browser, and persistence evidence.

## Source relationship

The complete synchronized HackTricks Windows source is available at:

`../../references/hacktricks-upstream/src/windows-hardening/`

Use the generated HackTricks upstream index for the current full topic list.
