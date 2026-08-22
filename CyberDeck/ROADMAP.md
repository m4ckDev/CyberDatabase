# CyberDeck Build Roadmap

This is the source-of-truth checklist for taking CyberDeck from planning to the Apple App Store.

## Phase 1 - Lock Version 1 Scope

- [ ] Finalize product name: CyberDeck
- [ ] Confirm iPhone-first release
- [ ] Confirm four tabs: Home, Toolkit, Monitor, Learn
- [ ] Confirm backend runs on Proxmox
- [ ] Confirm Replit is used for the mobile app project
- [ ] Confirm React Native + Expo + TypeScript
- [ ] Confirm Python + FastAPI backend
- [ ] Confirm PostgreSQL database
- [ ] Confirm Tailscale for private development connectivity
- [ ] Confirm HTTPS for production API traffic

### Version 1 Home

- [ ] Sensor status
- [ ] Current network
- [ ] Local/public IP information
- [ ] Active device count
- [ ] Alert count
- [ ] Recent scans
- [ ] Live traffic graph

### Version 1 Toolkit

- [ ] Ping
- [ ] Traceroute
- [ ] DNS lookup
- [ ] HTTP header inspection
- [ ] TLS certificate inspection
- [ ] Host discovery
- [ ] Port scan
- [ ] Service/version detection
- [ ] CVE lookup
- [ ] Authorized scope selection

### Version 1 Monitor

- [ ] Device list
- [ ] Online/offline state
- [ ] Traffic metadata
- [ ] Connection history
- [ ] DNS activity where available
- [ ] New-device alerts
- [ ] Traffic spike alerts
- [ ] Searchable logs
- [ ] Export logs

### Version 1 Learn

- [ ] Nmap
- [ ] Linux
- [ ] PowerShell
- [ ] Windows CMD
- [ ] Networking
- [ ] Wireshark
- [ ] tcpdump
- [ ] Burp Suite
- [ ] Metasploit concepts and authorized lab usage
- [ ] Active Directory
- [ ] Web security
- [ ] OWASP
- [ ] SMB
- [ ] SSH
- [ ] DNS
- [ ] SQL
- [ ] Enumeration
- [ ] Privilege escalation concepts
- [ ] Reporting
- [ ] Favorites
- [ ] Personal notes

---

## Phase 2 - Create the Proxmox CyberDeck Container

Create a dedicated LXC container. Do not install application services directly on the Proxmox host.

Initial target configuration:

```text
Name: cyberdeck
OS: Debian 13 or Ubuntu Server
CPU: 4 cores
RAM: 4 GB
Storage: 40 GB
Bridge: vmbr0
```

Tasks:

- [ ] Pick an unused LXC ID
- [ ] Create container
- [ ] Start container
- [ ] Set hostname to `cyberdeck`
- [ ] Update OS packages
- [ ] Assign/reserve stable IP address
- [ ] Enable SSH
- [ ] Install Git
- [ ] Install Python
- [ ] Install PostgreSQL
- [ ] Install network utilities
- [ ] Create CyberDeck service account
- [ ] Create `/opt/cyberdeck`

Planned layout:

```text
/opt/cyberdeck/
├── api/
├── collector/
├── commands/
├── config/
├── exports/
├── knowledge/
├── logs/
└── backups/
```

Checkpoint: The LXC responds over SSH and survives a reboot.

---

## Phase 3 - Build the Backend API

Backend: Python + FastAPI.

Initial API routes:

```text
GET  /api/status
GET  /api/devices
GET  /api/traffic
GET  /api/alerts
GET  /api/logs
GET  /api/knowledge
POST /api/scans
GET  /api/scans/{id}
```

Tasks:

- [ ] Create Python virtual environment
- [ ] Install FastAPI
- [ ] Install Uvicorn
- [ ] Create project structure
- [ ] Add health/status endpoint
- [ ] Add configuration management
- [ ] Add structured logging
- [ ] Run API locally
- [ ] Create systemd service
- [ ] Verify API after container reboot

Checkpoint: `GET /api/status` returns a healthy response.

---

## Phase 4 - Build PostgreSQL Database

Initial tables:

```text
users
sensors
networks
devices
traffic_events
alerts
targets
scan_jobs
scan_results
findings
knowledge_articles
commands
command_examples
favorites
notes
audit_log
```

Tasks:

- [ ] Create PostgreSQL database
- [ ] Create dedicated database user
- [ ] Restrict permissions
- [ ] Create schema/migrations
- [ ] Connect FastAPI to PostgreSQL
- [ ] Create backup routine
- [ ] Test restore procedure

Checkpoint: API can create and retrieve a test device record.

---

## Phase 5 - Build the Network Sensor

Start with metadata, not packet payload storage.

Initial data sources:

