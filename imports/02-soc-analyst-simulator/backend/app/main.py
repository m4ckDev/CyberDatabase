import json
from datetime import datetime, timezone
from typing import Literal

from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel, Field

from .database import get_connection, init_db, row_to_dict
from .scoring import calculate_score

app = FastAPI(
    title="SOC Analyst Simulator API",
    version="1.0.0",
    description="Defensive-only SOC training simulator with alert triage, notes, timeline, evidence placeholders, and scoring.",
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["http://localhost:5173", "http://127.0.0.1:5173", "*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


class NoteRequest(BaseModel):
    note: str = Field(min_length=3, max_length=2000)


class TimelineRequest(BaseModel):
    entry: str = Field(min_length=3, max_length=2000)


class EvidenceRequest(BaseModel):
    name: str = Field(min_length=3, max_length=200)
    description: str = Field(default="Placeholder evidence metadata only", max_length=1000)


class TriageRequest(BaseModel):
    selected_severity: Literal["Low", "Medium", "High", "Critical"]
    selected_steps: list[str]
    selected_report_items: list[str]
    notes: list[str] = []


@app.on_event("startup")
def startup_event() -> None:
    init_db()


@app.get("/health")
def health() -> dict:
    return {"status": "ok", "service": "soc-analyst-simulator"}


@app.get("/alerts")
def list_alerts(status: str | None = None, incident_id: str | None = None) -> list[dict]:
    query = "SELECT * FROM alerts"
    clauses = []
    params = []
    if status:
        clauses.append("status = ?")
        params.append(status)
    if incident_id:
        clauses.append("incident_id = ?")
        params.append(incident_id)
    if clauses:
        query += " WHERE " + " AND ".join(clauses)
    query += " ORDER BY timestamp ASC"

    with get_connection() as conn:
        rows = conn.execute(query, params).fetchall()
    return [row_to_dict(row) for row in rows]


@app.get("/alerts/{alert_id}")
def get_alert(alert_id: str) -> dict:
    with get_connection() as conn:
        row = conn.execute("SELECT * FROM alerts WHERE id = ?", (alert_id,)).fetchone()
    alert = row_to_dict(row)
    if not alert:
        raise HTTPException(status_code=404, detail="Alert not found")
    return alert


@app.post("/alerts/{alert_id}/notes")
def add_note(alert_id: str, request: NoteRequest) -> dict:
    alert = get_alert(alert_id)
    notes = alert.get("notes", [])
    notes.append(request.note)
    with get_connection() as conn:
        conn.execute("UPDATE alerts SET notes = ? WHERE id = ?", (json.dumps(notes), alert_id))
    return get_alert(alert_id)


@app.post("/alerts/{alert_id}/timeline")
def add_timeline(alert_id: str, request: TimelineRequest) -> dict:
    alert = get_alert(alert_id)
    entries = alert.get("timeline_entries", [])
    entries.append(request.entry)
    with get_connection() as conn:
        conn.execute("UPDATE alerts SET timeline_entries = ? WHERE id = ?", (json.dumps(entries), alert_id))
    return get_alert(alert_id)


@app.post("/alerts/{alert_id}/evidence")
def add_evidence(alert_id: str, request: EvidenceRequest) -> dict:
    alert = get_alert(alert_id)
    evidence_items = alert.get("evidence_items", [])
    evidence_items.append({"name": request.name, "description": request.description})
    with get_connection() as conn:
        conn.execute("UPDATE alerts SET evidence_items = ? WHERE id = ?", (json.dumps(evidence_items), alert_id))
    return get_alert(alert_id)


@app.post("/alerts/{alert_id}/triage")
def submit_triage(alert_id: str, request: TriageRequest) -> dict:
    alert = get_alert(alert_id)
    combined_notes = alert.get("notes", []) + request.notes
    result = calculate_score(
        recommended_severity=alert["recommended_severity"],
        selected_severity=request.selected_severity,
        expected_steps=alert["expected_steps"],
        selected_steps=request.selected_steps,
        report_checklist=alert["report_checklist"],
        selected_report_items=request.selected_report_items,
        notes=combined_notes,
    )
    completed_at = datetime.now(timezone.utc).isoformat()
    with get_connection() as conn:
        conn.execute(
            """
            UPDATE alerts
            SET selected_severity = ?, selected_steps = ?, selected_report_items = ?, notes = ?,
                score = ?, score_summary = ?, status = 'Completed', completed_at = ?
            WHERE id = ?
            """,
            (
                request.selected_severity,
                json.dumps(request.selected_steps),
                json.dumps(request.selected_report_items),
                json.dumps(combined_notes),
                result.score,
                result.summary,
                completed_at,
                alert_id,
            ),
        )
    completed_alert = get_alert(alert_id)
    completed_alert["score_breakdown"] = {
        "severity_points": result.severity_points,
        "investigation_step_points": result.step_points,
        "report_quality_points": result.report_points,
        "notes_points": result.notes_points,
    }
    return completed_alert


@app.get("/cases/completed")
def completed_cases() -> list[dict]:
    with get_connection() as conn:
        rows = conn.execute("SELECT * FROM alerts WHERE status = 'Completed' ORDER BY completed_at DESC").fetchall()
    return [row_to_dict(row) for row in rows]


@app.get("/capstone")
def capstone() -> dict:
    with get_connection() as conn:
        rows = conn.execute("SELECT * FROM alerts WHERE incident_id = 'INC-CAP-9001' ORDER BY timestamp ASC").fetchall()
    alerts = [row_to_dict(row) for row in rows]
    return {
        "incident_id": "INC-CAP-9001",
        "title": "Finance Executive Account Compromise Simulation",
        "objective": "Correlate identity, privilege, data movement, and endpoint alerts into one incident report.",
        "alerts": alerts,
    }


@app.get("/endpoints")
def list_endpoints() -> list[dict]:
    with get_connection() as conn:
        rows = conn.execute("SELECT * FROM endpoints ORDER BY criticality DESC, hostname ASC").fetchall()
    return [dict(row) for row in rows]


@app.get("/users")
def list_users() -> list[dict]:
    with get_connection() as conn:
        rows = conn.execute("SELECT * FROM users ORDER BY risk DESC, username ASC").fetchall()
    return [dict(row) for row in rows]


@app.post("/reset")
def reset_simulator() -> dict:
    with get_connection() as conn:
        conn.execute("DELETE FROM alerts")
        conn.execute("DELETE FROM endpoints")
        conn.execute("DELETE FROM users")
    init_db()
    return {"status": "reset", "message": "Simulator data reseeded."}
