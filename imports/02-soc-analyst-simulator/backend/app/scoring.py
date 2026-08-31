from __future__ import annotations

from dataclasses import dataclass


@dataclass
class ScoreResult:
    score: int
    summary: str
    severity_points: int
    step_points: int
    report_points: int
    notes_points: int


def normalize_list(items: list[str]) -> set[str]:
    return {item.strip().lower() for item in items if item and item.strip()}


def calculate_score(
    recommended_severity: str,
    selected_severity: str,
    expected_steps: list[str],
    selected_steps: list[str],
    report_checklist: list[str],
    selected_report_items: list[str],
    notes: list[str],
) -> ScoreResult:
    severity_points = 30 if selected_severity.lower() == recommended_severity.lower() else 0

    expected_step_set = normalize_list(expected_steps)
    selected_step_set = normalize_list(selected_steps)
    matched_steps = expected_step_set.intersection(selected_step_set)
    step_points = int((len(matched_steps) / max(len(expected_step_set), 1)) * 40)

    report_set = normalize_list(report_checklist)
    selected_report_set = normalize_list(selected_report_items)
    matched_report_items = report_set.intersection(selected_report_set)
    report_points = int((len(matched_report_items) / max(len(report_set), 1)) * 20)

    useful_notes = [note for note in notes if len(note.strip()) >= 20]
    notes_points = 10 if useful_notes else 0

    score = severity_points + step_points + report_points + notes_points

    misses = []
    if severity_points == 0:
        misses.append(f"Severity should be {recommended_severity}.")

    missed_steps = sorted(expected_step_set - selected_step_set)
    if missed_steps:
        misses.append("Missing investigation steps: " + "; ".join(missed_steps) + ".")

    missed_report = sorted(report_set - selected_report_set)
    if missed_report:
        misses.append("Missing report checklist items: " + "; ".join(missed_report) + ".")

    if notes_points == 0:
        misses.append("Add at least one analyst note with a clear observation or decision.")

    if not misses:
        summary = "Excellent triage. Severity, investigation steps, notes, and report checklist matched the expected outcome."
    else:
        summary = " ".join(misses)

    return ScoreResult(
        score=score,
        summary=summary,
        severity_points=severity_points,
        step_points=step_points,
        report_points=report_points,
        notes_points=notes_points,
    )
