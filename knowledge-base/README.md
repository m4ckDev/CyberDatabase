# CyberDatabase Knowledge Base

This directory contains CyberDatabase-owned cybersecurity documentation, field notes, checklists, methodology, lab guidance, defensive references, and authorized testing material.

Use the topic folders below for original or substantially rewritten CyberDatabase material. Keep third-party source mirrors, link directories, and external research indexes under `../references/` and imported projects under `../imports/` so provenance and licensing remain clear.

## Start here

- `hacktricks-derived/README.md` — mapping between the upstream HackTricks source and the CyberDatabase field manual.
- `hacktricks-derived/UPSTREAM_INDEX.md` — automatically generated complete navigation map of the synchronized HackTricks table of contents.
- `methodology/README.md` — repeatable assessment workflow from scope through retest.
- `networking/host-discovery-and-scanning.md` — host discovery, TCP/UDP scanning, evidence, and defensive interpretation.
- `services-and-protocols/README.md` — service triage and protocol review workflow.
- `web-security/README.md` — web application and API assessment structure, including the Payloads.site external reference.
- `linux/README.md` — Linux security, privilege boundaries, hardening, and detection.
- `windows/README.md` — Windows security, privilege boundaries, hardening, and telemetry.
- `forensics/README.md` — disk, memory, network, host, container, and file-analysis workflow.
- `malware-analysis/README.md` — static/dynamic malware analysis, defensive outputs, and vx-underground research mapping.
- `hardware-iot/README.md` — embedded, hardware, RFID/NFC, SDR, USB and IoT security; links to the CyberDatabase hardware purchasing directory.
- `ai-security/README.md` — LLM, agent, MCP, model-supply-chain, prompt-injection, and AI security guidance.

## Coverage map

- `methodology/` — assessment planning, scoping, workflow, evidence, reporting
- `networking/` — TCP/IP, routing, discovery, packet analysis, segmentation
- `services-and-protocols/` — DNS, DHCP, SSH, FTP, SMTP, SMB, LDAP, Kerberos, SNMP, databases, RDP and other services
- `web-security/` — HTTP/S, APIs, authentication, authorization, OWASP topics, testing and remediation
- `linux/` — administration, enumeration, hardening, logging, privilege concepts
- `windows/` — Windows security, PowerShell, logging, services, hardening
- `active-directory/` — identity, authentication, policy, attack paths, detection and remediation
- `cloud/` — AWS, Azure, GCP, IAM and cloud security
- `containers-kubernetes/` — Docker, containers, Kubernetes and orchestration security
- `mobile/` — Android and iOS security
- `reverse-engineering/` — static and dynamic analysis
- `binary-exploitation/` — memory corruption concepts and controlled lab research
- `forensics/` — disk, memory, host and network forensics
- `malware-analysis/` — safe malware triage, behavior analysis, detection engineering inputs, and reporting
- `osint/` — open-source intelligence methodology and tools
- `threat-intelligence/` — CTI, indicators, ATT&CK mapping and research
- `blue-team/` — monitoring, hardening and defensive operations
- `red-team/` — authorized adversary emulation and validation
- `detection-engineering/` — SIEM, Sigma, YARA, telemetry and detection development
- `incident-response/` — preparation, triage, containment, eradication and recovery
- `cryptography/` — hashing, encryption, PKI and certificate concepts
- `hardware-iot/` — embedded, hardware, RFID/NFC, SDR, USB and IoT security; purchasing links are maintained in `../hardware/README.md`
- `wireless/` — Wi-Fi, Bluetooth and wireless security
- `ai-security/` — LLM, agent, prompt-injection and AI-system security
- `reporting-remediation/` — findings, evidence, severity, remediation and retesting

## Resource directories

External links from the supplied CYBERSEC TOOLS panels are maintained outside the authored knowledge base:

- `../references/resource-directory/TRAINING.md` — certification roadmap, TryHackMe, Hack The Box, OverTheWire, LetsDefend, WiFiChallenge, PortSwigger Academy, W3Schools, CompTIA, OffSec, PECB, BBRadar, TIDE and related direct links.
- `../references/resource-directory/PERSONAL_SECURITY.md` — privacy, hardening, account deletion, secure messaging, search privacy, surveillance defense, disposable email and data-removal resources from the supplied screenshot.
- `../references/threat-intelligence/DARK_WEB_WATCHLIST.md` — defensive public-intelligence references for Exploit.in, DarkNet Army, Verified and BHF.

## Hardware directory

The top-level `../hardware/README.md` contains manufacturer and reseller links for the hardware represented in the CYBERSEC TOOLS source, including Hak5, KSEC, Hacker Warehouse, Biscuit Shop, OzHack, Raspberry Pi, M5Stack, ESP32, Proxmark3, WiFi Pineapple, ALFA adapters, USB Rubber Ducky, Bash Bunny, Shark Jack, Packet Squirrel, LAN Turtle, O.MG Cable, Flipper Zero, HackRF, iCopy-XS, hardware keyloggers, USBKill and physical-security training equipment.

## External research sources

External sources with dedicated CyberDatabase subdirectories are indexed under `../references/security-research/`.

Current sources include:

- `payloads-site/` — web payload and encoding reference mapped into `web-security/`.
- `vx-underground/` — malware papers, defensive research, YARA resources, platform research, threat-analysis archives, and malware-analysis material mapped into `malware-analysis/`, `forensics/`, `windows/`, `linux/`, and detection/IR topics.

## Source relationship

The full upstream HackTricks source mirror is maintained separately at `../references/hacktricks-upstream/`. CyberDatabase uses that source as a reference while building cleaner navigation, expanded explanations, defensive context, lab notes, and original material here.

`scripts/build_hacktricks_index.py` parses the synchronized HackTricks `src/SUMMARY.md` and regenerates `hacktricks-derived/UPSTREAM_INDEX.md` during the repository synchronization workflow. This keeps the CyberDatabase navigation map aligned with upstream additions without rewriting upstream files.
