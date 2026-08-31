# Capstone Case: INC-CAP-9001

The capstone case is a connected incident chain built from alerts `ALRT-1021` through `ALRT-1025`.

## Scenario

A finance executive account shows multiple suspicious events:

1. Failed login spike
2. Successful login after failures
3. Impossible travel
4. Admin role assignment
5. Finance share data transfer spike
6. Endpoint isolation recommendation

## Analyst Objective

Correlate the alerts into one incident and produce a final report.

## Required Actions

- Identify all related alert IDs
- Build one timeline across all capstone events
- Select correct severity for each alert
- Recommend containment actions
- Explain business impact
- Complete report checklist for each alert

## Expected Final Severity

The overall incident should be treated as **Critical** because it includes identity compromise indicators, privilege change, sensitive finance data access, and endpoint containment signals.

## Final Report Prompt

Use this prompt inside your own report:

```text
Write a SOC incident report for INC-CAP-9001. Include the affected user, affected assets, all related alert IDs, key timeline entries, evidence reviewed, severity rationale, containment actions, and open questions.
```
