# Bash One-Liners for Defensive Log Review

Run these from the repository root on Linux, macOS, WSL, or Git Bash.

These commands review **included sample logs only**.

---

## 1. Show Failed SSH Login Events

```bash
grep "event=Failed" sample-logs/auth.log
```

## 2. Count Failed Login Events by Source IP

```bash
grep "event=Failed" sample-logs/auth.log | awk -F"src=" '{print $2}' | awk '{print $1}' | sort | uniq -c | sort -nr
```

## 3. List Targeted Usernames in Failed Logins

```bash
grep "event=Failed" sample-logs/auth.log | awk -F"user=" '{print $2}' | awk '{print $1}' | sort | uniq -c | sort -nr
```

## 4. Find Suspicious Web Requests

```bash
grep -Ei "%27|\.\./|passwd|/admin/debug" sample-logs/web-access.log
```

## 5. Count Web Requests by Source IP

```bash
awk -F"src=" '{print $2}' sample-logs/web-access.log | awk '{print $1}' | sort | uniq -c | sort -nr
```

## 6. Find Shell-Like Process Events

```bash
grep -Ei "process=sh|process=bash|whoami|cmd=\"id\"" sample-logs/process.log
```

## 7. Review Sensitive File Changes

```bash
grep -E "/etc/ssh/sshd_config|/etc/passwd|/etc/shadow" sample-logs/fim.log
```

## 8. Find Unusual Network Destination Ports

```bash
grep -E "dport=4444|dport=1337|dport=6667" sample-logs/network.log
```

## 9. Build a Basic Capstone Timeline

```bash
sort sample-logs/capstone.log
```

## 10. Extract All Events for One Source IP

```bash
grep "203.0.113.45" sample-logs/*.log
```

---

## PowerShell Equivalents

```powershell
Select-String -Path .\sample-logs\auth.log -Pattern "event=Failed"
Select-String -Path .\sample-logs\web-access.log -Pattern "%27|\.\./|passwd|/admin/debug"
Select-String -Path .\sample-logs\process.log -Pattern "process=sh|process=bash|whoami"
Select-String -Path .\sample-logs\fim.log -Pattern "/etc/ssh/sshd_config|/etc/passwd|/etc/shadow"
Select-String -Path .\sample-logs\network.log -Pattern "dport=4444|dport=1337|dport=6667"
```
