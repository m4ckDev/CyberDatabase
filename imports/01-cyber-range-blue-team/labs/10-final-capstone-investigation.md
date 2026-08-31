# Lab 10: Final Capstone Investigation

## Difficulty

Advanced

## Objective

Investigate simulated logs and complete an incident response report.

## Files Used

- All `sample-logs/` files
- `REPORT_TEMPLATE.md`
- `reports/`

## Scenario

You are assigned a final investigation. Use all available sample logs, detection examples, and analyst judgment to write a complete report.

## Tasks

1. Review `sample-logs/capstone.log`.
2. Run all detection scripts.
3. Correlate authentication, web, process, network, FIM, and syslog events.
4. Build a complete timeline.
5. Fill out `REPORT_TEMPLATE.md`.
6. Save your report in `reports/`.
7. Include findings, evidence, severity, confidence, and recommendations.

## Commands to Try

```powershell
python .\scripts\run_all_detections.py
Copy-Item .\REPORT_TEMPLATE.md .\reports\CASE-001-capstone-report.md
```

## Questions

1. What is the strongest finding?
2. What is the weakest finding?
3. What evidence links multiple logs together?
4. What would you recommend next?

## Completion Criteria

- You complete an incident report.
- You support every conclusion with sample log evidence.
- You include a timeline and recommendations.

## Notes

Use only the included sample logs and local Docker lab data. Do not test against outside systems.
