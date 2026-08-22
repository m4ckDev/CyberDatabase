# CyberDeck Architecture

## High-Level Design

```text
┌─────────────────────────────┐
│        iPhone App           │
│  React Native + Expo        │
│                             │
│ Home | Toolkit | Monitor    │
│              | Learn        │
└──────────────┬──────────────┘
               │ HTTPS
               ▼
┌─────────────────────────────┐
│      CyberDeck API          │
│  Python + FastAPI           │
│  Proxmox LXC                │
└──────────────┬──────────────┘
               │
     ┌─────────┼─────────┐
     │         │         │
     ▼         ▼         ▼
PostgreSQL   Sensor    Lab Agent
Database     Service      Kali
     │         │         │
     ▼         ▼         ▼
Knowledge   Home LAN   Authorized
Logs        Metadata   Lab Testing
Scans
Alerts
```

## Responsibilities

### iPhone App

The iPhone is the user interface and control plane.

It should:

- Display sensor health
- Display traffic metadata
- Display devices
- Display alerts and logs
- Request approved diagnostic/security jobs
- Display structured scan results
- Provide cybersecurity learning content
- Store user favorites and notes

It should not:

- Act as an unrestricted shell
- Require root/jailbreak
- Store raw packet payloads by default
- Contain hard-coded secrets

### CyberDeck API

The API is the central broker.

Responsibilities:

- Authentication
- Authorization
- Job validation
- Target-scope validation
- Database access
- Device and sensor state
- Logging
- Alerts
- Scan-job orchestration
- Learning-content APIs
- Audit trail

### PostgreSQL

Stores:

- Devices
- Networks
- Sensors
- Traffic metadata
- Alerts
- Approved targets
- Scan jobs
- Scan results
- Findings
- Learning articles
- Commands
- Favorites
- Notes
- Audit logs

### Network Sensor

Runs inside the home/lab environment.

Responsibilities:

- Interface statistics
- Device discovery
- Host online/offline tracking
- Traffic metadata where visibility allows
- Authorized network diagnostics
- Structured event reporting

Full-network visibility requires appropriate traffic access such as a mirror/SPAN port, router telemetry, gateway telemetry, or a dedicated sensor path.

### Kali / Lab Agent

Used only for authorized lab work.

Responsibilities:

- Authenticate with CyberDeck
- Accept only allowlisted job types
- Execute approved tools against approved targets
- Return structured results
- Preserve audit information

## Initial Approved Job Types

```text
PING
TRACEROUTE
DNS_LOOKUP
HTTP_HEADERS
TLS_CHECK
HOST_DISCOVERY
PORT_SCAN
SERVICE_SCAN
```

No generic `run command` API should exist.

## Development Connectivity

During development:

```text
iPhone
   |
Tailscale
   |
CyberDeck LXC
```

Production access will use HTTPS and an authenticated API design.

## iOS Distribution Path

```text
Replit
  ↓
React Native / Expo
  ↓
Expo Go
  ↓
EAS Build
  ↓
App Store Connect
  ↓
TestFlight
  ↓
Apple App Review
  ↓
App Store
```