- [ ] Interface counters
- [ ] IP configuration
- [ ] ARP/neighbour information
- [ ] Device online/offline status
- [ ] Hostnames where available
- [ ] Bandwidth statistics
- [ ] Authorized Nmap scan results

Potential tools:

```text
ip
ss
arp
nmap
tshark
tcpdump
psutil
```

Do not assume the Proxmox server sees all switched Wi-Fi traffic automatically.

Checkpoint: Devices and sensor health appear through the API.

---

## Phase 6 - Decide Full-Network Visibility Method

Full traffic visibility requires a real sensor path.

Options:

1. Managed-switch SPAN/mirror port to a sensor interface
2. Router telemetry/API integration
3. Gateway/firewall telemetry
4. Dedicated Raspberry Pi sensor connected to mirrored traffic

Tasks:

- [ ] Document current router/switch topology
- [ ] Determine whether port mirroring is available
- [ ] Select least disruptive method
- [ ] Verify only authorized home/lab traffic is monitored
- [ ] Add metadata ingestion to CyberDeck

Checkpoint: Sensor receives the intended network metadata without breaking normal home networking.

---

## Phase 7 - Secure the Backend

- [ ] Tailscale for private development
- [ ] HTTPS
- [ ] API authentication
- [ ] Device tokens
- [ ] Token revocation
- [ ] Rate limiting
- [ ] Server audit logging
- [ ] Firewall rules
- [ ] Secrets outside source code
- [ ] Database backups
- [ ] No unrestricted remote-shell API

CyberDeck should expose approved actions, not arbitrary command execution.

Initial approved action types:

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

Checkpoint: Unauthorized API requests are rejected and recorded.

---

## Phase 8 - Create the Replit iOS Project

Project stack:

```text
React Native
Expo
TypeScript
```

Tasks:

- [ ] Create CyberDeck mobile project in Replit
- [ ] Configure Expo
- [ ] Create Home tab
- [ ] Create Toolkit tab
- [ ] Create Monitor tab
- [ ] Create Learn tab
- [ ] Add navigation
- [ ] Verify app launches before connecting backend

Checkpoint: Four-tab shell runs on iPhone through Expo Go.

---

## Phase 9 - Build the Visual System

Design requirements:

- [ ] OLED-black primary background
- [ ] Glass-style cards
- [ ] Large readable metrics
- [ ] Minimal text
- [ ] Animated live graphs
- [ ] Smooth transitions
- [ ] Haptic feedback
- [ ] Clear online/offline states
- [ ] State-of-the-art but simple interface

Checkpoint: Home screen is usable with one hand and core data is visible at a glance.

---

## Phase 10 - Connect iPhone to Proxmox API

Connect one endpoint at a time.

Order:

1. `/api/status`
2. `/api/devices`
3. `/api/traffic`
4. `/api/alerts`
5. `/api/logs`

Tasks:

- [ ] Configure development API URL
- [ ] Store secrets/tokens securely
- [ ] Show sensor online/offline state
- [ ] Handle server unavailable state
- [ ] Handle authentication failures cleanly

Checkpoint: iPhone displays live server status from Proxmox.

---

## Phase 11 - Build Monitor

- [ ] Live traffic graph
- [ ] Device list
- [ ] Device detail screen
- [ ] Online/offline events
- [ ] Connection metadata
- [ ] Searchable logs
- [ ] New-device alert
- [ ] Traffic spike alert
- [ ] Sensor-offline alert
- [ ] Export capability

Checkpoint: A device event created on the server appears correctly on the phone.

---

## Phase 12 - Build Toolkit

First tools:

- [ ] Ping
- [ ] Traceroute
- [ ] DNS lookup
- [ ] HTTP headers
- [ ] TLS inspection
- [ ] Host discovery
- [ ] Port scan
- [ ] Service detection

Each active-testing action must require an authorized target/scope.

Example scope records:

```text
HOME LAB
10.10.10.0/24

LAB TARGET
10.10.10.50
```

Checkpoint: An approved scan job can be requested from the phone and its result returned through the API.

---

## Phase 13 - Add Kali / Lab Agent

Create a separate CyberDeck agent for authorized lab machines.

Responsibilities:

- [ ] Authenticate to backend
- [ ] Poll or receive approved jobs
- [ ] Execute allowlisted tools
- [ ] Return structured output
- [ ] Record audit trail

Possible tools later:

- Nmap
- Nikto
- Nuclei
- Other approved lab utilities

Checkpoint: Phone requests an approved lab scan, agent executes it, and structured results appear in CyberDeck.

---

## Phase 14 - Build Learn / Cheat Sheets

Every command record should support:

```text
Command
What it does
Syntax
Flags
Example
Explanation
Expected result
Common mistakes
Related commands
Copy
Favorite
Personal notes
```

Tasks:

