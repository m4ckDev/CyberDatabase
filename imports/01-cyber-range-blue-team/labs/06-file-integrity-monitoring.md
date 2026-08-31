# Lab 06: File Integrity Monitoring

## Difficulty

Intermediate

## Objective

Review simulated file integrity logs and identify sensitive file changes.

## Files Used

- `sample-logs/fim.log`
- `detections/python/detect_file_integrity.py`
- `detections/sigma/file-integrity-sensitive-change.yml`

## Scenario

A file integrity monitoring log shows several file changes. One event targets a sensitive path.

## Tasks

1. Review every file change.
2. Identify expected-looking application changes.
3. Identify sensitive path changes.
4. Run the FIM detection script.
5. Decide what evidence is needed to validate authorization.

## Commands to Try

```powershell
Get-Content .\sample-logs\fim.log
python .\detections\python\detect_file_integrity.py --log .\sample-logs\fim.log
```

## Questions

1. Which sensitive file changed?
2. Which user performed the change?
3. What would you check next in a real environment?

## Completion Criteria

- You identify the sensitive file change.
- You explain why context matters.

## Notes

Use only the included sample logs and local Docker lab data. Do not test against outside systems.
