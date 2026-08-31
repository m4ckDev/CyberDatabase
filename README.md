<div align="center">

# 🛡️ CyberDatabase

### m4ckDev Cybersecurity Knowledge Base, Labs, Tools & Research

![Cybersecurity](https://img.shields.io/badge/Cybersecurity-Knowledge_Base-blue?style=for-the-badge&logo=hackthebox)
![Linux](https://img.shields.io/badge/Linux-Reference-black?style=for-the-badge&logo=linux)
![Status](https://img.shields.io/badge/Status-Active-success?style=for-the-badge)

**Authorized Security Research and Defensive Use**

</div>

---

CyberDatabase is the central m4ckDev repository for cybersecurity work. It combines original projects, scripts, labs, defensive and offensive-security references, threat intelligence, automation, AI/security tooling, training material, CyberDeck development, a maintained HackTricks source mirror, and curated external security-research sources.

## Repository Map

| Area | Purpose |
|---|---|
| `AI/` | AI, LLM, agent-skill and AI-assisted security tooling, including the Claude Skills collection |
| `CyberDeck/` | CyberDeck platform, API, UI, deployment and operations |
| `RaspberryCommandCenter/` | Raspberry Pi command-center and security tooling |
| `wifi-sentinel/` | Wireless/network monitoring project |
| `replit-cyberops/` | Cyber operations development material |
| `cheatsheets/` | Fast command, protocol and tool references |
| `docs/` | CyberDatabase documentation |
| `knowledge-base/` | Original and expanded CyberDatabase cybersecurity field manual |
| `imports/` | Complete snapshots of related public m4ckDev cybersecurity, scripting and automation repositories |
| `references/hacktricks-upstream/` | Full upstream HackTricks source mirror with provenance kept intact |
| `references/security-research/` | Curated external research sources, including Payloads.site and vx-underground |
| `scripts/build_hacktricks_index.py` | Builds complete CyberDatabase navigation from the upstream HackTricks table of contents |
| `CYBERDATABASE_MANIFEST.md` | Consolidation scope, source list and repository policy |

## AI Hub

`AI/` is the dedicated home for artificial-intelligence and LLM-related CyberDatabase material.

- `AI/Claude-Skills/` contains a complete synchronized snapshot of `m4ckDev/Claude-skills`.
- The synchronization preserves the original skill definitions, plugin metadata, templates, README files, per-skill licenses, and `THIRD_PARTY_NOTICES.md`.
- `imports/multi-llm-router/` remains available as related multi-provider LLM infrastructure.
- CyberDatabase-authored AI/LLM security research belongs under `knowledge-base/ai-security/` or in an appropriate original project under `AI/`.

## Knowledge Base Coverage

The CyberDatabase field manual is organized to cover the full security lifecycle and the major domains represented in HackTricks, external research sources, and the existing m4ckDev repositories:

- Pentesting methodology, scoping, evidence and reporting
- Networking, discovery, enumeration, routing, tunneling and packet analysis
- Services and protocols including DNS, SSH, FTP, SMTP, SMB, LDAP, Kerberos, SNMP, databases and RDP
- Web application and API security
- Linux, Windows and Active Directory security
- AWS, Azure, GCP, containers and Kubernetes
- Mobile, hardware, IoT and wireless security
- Reverse engineering and binary exploitation concepts
- Forensics and malware analysis
- OSINT and cyber threat intelligence
- Blue-team operations, detection engineering and incident response
- Red-team and authorized adversary-emulation references
- Cryptography and PKI
- AI/LLM security and automation
- Remediation, retesting and security reporting

## External Research Sources

CyberDatabase maintains dedicated subdirectories for external resources so links, provenance, and research notes remain separate from original CyberDatabase content.

- `references/security-research/payloads-site/` — links to https://payloads.site/ and maps its SQLi, XSS, LFI/RFI, command-injection, SSRF, and encoding-oriented web-testing material into the CyberDatabase web-security workflow.
- `references/security-research/vx-underground/` — links to https://vx-underground.org/ and organizes its malware papers, Windows/Linux research, YARA material, malware-defense research, threat-analysis archives, and VXUG publications for CyberDatabase use.
- `knowledge-base/malware-analysis/` — CyberDatabase-owned workflow for static triage, isolated dynamic analysis, detection outputs, and research notes informed by sources such as vx-underground.

External malware binaries are not mirrored into CyberDatabase; research indexes, papers, defensive material, and analysis workflows are kept separate from live samples.

## Consolidated Public Projects

The automated synchronization workflow keeps complete snapshots of the following related public repositories inside `imports/`:

- Offensive-Security
- deepdarkCTI
- waasa-hacker-tool
- Pycharm-projects
- PowerShell-OpsKit
- multi-llm-router
- cyber-games-powershell
- 01-cyber-range-blue-team
- 02-soc-analyst-simulator

The Claude Skills repository is synchronized separately to `AI/Claude-Skills/` so AI material has a dedicated top-level location.

Local README, notice and license files remain with each synchronized project.

## HackTricks Reference Mirror

CyberDatabase maintains a source mirror of `HackTricks-wiki/hacktricks` under `references/hacktricks-upstream/`. The mirror is intentionally isolated from CyberDatabase-authored material so attribution, provenance and upstream licensing remain clear.

New CyberDatabase explanations, labs, defensive context, checklists and expanded material belong under `knowledge-base/`.

### HackTricks-Derived Field Guides

CyberDatabase extracts and reorganizes the synchronized source into practical guides instead of relying only on the raw mirror:

- `knowledge-base/hacktricks-derived/` — source map and automatically generated complete upstream navigation
- `knowledge-base/methodology/` — assessment workflow
- `knowledge-base/networking/` — host discovery and scanning
- `knowledge-base/services-and-protocols/` — protocol/service triage
- `knowledge-base/web-security/` — application and API testing workflow
- `knowledge-base/linux/` — Linux hardening and privilege-boundary review
- `knowledge-base/windows/` — Windows hardening and telemetry
- `knowledge-base/forensics/` — host, memory, network, container, and file evidence
- `knowledge-base/malware-analysis/` — malware triage, behavior analysis, and defensive outputs
- `knowledge-base/ai-security/` — LLM, agent, MCP, prompt-injection, model, and AI-system security

The synchronization workflow regenerates `knowledge-base/hacktricks-derived/UPSTREAM_INDEX.md` from the current HackTricks `src/SUMMARY.md`, providing a complete navigable map as upstream content changes.

## Private Repositories

Cybersecurity-related private repositories are not copied automatically into this public repository. This prevents accidental publication of private code or training material. See `CYBERDATABASE_MANIFEST.md` for the detected private repositories and consolidation status.

## Common Ports

| Port | Service | Purpose |
|---:|---|---|
| 21 | FTP | File transfer |
| 22 | SSH | Secure remote administration |
| 23 | Telnet | Unencrypted remote terminal |
| 25 | SMTP | Email transfer |
| 53 | DNS | Name resolution |
| 80 | HTTP | Web traffic |
| 123 | NTP | Time synchronization |
| 389 | LDAP | Directory services |
| 443 | HTTPS | Encrypted web traffic |
| 445 | SMB | Windows file and printer sharing |
| 636 | LDAPS | LDAP over TLS |
| 1433 | MSSQL | Microsoft SQL Server |
| 3306 | MySQL | MySQL database |
| 3389 | RDP | Windows Remote Desktop |
| 5432 | PostgreSQL | PostgreSQL database |
| 8080 | HTTP Alt | Common alternate web service |

## Database Entry Standard

New technical notes should include, when applicable:

```text
Topic
Purpose
Environment / Scope
Commands / Procedure
Expected Result
Evidence / Observations
Security Significance
Detection
Mitigation / Hardening
References / Attribution
```

## Responsible Use

CyberDatabase is intended for cybersecurity education, administration, defense, research, lab work, and authorized security testing. Only assess systems, networks, accounts and applications you own or have explicit permission to test.

Third-party material remains subject to its original license and attribution requirements. Do not remove upstream copyright, attribution or license notices from synchronized content.

---

<div align="center">

**Built and maintained by [m4ckDev](https://github.com/m4ckDev)**

</div>
