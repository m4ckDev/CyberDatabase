# Incident Response Report Template

Use this template for Lab 10 and future practice investigations.

---

## 1. Report Metadata

| Field | Value |
|---|---|
| Report Title |  |
| Analyst Name |  |
| Date Prepared |  |
| Lab Name |  |
| Case ID |  |
| Severity | Low / Medium / High / Critical |
| Confidence | Low / Medium / High |
| Status | Open / Monitoring / Contained / Closed |

---

## 2. Executive Summary

Write a short summary for a non-technical reader.

Include:

- What happened
- When it happened
- What systems or logs were involved
- Current risk level
- Recommended next action

---

## 3. Scope

| Item | Details |
|---|---|
| Systems reviewed |  |
| Log sources reviewed |  |
| Time window reviewed |  |
| Accounts reviewed |  |
| IP addresses reviewed |  |

---

## 4. Key Findings

| Finding # | Finding | Evidence | Severity |
|---:|---|---|---|
| 1 |  |  |  |
| 2 |  |  |  |
| 3 |  |  |  |

---

## 5. Timeline of Events

| Time | Source | Event | Evidence |
|---|---|---|---|
|  |  |  |  |
|  |  |  |  |
|  |  |  |  |

---

## 6. Detection Results

| Detection | Result | Evidence File | Notes |
|---|---|---|---|
| Failed Login Detection |  |  |  |
| Web Attack Log Analysis |  |  |  |
| Suspicious Process Detection |  |  |  |
| File Integrity Monitoring |  |  |  |
| Network Review |  |  |  |

---

## 7. Impact Assessment

Document the likely impact based only on the evidence available in the lab.

- Confirmed impact:
- Suspected impact:
- Unknowns:
- Evidence gaps:

---

## 8. Containment and Remediation Recommendations

For a real environment, recommended actions may include:

- Validate account activity.
- Review endpoint telemetry.
- Preserve logs.
- Reset affected credentials if authorized.
- Patch vulnerable services.
- Improve alerting thresholds.
- Add monitoring for repeated suspicious patterns.

For this lab, list what you would recommend based on the simulated evidence.

---

## 9. Lessons Learned

- What detection worked well?
- What evidence was missing?
- What would improve the investigation?
- What rule or script would you tune?

---

## 10. Final Analyst Statement

Write a clear final conclusion:

> Based on the reviewed sample logs, I assess that...
