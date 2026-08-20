# 🐧 Linux Security Database

Linux administration and cybersecurity reference.

## Core Areas

- Filesystem navigation and management
- Users and groups
- File ownership and permissions
- Processes and services
- Package management
- Networking and DNS
- SSH administration
- Logging and monitoring
- Firewall configuration
- System hardening

## Quick Commands

```bash
whoami
id
uname -a
ip addr
ip route
ss -tulpn
ps aux
systemctl --failed
journalctl -p err
```

## Security Checks

```bash
sudo ss -tulpn
sudo systemctl --failed
sudo journalctl -p warning
sudo find / -xdev -perm -4000 -type f 2>/dev/null
```

Use commands only on systems you own or are authorized to administer.
