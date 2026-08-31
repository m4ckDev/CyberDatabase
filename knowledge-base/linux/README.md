# Linux Security and Hardening

This section organizes Linux security material from the synchronized HackTricks `linux-hardening/` tree into a defensive-first review workflow.

## Baseline review

Record:

- distribution, release, kernel, architecture;
- hostname and network interfaces;
- running services and listening sockets;
- local users, groups, and administrative roles;
- package/update status;
- mounted filesystems and mount options;
- security modules such as SELinux/AppArmor;
- firewall configuration;
- logging/audit configuration.

Useful inventory commands:

```bash
uname -a
cat /etc/os-release
id
ss -lntup
ps aux
mount
findmnt
systemctl --type=service --state=running
```

## Privilege boundaries

Review the common ways privilege is delegated or accidentally exposed:

- sudo rules;
- SUID/SGID executables;
- Linux capabilities;
- privileged groups;
- writable executable paths;
- service/unit-file permissions;
- scheduled tasks;
- container/runtime group membership;
- SSH agent forwarding and key handling;
- kernel/module configuration.

Examples for review:

```bash
sudo -l
getcap -r / 2>/dev/null
find / -perm -4000 -type f 2>/dev/null
find / -perm -2000 -type f 2>/dev/null
```

The presence of a privileged binary or capability is not itself a vulnerability. Determine whether an untrusted user can influence execution, configuration, environment, libraries, files, or arguments in a way that crosses a security boundary.

## Files and permissions

Prioritize:

- credentials and private keys;
- configuration files containing secrets;
- writable directories in privileged execution paths;
- world-writable files;
- backup files;
- application `.env` files;
- shell startup files;
- service credentials;
- container socket exposure;
- sensitive logs.

## Services and persistence

Review:

- systemd units and timers;
- cron jobs;
- init scripts;
- package hooks;
- shell startup mechanisms;
- SSH `authorized_keys`;
- application-specific startup tasks.

For each persistence mechanism, verify owner, permissions, execution context, and whether lower-privileged users can modify referenced files.

## Authentication and SSH

Check:

- password policy;
- root login policy;
- key-only vs password authentication;
- stale authorized keys;
- SSH agent forwarding;
- MFA where appropriate;
- failed-login monitoring;
- privilege separation between service and human accounts.

## Containers and virtualization

Membership in container/runtime management groups can be security-sensitive because those interfaces may allow privileged container creation, host filesystem mounting, or other host-level operations.

Treat Docker/LXC/LXD sockets and management APIs as administrative interfaces.

## Kernel and patch posture

Kernel and local privilege-escalation CVEs are highly version- and configuration-dependent. Verify:

- exact kernel/package build;
- vendor backports;
- exploit prerequisites;
- mitigation status;
- reboot requirements.

Do not infer vulnerability solely from a version string without checking distribution advisories.

## Detection and logging

Useful Linux telemetry includes:

- authentication logs;
- sudo logs;
- auditd events;
- process execution;
- systemd service changes;
- cron modifications;
- package installs;
- SSH key changes;
- unexpected listening services;
- filesystem-integrity alerts.

## Source relationship

The complete upstream Linux reference is synchronized at:

`../../references/hacktricks-upstream/src/linux-hardening/`

That source includes Linux privilege-escalation checklists, sudo abuse research, filesystem/inode material, capabilities, SUID/shared-library behavior, kernel/LPE/CVE research, interesting groups, SSH agent topics, and related hardening material.
