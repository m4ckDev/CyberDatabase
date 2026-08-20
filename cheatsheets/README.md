# 📋 Cybersecurity Cheat Sheets

Fast-reference commands for administration, troubleshooting, and authorized cybersecurity labs.

## Linux

```bash
ip addr
ip route
ss -tulpn
ps aux
sudo systemctl --failed
sudo journalctl -p err
```

## DNS

```bash
dig example.com
nslookup example.com
cat /etc/resolv.conf
```

## Nmap

```bash
nmap -sn <NETWORK>
nmap <TARGET_IP>
nmap -sV <TARGET_IP>
nmap -p- <TARGET_IP>
sudo nmap -O <TARGET_IP>
```

## Windows PowerShell

```powershell
Get-NetIPAddress
Get-NetRoute
Get-NetTCPConnection
Get-Process
Get-Service
Get-NetFirewallProfile
```

## Wireshark Filters

```text
dns
http
tls
icmp
ip.addr == <IP_ADDRESS>
tcp.port == <PORT>
```

> Replace placeholders with values from your authorized environment.
