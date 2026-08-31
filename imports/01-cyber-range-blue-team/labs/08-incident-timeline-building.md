# Lab 08: Incident Timeline Building

## Difficulty

Advanced

## Objective

Build a chronological incident timeline from multiple sample log sources.

## Files Used

- `sample-logs/capstone.log`
- `sample-logs/auth.log`
- `sample-logs/web-access.log`
- `sample-logs/process.log`
- `sample-logs/fim.log`
- `sample-logs/network.log`

## Scenario

Multiple logs contain events that may be related. Your job is to build a timeline and separate facts from assumptions.

## Tasks

1. Sort `capstone.log` by timestamp.
2. Identify event source for each line.
3. Build a timeline table.
4. Mark each event as fact or hypothesis.
5. Identify missing evidence.

## Commands to Try

```powershell
Get-Content .\sample-logs\capstone.log | Sort-Object
```

## Questions

1. What happened first?
2. Which events are clearly related?
3. Which events need more evidence?

## Completion Criteria

- You create a timeline with at least seven events.
- You separate facts from assumptions.

## Notes

Use only the included sample logs and local Docker lab data. Do not test against outside systems.
