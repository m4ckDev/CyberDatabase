# Incident Severity

Severity reflects impact, urgency, and confidence.

## Severity Levels

| Severity | Meaning | Example |
|---|---|---|
| Critical | Active or likely compromise with major business impact | Privileged account abuse plus data transfer spike |
| High | Strong suspicious signal involving sensitive account, asset, or data | Impossible travel with successful login |
| Medium | Suspicious activity requiring investigation but limited confirmed impact | Rare outbound connection or unknown file hash |
| Low | Low-confidence activity, blocked activity, or noisy reconnaissance | Multiple 404s without successful access |

## Severity Decision Formula

Severity is based on:

```text
Severity = Impact + Confidence + Urgency + Business Criticality
```

## Escalation Rules

Escalate when:

- A privileged account is involved
- A critical server is involved
- Multiple alerts share one user, endpoint, or incident ID
- Data transfer or sensitive file access occurs
- Endpoint isolation is recommended
- The analyst cannot rule out compromise with available evidence