- [ ] Create knowledge schema
- [ ] Build command search
- [ ] Add category filters
- [ ] Add favorites
- [ ] Add personal notes
- [ ] Add recently viewed
- [ ] Support offline learning content where practical

Checkpoint: Search for `service detection` finds the correct Nmap learning entry.

---

## Phase 15 - Logging and Alerts

Log examples:

```text
Sensor Connected
New Device Detected
Device Offline
Authorized Scan Requested
Scan Completed
Authentication Failure
Traffic Spike
```

Filters:

- [ ] Date
- [ ] Device
- [ ] IP
- [ ] Event
- [ ] Severity
- [ ] Tool

Alerts:

- [ ] New device
- [ ] Traffic spike
- [ ] Sensor offline
- [ ] New open port
- [ ] Device returned online
- [ ] Unusual DNS activity where data supports it
- [ ] Failed login

Checkpoint: Alerts are persistent, searchable, and linked to evidence/log records.

---

## Phase 16 - iOS Security

- [ ] iOS Keychain for secrets
- [ ] Face ID lock option
- [ ] HTTPS only
- [ ] Secure token storage
- [ ] Token expiration/revocation
- [ ] No passwords in logs
- [ ] No embedded API secrets
- [ ] Validate backend certificates
- [ ] Handle Local Network permission only when necessary

Checkpoint: No credentials are stored in plain text.

---

## Phase 17 - Expo Go Testing

Test:

- [ ] Launch
- [ ] Navigation
- [ ] API connectivity
- [ ] Charts
- [ ] Monitor
- [ ] Toolkit
- [ ] Learn
- [ ] Logs
- [ ] Network loss
- [ ] Backend loss
- [ ] Invalid token
- [ ] Slow connection
- [ ] App restart

Checkpoint: Core application works reliably on a physical iPhone.

---

## Phase 18 - Create Production iOS Build

- [ ] Configure Expo Application Services (EAS)
- [ ] Connect Apple Developer account
- [ ] Pick final bundle identifier
- [ ] Configure signing
- [ ] Create production build
- [ ] Upload build to App Store Connect

Checkpoint: Build appears in App Store Connect.

---

## Phase 19 - App Store Connect Setup

- [ ] App name
- [ ] Subtitle
- [ ] Description
- [ ] Category
- [ ] Keywords
- [ ] Support URL
- [ ] Privacy policy URL
- [ ] App icon
- [ ] Screenshots
- [ ] Age rating
- [ ] Privacy disclosures

Checkpoint: App Store Connect record has no missing required metadata.

---

## Phase 20 - Privacy and Review Preparation

Document exactly what CyberDeck processes or stores, including as applicable:

- IP addresses
- Device names
- Network metadata
- Scan results
- Security logs
- Account information

Tasks:

- [ ] Privacy policy
- [ ] App privacy disclosures
- [ ] Privacy manifest where required
- [ ] No ad tracking SDKs in V1
- [ ] Minimize collected data

Checkpoint: Privacy documentation matches actual app behavior.

---

## Phase 21 - Demo Mode for Apple Review

Apple reviewers will not have access to the private home lab.

Create a safe demo mode with simulated:

- [ ] Devices
- [ ] Traffic
- [ ] Alerts
- [ ] Scan results
- [ ] Logs

Checkpoint: Reviewer can exercise all important user-interface features without connecting to the private backend.

---

## Phase 22 - TestFlight

- [ ] Upload production-style beta build
- [ ] Add internal tester
- [ ] Install via TestFlight
- [ ] Test real signing/permissions
- [ ] Test production API configuration
- [ ] Fix crashes and blockers

Checkpoint: CyberDeck works reliably from TestFlight on the iPhone.

---

## Phase 23 - App Store Assets

Prepare screenshots showing:

1. Live Cyber Dashboard
2. Monitor Your Network
3. Discover Your Devices
4. Authorized Security Testing
5. Cybersecurity Command Library
6. Learn Cybersecurity Anywhere

Checkpoint: Screenshots represent actual shipping functionality.

---

## Phase 24 - Submit to Apple

Final checklist:

- [ ] No known crashes
- [ ] Backend available
- [ ] Demo mode works
- [ ] Privacy policy published
- [ ] Support page published
- [ ] Screenshots complete
- [ ] App description complete
- [ ] Privacy disclosures accurate
- [ ] Permissions explained
- [ ] TestFlight successful
- [ ] Review notes explain authorized cybersecurity use

Then submit for App Review.

---

# Active Work Order

Use this order during development:

```text
1. Finalize V1
2. Proxmox LXC
3. FastAPI backend
4. PostgreSQL
5. Network sensor
6. Replit iOS shell
7. iPhone -> Proxmox connection
8. Monitor
9. Toolkit
10. Learn
11. Security/testing
12. TestFlight
13. App Store
```

Do not skip ahead unless a later step is required to unblock the current one.
