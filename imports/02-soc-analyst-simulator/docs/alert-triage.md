# Alert Triage

Alert triage is the process of deciding what deserves attention first.

## Triage Questions

- Is the alert tied to a privileged user?
- Did the activity succeed or only fail?
- Is the asset critical?
- Is there evidence of lateral movement, data access, or persistence?
- Are there multiple alerts tied to the same user, host, or incident ID?

## Priority Guide

| Priority | Indicators |
|---|---|
| P1 | Active compromise, privileged account abuse, data loss, endpoint isolation recommendation |
| P2 | Suspicious successful login, privilege change, abnormal data movement |
| P3 | Failed-only activity, scan-like behavior, unusual but unconfirmed endpoint activity |
| P4 | Low-confidence events, blocked activity, benign known behavior |

## Analyst Mistakes to Avoid

- Treating failed-only activity as confirmed compromise
- Ignoring business criticality
- Failing to correlate alerts by user or asset
- Writing notes that do not support the severity decision
- Closing alerts without a clear containment or monitoring recommendation
