# Lab 03: Suspicious Process Detection

## Difficulty

Beginner to Intermediate

## Objective

Review process telemetry and identify suspicious shell-like process events.

## Files Used

- `sample-logs/process.log`
- `detections/python/detect_suspicious_processes.py`
- `detections/sigma/suspicious-process.yml`

## Scenario

A process log contains normal service activity and one event that requires deeper review.

## Tasks

1. Review every process event.
2. Identify normal service processes.
3. Identify shell-like process events.
4. Run the suspicious process detection script.
5. Write down why the event is suspicious but not automatically conclusive.

## Commands to Try

```powershell
Get-Content .\sample-logs\process.log
python .\detections\python\detect_suspicious_processes.py --log .\sample-logs\process.log
```

## Questions

1. Which user launched the suspicious process?
2. What command was recorded?
3. What other logs should be checked next?

## Completion Criteria

- You identify the suspicious process event.
- You explain what evidence is still missing.

## Notes

Use only the included sample logs and local Docker lab data. Do not test against outside systems.
