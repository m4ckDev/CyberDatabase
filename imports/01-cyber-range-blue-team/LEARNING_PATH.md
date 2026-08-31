# Learning Path

This file explains what the learner accomplishes after each module in the `01-cyber-range-blue-team` cyber defense lab.

---

## Before Starting

Read:

1. `README.md`
2. `docs/local-only-safety.md`
3. `docs/architecture.md`
4. `docs/glossary.md`

Goal: understand the lab environment, safety boundaries, and core blue-team vocabulary.

---

## Module 01 — Linux Log Review

**Lab:** `labs/01-linux-log-review.md`

After this module, the learner can:

- Identify basic Linux log fields.
- Locate timestamps, hostnames, services, users, source IPs, and event messages.
- Separate normal activity from entries that need review.
- Capture evidence from logs without changing the original data.

---

## Module 02 — Failed Login Detection

**Lab:** `labs/02-failed-login-detection.md`

After this module, the learner can:

- Find failed SSH login events in sample authentication logs.
- Count repeated failures by source IP and username.
- Explain why repeated authentication failures may require triage.
- Run a basic Python detection script for failed logins.

---

## Module 03 — Suspicious Process Detection

**Lab:** `labs/03-suspicious-process-detection.md`

After this module, the learner can:

- Review process creation telemetry.
- Identify commands that look unusual for a server context.
- Explain why process name alone is not enough for a conclusion.
- Record process evidence in a structured format.

---

## Module 04 — Web Attack Log Analysis

**Lab:** `labs/04-web-attack-log-analysis.md`

After this module, the learner can:

- Read web access logs.
- Identify suspicious request patterns in sample data.
- Separate scanners, malformed requests, and normal page loads in a training dataset.
- Use detection scripts to produce JSON alert output.

---

## Module 05 — Brute-Force Pattern Recognition

**Lab:** `labs/05-brute-force-pattern-recognition.md`

After this module, the learner can:

- Recognize repeated failed login attempts over a time window.
- Group events by source IP, username, and destination service.
- Explain the difference between a single failure and a pattern.
- Create a short analyst note describing the suspected activity.

---

## Module 06 — File Integrity Monitoring

**Lab:** `labs/06-file-integrity-monitoring.md`

After this module, the learner can:

- Interpret simulated file change events.
- Identify changes to sensitive paths in sample telemetry.
- Distinguish expected file changes from unusual ones using context.
- Produce file integrity alerts from sample logs.

---

## Module 07 — Network Connection Review

**Lab:** `labs/07-network-connection-review.md`

After this module, the learner can:

- Review outbound and inbound connection records.
- Identify unusual ports and destinations in a local training dataset.
- Explain what evidence is needed before escalating a connection event.
- Build a connection summary table.

---

## Module 08 — Incident Timeline Building

**Lab:** `labs/08-incident-timeline-building.md`

After this module, the learner can:

- Correlate events from multiple sample log sources.
- Build a chronological timeline.
- Separate facts from assumptions.
- Identify gaps that need follow-up.

---

## Module 09 — Alert Triage

**Lab:** `labs/09-alert-triage.md`

After this module, the learner can:

- Review example JSON alerts.
- Assign severity and confidence.
- Determine whether an alert should be closed, watched, or escalated.
- Write a short triage decision with supporting evidence.

---

## Module 10 — Final Capstone Investigation

**Lab:** `labs/10-final-capstone-investigation.md`

After this module, the learner can:

- Investigate simulated logs from multiple sources.
- Identify suspicious activity across authentication, web, process, network, and file integrity logs.
- Build a complete incident timeline.
- Complete an incident report using `REPORT_TEMPLATE.md`.
- Present findings, scope, impact, and recommendations.

---

## Completion Standard

A learner has completed the project when they can:

- Explain each alert they generated.
- Support findings with log evidence.
- Build a timeline from sample data.
- Complete an incident report without copying an answer key.
- Explain what additional data would be needed in a real environment.
