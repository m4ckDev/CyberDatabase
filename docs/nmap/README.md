# 🔎 Nmap Database

Nmap reference for authorized network discovery and service enumeration.

## Host Discovery

```bash
nmap -sn <NETWORK>
```

Example lab network:

```bash
nmap -sn 192.168.1.0/24
```

## Basic Port Scan

```bash
nmap <TARGET_IP>
```

## Service Detection

```bash
nmap -sV <TARGET_IP>
```

## Operating System Detection

```bash
sudo nmap -O <TARGET_IP>
```

## All TCP Ports

```bash
nmap -p- <TARGET_IP>
```

## Save Results

```bash
nmap -sV -oA scans/target-services <TARGET_IP>
```

`-oA` saves normal, XML, and grepable output.

## Result Classification

Do not treat an open port as a vulnerability by itself. Record the port, service, detected version, evidence, security significance, validation steps, and remediation separately.

> Only scan systems and networks you own or have explicit permission to test.
