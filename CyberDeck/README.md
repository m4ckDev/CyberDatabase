# CyberDeck

CyberDeck is a mobile cybersecurity companion for authorized network monitoring, lab testing, and cybersecurity learning.

## Project Goal

Build a native iOS app that connects securely to a backend running on the Proxmox server. The server handles network monitoring, logs, database storage, and approved cybersecurity tools. The iPhone provides the dashboard, toolkit, alerts, logs, and learning library.

## Version 1 Tabs

- Home
- Toolkit
- Monitor
- Learn

## Core Architecture

```text
iPhone CyberDeck App
        |
      HTTPS
        |
CyberDeck API - Proxmox LXC
        |
  +-----+------------------+
  |                        |
PostgreSQL           Network Sensor
  |                        |
Logs / Knowledge      Home Network
                           |
                     Kali / Lab Agent
```

## Technology Stack

- iOS app: React Native + Expo + TypeScript
- App development: Replit
- Backend: Python + FastAPI
- Database: PostgreSQL
- Hosting: Proxmox LXC
- Private development connectivity: Tailscale
- Production transport: HTTPS
- iOS testing: Expo Go, then TestFlight
- Distribution: Apple App Store

## Safety Model

CyberDeck is designed for systems and networks the user owns or is explicitly authorized to test.

The backend will use allowlisted actions instead of exposing an unrestricted remote shell. Active testing will require an authorized scope or lab target.

## Documentation

See [ROADMAP.md](ROADMAP.md) for the complete start-to-App-Store build plan.

## Current Build Order

1. Finalize V1 scope
2. Create Proxmox CyberDeck container
3. Build FastAPI backend
4. Build PostgreSQL database
5. Build network sensor
6. Create Replit iOS app
7. Connect iPhone to Proxmox API
8. Build Monitor
9. Build Toolkit
10. Build Learn
11. Security and testing
12. TestFlight
13. App Store release
