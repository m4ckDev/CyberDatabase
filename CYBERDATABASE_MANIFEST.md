# CyberDatabase Consolidation Manifest

CyberDatabase is the primary repository for m4ckDev cybersecurity material: research, scripts, labs, tools, defensive and offensive-security references, threat intelligence, automation, training projects, and the CyberDeck platform.

## Existing CyberDatabase content

The following existing areas remain in place and are treated as first-class CyberDatabase projects:

- `CyberDeck/`
- `RaspberryCommandCenter/`
- `cheatsheets/`
- `docs/`
- `replit-cyberops/`
- `wifi-sentinel/`

## Public repositories consolidated automatically

The synchronization workflow imports complete snapshots of these public repositories under `imports/`:

- `m4ckDev/Offensive-Security`
- `m4ckDev/deepdarkCTI`
- `m4ckDev/waasa-hacker-tool`
- `m4ckDev/PowerShell-OpsKit`
- `m4ckDev/cyber-games-powershell`
- `m4ckDev/01-cyber-range-blue-team`
- `m4ckDev/02-soc-analyst-simulator`

Each imported repository remains in its own directory so its documentation, notices, and license files remain associated with the original project.

## HackTricks mirror

`references/hacktricks-upstream/` is an automatically refreshed source mirror of the public `HackTricks-wiki/hacktricks` repository. This is kept separate from original CyberDatabase material so upstream attribution, licensing, and provenance remain clear.

CyberDatabase-specific additions and rewritten material should go under `knowledge-base/` rather than modifying the upstream mirror directly.

## Private repositories intentionally not copied into this public repository

These cybersecurity-related repositories were detected but are private and therefore are not automatically copied into public CyberDatabase:

- `m4ckDev/Hacker-Scripts`
- `m4ckDev/Osiris`
- `m4ckDev/cybersecurity-school-mackinnontech`

This prevents accidental publication of material that was intentionally stored privately. They can be consolidated later if CyberDatabase is made private or after their contents are reviewed for public release.

## Repository layout

```text
CyberDatabase/
├── CyberDeck/
├── RaspberryCommandCenter/
├── cheatsheets/
├── docs/
├── knowledge-base/
│   ├── README.md
│   ├── methodology/
│   ├── networking/
│   ├── services-and-protocols/
│   ├── web-security/
│   ├── linux/
│   ├── windows/
│   ├── active-directory/
│   ├── cloud/
│   ├── containers-kubernetes/
│   ├── mobile/
│   ├── reverse-engineering/
│   ├── binary-exploitation/
│   ├── forensics/
│   ├── malware-analysis/
│   ├── osint/
│   ├── threat-intelligence/
│   ├── blue-team/
│   ├── red-team/
│   ├── detection-engineering/
│   ├── incident-response/
│   ├── cryptography/
│   ├── hardware-iot/
│   ├── wireless/
│   ├── ai-security/
│   └── reporting-remediation/
├── imports/
│   └── <public project snapshots>
├── references/
│   └── hacktricks-upstream/
├── replit-cyberops/
└── wifi-sentinel/
```

## Synchronization

`.github/workflows/sync-cyber-resources.yml` refreshes the public project snapshots and HackTricks mirror. Generated synchronization commits are made by GitHub Actions and are prevented from recursively re-running the same import job.
