# CyberDatabase Consolidation Manifest

CyberDatabase is the primary repository for m4ckDev cybersecurity material: research, scripts, labs, tools, defensive and offensive-security references, threat intelligence, automation, training projects, AI/security tooling, hardware references, and the CyberDeck platform.

## Existing CyberDatabase content

The following existing areas remain in place and are treated as first-class CyberDatabase projects:

- `AI/`
- `CyberDeck/`
- `RaspberryCommandCenter/`
- `cheatsheets/`
- `docs/`
- `hardware/`
- `replit-cyberops/`
- `wifi-sentinel/`

## Hardware directory

`hardware/README.md` is the centralized purchasing and source directory for security-lab hardware represented in the CYBERSEC TOOLS source and related CyberDatabase research.

It includes manufacturer or reseller links for:

- The Hacker's Hardware Toolkit catalog
- Hak5
- KSEC
- Hacker Warehouse
- Biscuit Shop
- OzHack
- Raspberry Pi 4
- M5Stack Cardputer
- ESP32 development boards
- Proxmark3
- WiFi Pineapple
- ALFA AWUS036ACM
- USB Rubber Ducky
- Bash Bunny
- Shark Jack
- Packet Squirrel Mark II
- LAN Turtle
- O.MG Cable
- Flipper Zero
- HackRF One and HackRF bundles
- iCopy-XS
- KeyGrabber / hardware keyloggers
- USBKill electrical stress-testing hardware
- Sparrows, SouthOrd and KSEC physical-security training tools, practice cylinders, disc-detainer tools, bypass tools, air wedges and lock-pick kits

Technical hardware/IoT notes belong under `knowledge-base/hardware-iot/`. The hardware directory should favor manufacturer stores and authorized distributors where possible, while retaining historical links for discontinued lab devices.

## AI consolidation

The synchronization workflow imports the complete public `m4ckDev/Claude-skills` repository into:

- `AI/Claude-Skills/`

This location preserves the original repository structure, skill definitions, plugin metadata, templates, README files, per-skill licenses, and `THIRD_PARTY_NOTICES.md`. The synchronized source should remain intact so attribution and third-party licensing stay associated with the relevant files.

Related AI material includes `imports/multi-llm-router/` and CyberDatabase-authored AI security material under `knowledge-base/ai-security/`.

## Public repositories consolidated automatically

The synchronization workflow imports complete snapshots of these public repositories under `imports/`:

- `m4ckDev/Offensive-Security`
- `m4ckDev/deepdarkCTI`
- `m4ckDev/waasa-hacker-tool`
- `m4ckDev/Pycharm-projects`
- `m4ckDev/PowerShell-OpsKit`
- `m4ckDev/multi-llm-router`
- `m4ckDev/cyber-games-powershell`
- `m4ckDev/01-cyber-range-blue-team`
- `m4ckDev/02-soc-analyst-simulator`

Each imported repository remains in its own directory so its documentation, notices, and license files remain associated with the original project.

`Pycharm-projects` is retained because it contains scripting, automation, log-analysis and cybersecurity learning material. `multi-llm-router` is retained as AI/automation infrastructure that can support security research and CyberDatabase workflows.

## HackTricks mirror

`references/hacktricks-upstream/` is an automatically refreshed source mirror of the public `HackTricks-wiki/hacktricks` repository. This is kept separate from original CyberDatabase material so upstream attribution, licensing, and provenance remain clear.

CyberDatabase-specific additions and rewritten material should go under `knowledge-base/` rather than modifying the upstream mirror directly.

## External security research sources

Curated third-party research sources are maintained under `references/security-research/` as source-specific subdirectories rather than copied into CyberDatabase-owned documentation.

Current sources:

- `references/security-research/payloads-site/` — Payloads.site web application payload library reference and mapping to `knowledge-base/web-security/`.
- `references/security-research/vx-underground/` — vx-underground papers, platform research, malware-defense material, YARA resources, threat-analysis archives, and research mapping to `knowledge-base/malware-analysis/`, forensics, detection, incident response, Windows, and Linux topics.

Live malware binaries and large malware-sample archives are not mirrored into CyberDatabase. Research indexes, papers, defensive material, source links, and CyberDatabase-authored analysis workflows are kept instead.

## Private repositories intentionally not copied into this public repository

These cybersecurity-related repositories were detected but are private and therefore are not automatically copied into public CyberDatabase:

- `m4ckDev/Hacker-Scripts`
- `m4ckDev/Osiris`
- `m4ckDev/cybersecurity-school-mackinnontech`

This prevents accidental publication of material that was intentionally stored privately. They can be consolidated later if CyberDatabase is made private or after their contents are reviewed for public release.

## Repository layout

```text
CyberDatabase/
├── AI/
│   ├── README.md
│   └── Claude-Skills/
├── CyberDeck/
├── RaspberryCommandCenter/
├── cheatsheets/
├── docs/
├── hardware/
│   └── README.md
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
│   ├── Offensive-Security/
│   ├── deepdarkCTI/
│   ├── waasa-hacker-tool/
│   ├── Pycharm-projects/
│   ├── PowerShell-OpsKit/
│   ├── multi-llm-router/
│   ├── cyber-games-powershell/
│   ├── 01-cyber-range-blue-team/
│   └── 02-soc-analyst-simulator/
├── references/
│   ├── hacktricks-upstream/
│   └── security-research/
│       ├── README.md
│       ├── payloads-site/
│       └── vx-underground/
├── replit-cyberops/
└── wifi-sentinel/
```

## Synchronization

`.github/workflows/sync-cyber-resources.yml` refreshes the Claude Skills snapshot, public project snapshots, and HackTricks mirror. Generated synchronization commits are made by GitHub Actions and are prevented from recursively re-running the same import job.
