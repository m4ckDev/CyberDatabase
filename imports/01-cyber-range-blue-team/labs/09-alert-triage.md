# Lab 09: Alert Triage

## Difficulty

Advanced

## Objective

Review example JSON alerts and make triage decisions.

## Files Used

- `sample-logs/alerts.json`
- `detections/python/triage_alerts.py`

## Scenario

The monitoring system generated alerts. Your job is to prioritize and decide what needs action.

## Tasks

1. Read the JSON alerts.
2. Sort alerts by severity.
3. Review confidence and evidence.
4. Assign each alert a decision: close, monitor, escalate.
5. Explain your decisions.

## Commands to Try

```powershell
Get-Content .\sample-logs\alerts.json
python .\detections\python\triage_alerts.py --alerts .\sample-logs\alerts.json
```

## Questions

1. Which alert is highest priority?
2. Which alert has the strongest evidence?
3. Which alert needs more context?

## Completion Criteria

- You triage all included alerts.
- You justify each decision with evidence.

## Notes

Use only the included sample logs and local Docker lab data. Do not test against outside systems.
