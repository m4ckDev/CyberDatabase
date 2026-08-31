# HackTricks-Derived CyberDatabase Guides

CyberDatabase maintains two separate layers for HackTricks material:

1. `references/hacktricks-upstream/` — a synchronized source mirror of the upstream HackTricks repository.
2. `knowledge-base/` — CyberDatabase-authored indexes, summaries, field guides, defensive context, and lab-oriented notes derived from research across the upstream material.

This separation keeps source provenance clear while allowing CyberDatabase to reorganize the material into a practical field manual.

## Current upstream baseline

The current HackTricks repository uses an mdBook-style `src/` tree. At the time this guide was created, the upstream `master` branch resolved to commit `b461dce2d562b47fe853da1674b0bd6dbfe87650`.

The upstream source contains major top-level areas for:

- AI security and AI-assisted security research
- Binary exploitation
- Blockchain and Web3 security
- Cryptography
- Generic hacking references
- Pentesting methodologies and resources
- Hardware and physical-access security
- Linux hardening and privilege-escalation research
- macOS hardening
- Mobile pentesting
- Network service pentesting
- Web pentesting
- Reverse engineering
- Steganography
- Windows hardening and privilege-escalation research

HackTricks also contains detailed methodology material for external reconnaissance, network discovery and scanning, Wi-Fi testing, threat modeling, forensic analysis, protocol/service enumeration, and many specialized technology-specific topics.

## CyberDatabase mapping

| HackTricks source area | CyberDatabase destination |
|---|---|
| `generic-methodologies-and-resources/` | `knowledge-base/methodology/`, `networking/`, `forensics/`, `wireless/`, `osint/` |
| `network-services-pentesting/` | `knowledge-base/services-and-protocols/` |
| `pentesting-web/` | `knowledge-base/web-security/` |
| `linux-hardening/` | `knowledge-base/linux/` |
| `windows-hardening/` | `knowledge-base/windows/` and `active-directory/` |
| `macos-hardening/` | `knowledge-base/macos/` when expanded |
| `mobile-pentesting/` | `knowledge-base/mobile/` |
| `binary-exploitation/` | `knowledge-base/binary-exploitation/` |
| `reversing/` | `knowledge-base/reverse-engineering/` |
| `crypto/` | `knowledge-base/cryptography/` |
| `hardware-physical-access/` | `knowledge-base/hardware-iot/` |
| `AI/` | `knowledge-base/ai-security/` |
| `blockchain/` | `knowledge-base/blockchain/` when expanded |
| `stego/` | `knowledge-base/forensics/` / `cryptography/` depending on topic |

## Complete navigation

`UPSTREAM_INDEX.md` is generated automatically from the synchronized upstream `src/SUMMARY.md` by `scripts/build_hacktricks_index.py`.

The generated index points to every navigable entry present in the upstream HackTricks table of contents. This gives CyberDatabase a complete searchable map without mixing CyberDatabase-authored notes with upstream source files.

## How to use this area

Use the upstream mirror when you need the original reference. Use the CyberDatabase knowledge-base folders when you need a shorter operational workflow, defensive context, lab checklist, or a topic reorganized for faster navigation.

When expanding CyberDatabase from an upstream topic:

- paraphrase and reorganize rather than disguising copied text as original work;
- include the source path or upstream project in the References section;
- preserve any upstream or third-party license requirements;
- add detection, hardening, remediation, evidence collection, or lab context where useful;
- keep destructive or intrusive testing limited to systems and ranges explicitly authorized for assessment.

## Source and attribution

Upstream project: `HackTricks-wiki/hacktricks`

Original HackTricks material remains subject to its upstream licensing and attribution requirements. The synchronized mirror retains the upstream license and source structure. CyberDatabase additions in this directory are intended as independently organized notes and navigation around that material.
