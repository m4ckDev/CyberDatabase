# Lab 01: Linux Log Review

## Difficulty

Beginner

## Objective

Learn how to read Linux-style sample logs and extract core event fields.

## Files Used

- `sample-logs/syslog.log`
- `sample-logs/auth.log`

## Scenario

You are the first analyst reviewing a small local training server. Your job is to identify what logs exist and what each line is telling you.

## Tasks

1. Open `sample-logs/syslog.log`.
2. Identify timestamps, hostnames, services, and messages.
3. Open `sample-logs/auth.log`.
4. Separate accepted login events from failed login events.
5. Record three log lines that may require follow-up.

## Commands to Try

```powershell
Get-Content .\sample-logs\syslog.log
Get-Content .\sample-logs\auth.log
Select-String -Path .\sample-logs\auth.log -Pattern "event=Failed"
```

## Questions

1. Which log source shows authentication activity?
2. Which fields identify the user and source IP?
3. Which event looks most important and why?

## Completion Criteria

- You can explain the structure of at least two log lines.
- You identify at least one event that deserves review.

## Notes

Use only the included sample logs and local Docker lab data. Do not test against outside systems.
