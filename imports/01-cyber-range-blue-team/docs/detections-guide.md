# Detection Guide

The project includes three detection formats.

## 1. Sigma-Style Rules

Location:

```text
detections/sigma/
```

These are readable YAML examples inspired by Sigma rule structure. They are designed for learning and can be adapted to a SIEM later.

## 2. Python Detection Scripts

Location:

```text
detections/python/
```

These scripts parse sample logs and generate alerts. They are intentionally simple and readable.

Run all detections:

```powershell
python .\scripts\run_all_detections.py
```

Run one detection:

```powershell
python .\detections\python\detect_failed_logins.py --log .\sample-logs\auth.log
```

## 3. Bash One-Liners

Location:

```text
detections/bash/one-liners.md
```

These commands teach quick terminal-based review techniques.

## Alert Fields

Example alerts include:

| Field | Meaning |
|---|---|
| `rule_id` | Detection identifier |
| `title` | Human-readable alert name |
| `severity` | Low, medium, high, or critical |
| `confidence` | Low, medium, or high |
| `source_log` | Log file that triggered the alert |
| `evidence` | Matching event data |
| `recommendation` | Suggested analyst action |
