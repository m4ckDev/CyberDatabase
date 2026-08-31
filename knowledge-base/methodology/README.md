# Security Assessment Methodology

This section turns the broader HackTricks methodology material into a repeatable CyberDatabase workflow for authorized assessments and lab work.

## 1. Scope and rules of engagement

Before touching a target, record:

- systems, networks, domains, applications, and accounts that are in scope;
- systems and techniques that are explicitly out of scope;
- testing window and contact information;
- whether denial-of-service, phishing, password spraying, wireless testing, social engineering, or destructive validation is allowed;
- data-handling requirements for credentials, logs, screenshots, packet captures, and exported files.

If a technique is not clearly permitted, treat it as out of scope until permission is confirmed.

## 2. Passive reconnaissance

Start with the lowest-impact sources available. Typical goals are to identify externally visible assets, technology, ownership, naming conventions, exposed metadata, certificate names, public repositories, and published infrastructure relationships.

Record the source and timestamp for every externally derived finding so results can be reproduced later.

## 3. Active discovery

Move from broad discovery to targeted validation:

1. Identify responding hosts or endpoints.
2. Determine exposed ports and protocols.
3. Identify service versions where safely possible.
4. Record operating-system or platform indicators as hypotheses, not facts, until verified.
5. Feed discovered services into protocol-specific enumeration.

For network-specific procedures, see `../networking/host-discovery-and-scanning.md`.

## 4. Service and application enumeration

Enumeration should answer four questions:

- What is exposed?
- What version or implementation appears to be running?
- What authentication or authorization boundary protects it?
- What configuration, data exposure, or trust relationship is visible without exceeding scope?

Use `../services-and-protocols/` for service-oriented notes and `../web-security/` for HTTP/API targets.

## 5. Vulnerability validation

Separate "possible" from "verified." Version strings, scanner output, or banners should not automatically be treated as confirmed vulnerabilities.

For each candidate issue:

- identify the condition required for exploitation;
- confirm the condition is actually present;
- use the least disruptive validation technique available;
- capture evidence that demonstrates impact without unnecessarily exposing or modifying data;
- stop once the finding is proven unless additional testing is specifically required.

## 6. Identity and privilege review

When testing host or directory security, focus on trust boundaries and misconfiguration before attempting high-impact techniques.

Review:

- local and domain group membership;
- service accounts and delegated privileges;
- file and directory permissions;
- scheduled tasks and services;
- authentication protocols and credential-handling practices;
- excessive roles, token permissions, and administrative paths;
- Linux capabilities, sudo configuration, SUID/SGID permissions, and writable execution paths where applicable.

## 7. Lateral movement and segmentation validation

Only perform movement between hosts when explicitly permitted. The goal should be to determine whether a compromised security boundary would allow access to another system, not to maximize compromise.

Record:

- source host/account;
- destination host/account;
- protocol used;
- security control expected to prevent the path;
- why the control did or did not work.

## 8. Evidence collection

Every finding should have enough evidence to stand on its own. Recommended evidence includes:

- timestamp;
- target and source system;
- command or request used;
- relevant response/output;
- screenshot when useful;
- packet capture or log excerpt when needed;
- explanation of why the result matters.

Avoid retaining unnecessary sensitive data.

## 9. Detection and defensive validation

For techniques that are exercised in a lab or authorized environment, ask what defenders should be able to observe:

- process creation;
- authentication events;
- network connections;
- DNS activity;
- PowerShell or shell execution;
- file creation/modification;
- privilege changes;
- endpoint-security alerts;
- SIEM correlation.

This turns offensive validation into detection engineering material.

## 10. Reporting and remediation

A useful finding should include:

- title;
- affected asset(s);
- severity and rationale;
- technical description;
- evidence;
- realistic impact;
- reproduction steps;
- remediation;
- validation/retest procedure;
- references.

Prioritize fixes that remove root causes rather than only blocking one observed technique.

## 11. Retesting

Retesting should verify both the original issue and adjacent failure modes. A patched service may still expose the same risk through a different endpoint, account, role, or protocol.

Document whether the finding is:

- remediated;
- partially remediated;
- still present;
- no longer testable because scope or environment changed.

## Related upstream areas

This workflow is informed by the HackTricks sections covering pentesting methodology, external reconnaissance, network pentesting, Wi-Fi testing, forensic methodology, threat modeling, Linux/Windows hardening, and service-specific testing. The complete source is maintained under `../../references/hacktricks-upstream/`.
