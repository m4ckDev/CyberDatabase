# Lab 05: Brute-Force Pattern Recognition

## Difficulty

Intermediate

## Objective

Recognize repeated login failure patterns across sample authentication data.

## Files Used

- `sample-logs/auth.log`
- `detections/sigma/brute-force-pattern.yml`

## Scenario

A single failed login may be normal. A repeated cluster may indicate a brute-force-like pattern in the sample data.

## Tasks

1. Find all failed login events.
2. Sort by timestamp.
3. Count failures by source IP.
4. Count targeted usernames.
5. Decide whether the pattern should be escalated.

## Commands to Try

```powershell
Select-String -Path .\sample-logs\auth.log -Pattern "event=Failed"
python .\detections\python\detect_failed_logins.py --threshold 5
```

## Questions

1. What makes this a pattern instead of a single event?
2. Which fields are most useful?
3. What threshold would you choose for a small lab?

## Completion Criteria

- You define a pattern using count, source, users, and time.
- You provide an analyst decision.

## Notes

Use only the included sample logs and local Docker lab data. Do not test against outside systems.
