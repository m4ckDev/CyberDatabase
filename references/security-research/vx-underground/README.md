# vx-underground Reference

Primary site: https://vx-underground.org/

vx-underground is a large public malware-research archive containing malware papers, defensive research, threat-analysis material, platform-specific research, YARA resources, malware-analysis collections, and malware samples. CyberDatabase indexes the research and defensive value of the site without mirroring malware binaries.

## Main research areas

### Papers

Research index: https://vx-underground.org/Papers

The public papers tree currently includes major sections for:

- YARA rules
- Windows
- Linux
- macOS malware
- mobile malware
- web malware
- malware defense
- making an EDR
- ICS/SCADA
- AV technology
- LLVM and mutating code
- VXUG zines
- other and multilingual research

### Windows research

Windows papers: https://vx-underground.org/Papers/Windows

The Windows tree includes research areas such as:

- AMSI
- evasion
- hooking
- infection
- initial access
- internals and analysis
- kernel mode
- LSASS
- networking
- persistence
- process injection
- shellcode execution
- syscalls
- system-component abuse
- Windows COM

### Linux research

Linux papers: https://vx-underground.org/Papers/Linux/

The Linux tree includes:

- system components and abuse
- process injection
- persistence
- kernel mode
- internals
- infection
- hooking
- evasion

### Malware analysis archive

Malware-analysis archive: https://vx-underground.org/Malware%20Analysis/2025

The archive collects public technical reporting on malware families, ransomware, APT activity, supply-chain incidents, phishing campaigns, botnets, stealers, loaders, mobile malware, infrastructure, and vulnerability exploitation.

### VXUG publications

VXUG zines: https://vx-underground.org/Papers/VXUG%20Zines

The zine archive contains long-form technical research on malware, endpoint security, operating-system internals, persistence, defensive engineering, reverse engineering, and related topics.

## Malware samples

vx-underground also maintains extensive sample archives. CyberDatabase does not copy sample archives or malware binaries into this repository. Use isolated malware-analysis infrastructure and established handling procedures when working with live samples.

## CyberDatabase mapping

Relevant CyberDatabase sections:

- `../../../knowledge-base/malware-analysis/README.md`
- `../../../knowledge-base/forensics/README.md`
- `../../../knowledge-base/windows/README.md`
- `../../../knowledge-base/linux/README.md`
- `../../../knowledge-base/threat-intelligence/`
- `../../../knowledge-base/detection-engineering/`
- `../../../knowledge-base/incident-response/`
- `../../../knowledge-base/reverse-engineering/`

## Research workflow

1. Start with a malware family, campaign, behavior, ATT&CK technique, or defensive problem.
2. Locate relevant papers before handling samples.
3. Record source, publication date, family/campaign, platform, and key behaviors.
4. Extract defensive value: IOCs, TTPs, YARA/Sigma ideas, telemetry sources, and mitigations.
5. Validate indicators against current trusted sources before operational use.
6. Keep live-malware handling isolated from normal development systems.

## Suggested CyberDatabase note format

```text
Research topic
Source / URL
Date
Malware family / actor / campaign
Platforms
Initial access
Execution
Persistence
Privilege / credential activity
Discovery
Lateral movement
Command and control
Exfiltration / impact
Indicators
Detection opportunities
Mitigations
ATT&CK mapping
Analyst notes
```
