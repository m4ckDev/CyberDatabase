# Lab 02: Failed Login Detection

## Difficulty

Beginner

## Objective

Detect repeated failed SSH login events in sample authentication logs.

## Files Used

- `sample-logs/auth.log`
- `detections/python/detect_failed_logins.py`
- `detections/sigma/failed-login-threshold.yml`

## Scenario

The authentication log contains several failed SSH login events. Determine whether the failures appear isolated or patterned.

## Tasks

1. Count failed login events.
2. Group failed logins by source IP.
3. Identify targeted usernames.
4. Run the Python detection script.
5. Compare the script output to your manual findings.

## Commands to Try

```powershell
Select-String -Path .\sample-logs\auth.log -Pattern "event=Failed"
python .\detections\python\detect_failed_logins.py --log .\sample-logs\auth.log
```

## Questions

1. Which source IP produced the most failed logins?
2. Which usernames were targeted?
3. Would you escalate this alert? Why?

## Completion Criteria

- You identify the repeated source.
- You document user targets.
- You run the detection script successfully.

## Notes

Use only the included sample logs and local Docker lab data. Do not test against outside systems.
