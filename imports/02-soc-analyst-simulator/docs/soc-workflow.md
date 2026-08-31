# SOC Workflow

The SOC workflow in this simulator follows a defensive analyst pattern.

## 1. Intake

Review the alert title, category, source, asset, user, and timestamp.

Ask:

- What triggered the alert?
- Which user or asset is involved?
- Is the asset business critical?
- Is the alert isolated or correlated with others?

## 2. Triage

Decide whether the alert is likely benign, suspicious, or high-risk.

Prioritize:

1. Critical identity compromise indicators
2. Privileged access changes
3. Endpoint isolation recommendations
4. Data movement or exfiltration indicators
5. Web and network anomalies
6. Low-confidence noise

## 3. Investigation

Use the alert's expected evidence placeholders as a guide.

Common investigation areas:

- Authentication history
- MFA status
- Endpoint process tree
- Network destination metadata
- Web request pattern
- Data transfer volume
- Change ticket validation
- User or owner confirmation

## 4. Case Notes

Good notes are short, factual, and decision-focused.

Example:

> Reviewed login sequence for cfo.mason. Alert appears correlated with impossible travel and data transfer spike. MFA was approved from unfamiliar location. Recommend session revocation and incident escalation.

## 5. Timeline

A timeline turns scattered events into a story.

Minimum useful timeline fields:

- Time
- Event
- Source
- Impact
- Analyst interpretation

## 6. Report

The final report should answer:

- What happened?
- Who or what was affected?
- What evidence supports the conclusion?
- What was the business impact?
- What containment or recovery action is recommended?
