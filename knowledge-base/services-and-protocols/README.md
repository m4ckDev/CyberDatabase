# Services and Protocols

HackTricks contains a large protocol-by-protocol service testing library. CyberDatabase uses this folder as the faster service triage layer before diving into the full synchronized upstream references.

## Service triage checklist

For every exposed service, capture:

- IP/hostname and port;
- TCP or UDP;
- detected protocol and implementation;
- version/banner evidence;
- whether encryption/TLS is used;
- certificate subject/SAN/issuer/expiry when applicable;
- whether anonymous or unauthenticated access exists;
- authentication mechanism;
- default, guest, legacy, or weak configuration indicators;
- exposed metadata, shares, namespaces, queues, databases, APIs, or management interfaces;
- logging/detection opportunities;
- hardening recommendation.

## Common service families

| Service family | Common ports/examples | Review focus |
|---|---|---|
| DNS | 53 TCP/UDP | recursion, zone-transfer exposure, record leakage, DNSSEC, logging |
| FTP | 21 | anonymous access, cleartext credentials, writable content, TLS support |
| SSH | 22 | version, authentication methods, weak algorithms, exposed management access |
| SMTP | 25/465/587 | relay configuration, user enumeration, STARTTLS/TLS, authentication |
| HTTP/S | 80/443/8080/8443 | application/API security, headers, TLS, authentication, authorization |
| RPC/MSRPC | 111/135 | exposed RPC services, interface enumeration, firewall boundaries |
| NetBIOS/SMB | 137-139/445 | shares, signing, guest access, identity exposure, legacy protocol support |
| LDAP/LDAPS | 389/636 | anonymous bind, directory exposure, TLS, access controls |
| Kerberos | 88 | realm/domain mapping, policy, identity attack surface, logging |
| SNMP | 161/162 UDP | version, community/access policy, exposed device data, write access |
| RDP | 3389 | NLA, exposure, TLS/certificates, MFA, account lockout, logging |
| MSSQL | 1433 | authentication mode, exposed databases, roles, encryption |
| MySQL | 3306 | network exposure, users/privileges, TLS, anonymous/default accounts |
| PostgreSQL | 5432 | `pg_hba.conf` policy, roles, TLS, network exposure |
| Oracle listener | 1521/1522/1529 | listener exposure, service names, authentication, patch posture |
| MongoDB | 27017/27018 | authentication, bind address, TLS, exposed databases |
| Redis | 6379 | authentication/ACLs, bind policy, TLS, dangerous administrative exposure |
| Memcached | 11211 | public exposure, UDP exposure, authentication limitations |
| MQTT | 1883/8883 | anonymous subscription/publish, ACLs, TLS, topic exposure |
| Docker API | 2375/2376 | unauthenticated daemon access, TLS client auth, network exposure |
| Docker Registry | 5000 | anonymous pull/push, catalog exposure, TLS, image trust |
| Kubernetes API | 6443 and environment-specific | anonymous access, RBAC, service-account tokens, admission controls |
| SOCKS/proxies | 1080/3128 | open proxy behavior, authentication, egress controls |
| iSCSI | 3260 | target exposure, CHAP, storage authorization |
| mDNS/SSDP/WSD | 5353/1900/3702 UDP | local discovery leakage, device identification, segmentation |
| ICS/OT protocols | BACnet, EtherNet/IP, OPC UA and others | exposure, segmentation, authentication, safety constraints |

## Workflow

```text
Port discovered
  -> validate protocol
  -> collect banner/version/TLS evidence
  -> identify authentication boundary
  -> enumerate only within scope
  -> review configuration and exposure
  -> check logs/detection
  -> document hardening
```

## Service-specific source library

The full HackTricks service collection is synchronized under:

`../../references/hacktricks-upstream/src/network-services-pentesting/`

That upstream directory currently includes material for classic infrastructure protocols, databases, message queues, proxies, remote-management services, container interfaces, storage protocols, industrial/OT protocols, and many specialized services.

Use `../hacktricks-derived/UPSTREAM_INDEX.md` for a generated complete table-of-contents view after synchronization.
