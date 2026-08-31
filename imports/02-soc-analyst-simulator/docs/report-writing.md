# Report Writing

SOC reports must be clear enough for another analyst, an incident commander, or a business owner to act on.

## Recommended Format

```text
Title:
Severity:
Status:
Affected User:
Affected Asset:
Summary:
Evidence Reviewed:
Timeline:
Assessment:
Recommended Actions:
Open Questions:
```

## Quality Checklist

A strong report includes:

- Alert ID and category
- Correct severity
- Affected user and asset
- Timeline of key events
- Evidence reviewed
- Analyst reasoning
- Containment or monitoring recommendation
- Clear closure or escalation decision

## Bad Report Example

```text
Looks suspicious. Need to check it.
```

Problem: It does not explain what happened, what evidence was reviewed, or what action is needed.

## Better Report Example

```text
ALRT-1022 appears high-risk because cfo.mason authenticated from two distant locations within 10 minutes. MFA was approved from the second location, and this alert correlates with ALRT-1021. Recommend revoking active sessions, resetting credentials, and reviewing downstream access.
```
