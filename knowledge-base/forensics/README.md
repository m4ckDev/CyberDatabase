# Forensics and Evidence Analysis

CyberDatabase uses the HackTricks forensic methodology as a source reference, then organizes the material around evidence preservation, repeatability, and defensive investigation.

## Core workflow

1. Define the incident question.
2. Preserve original evidence before analysis.
3. Record acquisition time, source, hashes, and analyst actions.
4. Work from copies whenever possible.
5. Build a timeline from multiple evidence sources.
6. Separate observed facts from analyst interpretation.
7. Preserve commands, queries, filters, and tool versions used to reach conclusions.

## Major evidence areas

### Disk and filesystem

Review:

- partitions and filesystems;
- deleted-file recovery and carving;
- timestamps and metadata;
- suspicious archives and containers;
- filesystem permissions and ownership;
- application-specific artifacts.

### Memory

Memory analysis can reveal information that never reached disk, including running processes, network connections, loaded modules, injected code, handles, command history, credentials/tokens, and other transient state.

Keep acquisition method, operating-system build, and analysis profile/version documented.

### Network and packet captures

PCAP analysis should establish:

- who communicated;
- when communication occurred;
- protocol and destination;
- DNS and name-resolution activity;
- repeated beaconing or unusual periodicity;
- unexpected cleartext data;
- file transfer or data-exfiltration indicators;
- protocol misuse or tunneling behavior.

Wireshark, tshark, tcpdump, Suricata, and protocol-specific tooling can each provide different views of the same capture.

### Windows artifacts

Useful Windows sources commonly include:

- Event Logs;
- Registry hives;
- prefetch and execution artifacts;
- scheduled tasks and services;
- browser history and downloads;
- PowerShell logging;
- authentication and logon events;
- persistence locations;
- filesystem metadata.

### Linux artifacts

Review:

- authentication and system logs;
- shell history;
- cron/systemd persistence;
- package-manager history;
- SSH configuration and keys;
- `/proc` and runtime state when live response is permitted;
- service logs;
- user/group and sudo changes;
- file integrity changes.

### Containers

Container investigations should preserve both workload and host context. Capture:

- image and container identifiers;
- runtime configuration;
- mounts/volumes;
- environment variables and secrets exposure;
- container logs;
- network configuration;
- host-level runtime logs;
- image provenance and layer history.

### Mobile and backup artifacts

The upstream forensic material includes iOS backup analysis and Android-related post-exploitation/malware analysis topics. Mobile evidence handling should account for device state, encryption, backup source, application sandboxing, and platform-specific timestamps.

### File-type and application artifacts

HackTricks includes specialized analysis notes for browser data, Office documents, PDFs, PNGs, ZIP archives, compiled Python artifacts, Discord cache data, local cloud-storage clients, Mach-O/iOS artifacts, SVG/font-related material, audio/video files, and other formats.

Treat file-format parsing as potentially hostile: use isolated analysis environments for suspicious documents and binaries.

## Baseline and file-integrity monitoring

A baseline helps answer "what changed?" Maintain trusted hashes, file metadata, expected processes/services, and configuration snapshots for important systems. Unexpected changes should be correlated with deployment history, administrator activity, endpoint telemetry, and authentication logs before being classified as malicious.

## Evidence record template

```text
Case / Incident:
Evidence ID:
Source system/device:
Acquisition date/time:
Acquisition method:
SHA-256:
Analyst:
Tool/version:
Question being answered:
Commands/queries/filters:
Observed facts:
Interpretation:
Related evidence:
```

## Source relationship

The synchronized HackTricks forensic source is under:

`../../references/hacktricks-upstream/src/generic-methodologies-and-resources/basic-forensic-methodology/`

That source includes baseline monitoring, anti-forensics, Docker forensics, image acquisition, iOS backup forensics, Linux forensics, malware analysis, memory analysis, filesystem carving, PCAP inspection, file-format analysis, and Windows artifacts.
