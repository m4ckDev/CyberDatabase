# Host Discovery and Network Scanning

Use only against systems and ranges you own or are explicitly authorized to assess.

This guide condenses the HackTricks network-pentesting workflow into a CyberDatabase field reference focused on discovery, scanning, evidence, and defensive interpretation.

## Discovery workflow

Start with the least intrusive technique that can answer the question.

### External or routed networks

ICMP is fast when allowed:

```bash
ping -c 1 <IP>
fping -g <CIDR>
nmap -PE -PM -PP -sn -n <CIDR>
```

If ICMP is filtered, use TCP discovery against a small set of common ports or ports relevant to the approved scope.

```bash
nmap -Pn -n --open -p 22,53,80,443,445,3389 <CIDR>
```

For web-focused discovery:

```bash
nmap -Pn -n --open -p 80,443,8000-8100,8443 <CIDR>
```

### Local network discovery

On the same broadcast domain, ARP-based discovery is usually more reliable than ICMP:

```bash
nmap -sn <CIDR>
netdiscover -r <CIDR>
```

Passive observation can reduce noise:

```bash
sudo tcpdump -i <INTERFACE>
```

Useful passive observations include ARP activity, DNS requests, multicast traffic, hostnames, DHCP traffic, and recurring service connections.

## TCP scanning

A TCP SYN probe usually produces one of three useful outcomes:

- SYN/ACK: port is likely open.
- RST/RST-ACK: port is closed.
- No reply or an ICMP filtering response: port may be filtered.

Common Nmap workflows:

```bash
# Common ports with version/default-script/OS discovery
nmap -sV -sC -O -T4 -n -Pn -oA fastscan <IP>

# All TCP ports
nmap -sV -sC -O -T4 -n -Pn -p- -oA fullfastscan <IP>

# Slower all-port pass when aggressive timing causes unreliable results
nmap -sV -sC -O -n -Pn -p- -oA fullscan <IP>
```

Treat OS and version detection as evidence to verify, not absolute truth.

## UDP scanning

UDP is slower and less deterministic because an open UDP service may remain silent unless it receives a protocol-correct request.

Useful starting points:

```bash
# Nmap common UDP services
nmap -sU -sV --version-intensity 0 -n -F -T4 <IP>

# Add default scripts for common services
nmap -sU -sV -sC -n -F -T4 <IP>
```

If the engagement depends on a specific UDP protocol, use a protocol-aware probe rather than assuming that "no response" means "closed."

## Service handoff

Once a port is identified, stop thinking in terms of port numbers and switch to the actual service.

Record:

- IP/hostname;
- transport protocol;
- port;
- detected service;
- product/version evidence;
- TLS certificate details if present;
- authentication boundary;
- relevant protocol-specific notes.

Then move to `../services-and-protocols/`.

## Evidence collection

Prefer Nmap's `-oA` output because it preserves normal, grepable, and XML formats together:

```bash
nmap -sV -sC -n -Pn -oA evidence/target-01 <IP>
```

Keep scans tied to a timestamp, approved scope, and target list. Avoid mixing unrelated environments in the same output file.

## Packet-level validation

When scan results are ambiguous, packet capture can explain what happened:

```bash
sudo tcpdump -ni <INTERFACE> host <IP>
sudo tcpdump -ni <INTERFACE> port <PORT>
```

Packet review can distinguish filtering, resets, retransmissions, routing problems, service responses, and local firewall behavior.

## Defensive interpretation

Discovery and scanning are observable. Defenders can monitor for:

- many connection attempts from one source;
- sequential destination ports;
- one source contacting many hosts;
- unusual ICMP patterns;
- repeated failed connections;
- UDP probes to many uncommon services;
- bursts of DNS, mDNS, NBNS, or SSDP discovery traffic.

Correlate firewall, IDS/IPS, NetFlow, endpoint, and authentication telemetry rather than relying on a single source.

## Recommended sequence

```text
Confirm scope
   -> passive observation where useful
   -> host discovery
   -> common TCP/UDP ports
   -> full TCP scan when justified
   -> service/version validation
   -> protocol-specific enumeration
   -> evidence + detection notes
   -> remediation/retest
```

## Source relationship

Derived and reorganized from the HackTricks `generic-methodologies-and-resources/pentesting-network/` material. The synchronized upstream source remains under `../../references/hacktricks-upstream/src/generic-methodologies-and-resources/pentesting-network/`.
