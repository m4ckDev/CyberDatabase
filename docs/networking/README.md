# 🌐 Networking Database

Reference for networking fundamentals, protocols, troubleshooting, and security analysis.

## Core Topics

- OSI and TCP/IP models
- IPv4 and IPv6
- Subnetting
- MAC addresses and ARP
- TCP and UDP
- DNS and DHCP
- Routing and gateways
- NAT
- VLANs
- Firewalls
- VPNs
- Packet analysis

## Useful Linux Commands

```bash
ip addr
ip route
ip neigh
ss -tulpn
ping -c 4 1.1.1.1
traceroute example.com
dig example.com
nslookup example.com
```

## TCP Connection Basics

```text
Client                Server
  | ---- SYN --------> |
  | <--- SYN/ACK ----- |
  | ---- ACK --------> |
  |   Connection       |
```

## Troubleshooting Order

1. Check interface status.
2. Check IP address.
3. Check default gateway.
4. Test gateway connectivity.
5. Test an external IP address.
6. Test DNS resolution.
7. Check routes and firewall rules.
