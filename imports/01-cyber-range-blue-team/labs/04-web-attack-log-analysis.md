# Lab 04: Web Attack Log Analysis

## Difficulty

Intermediate

## Objective

Analyze web access logs for suspicious request patterns in synthetic data.

## Files Used

- `sample-logs/web-access.log`
- `detections/python/detect_web_attacks.py`
- `detections/sigma/web-attack-probe.yml`

## Scenario

The web log contains normal page loads and suspicious-looking request strings. Your job is to identify the suspicious requests and group them by source.

## Tasks

1. Review the web log.
2. Identify status codes and paths.
3. Search for suspicious strings.
4. Run the detection script.
5. Correlate suspicious requests by source IP.

## Commands to Try

```powershell
Get-Content .\sample-logs\web-access.log
Select-String -Path .\sample-logs\web-access.log -Pattern "%27|\.\./|passwd|/admin/debug"
python .\detections\python\detect_web_attacks.py --log .\sample-logs\web-access.log
```

## Questions

1. Which source generated suspicious web requests?
2. Which paths were requested?
3. Were any requests blocked or missing?

## Completion Criteria

- You identify suspicious paths.
- You identify at least one source IP.
- You run the detection script.

## Notes

Use only the included sample logs and local Docker lab data. Do not test against outside systems.
