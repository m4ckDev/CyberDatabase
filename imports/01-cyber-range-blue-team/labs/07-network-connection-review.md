# Lab 07: Network Connection Review

## Difficulty

Intermediate

## Objective

Review sample network connection logs and flag unusual destination ports.

## Files Used

- `sample-logs/network.log`
- `detections/python/detect_network_connections.py`
- `detections/sigma/network-unusual-port.yml`

## Scenario

Network connection records include normal service traffic and one unusual destination port. Your job is to review without jumping to conclusions.

## Tasks

1. Review all connection records.
2. List source, destination, destination port, protocol, and process.
3. Identify unusual ports.
4. Run the detection script.
5. Correlate the process field with process logs.

## Commands to Try

```powershell
Get-Content .\sample-logs\network.log
python .\detections\python\detect_network_connections.py --log .\sample-logs\network.log
```

## Questions

1. Which destination port stands out?
2. Which process is associated with it?
3. What additional evidence would increase confidence?

## Completion Criteria

- You build a connection summary.
- You identify unusual traffic and explain confidence level.

## Notes

Use only the included sample logs and local Docker lab data. Do not test against outside systems.
