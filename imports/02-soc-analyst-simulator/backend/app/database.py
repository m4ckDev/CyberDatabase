import json
import sqlite3
from pathlib import Path
from typing import Any

from .seed_data import ALERTS, ENDPOINTS, USERS

BASE_DIR = Path(__file__).resolve().parent.parent
DATA_DIR = BASE_DIR / "data"
DB_PATH = DATA_DIR / "soc_simulator.sqlite3"


def get_connection() -> sqlite3.Connection:
    DATA_DIR.mkdir(parents=True, exist_ok=True)
    conn = sqlite3.connect(DB_PATH)
    conn.row_factory = sqlite3.Row
    return conn


def row_to_dict(row: sqlite3.Row | None) -> dict[str, Any] | None:
    if row is None:
        return None
    item = dict(row)
    for key in ["expected_steps", "report_checklist", "evidence", "timeline", "selected_steps", "selected_report_items", "notes", "timeline_entries", "evidence_items"]:
        if key in item and isinstance(item[key], str):
            try:
                item[key] = json.loads(item[key]) if item[key] else []
            except json.JSONDecodeError:
                item[key] = []
    return item


def init_db() -> None:
    with get_connection() as conn:
        conn.execute(
            """
            CREATE TABLE IF NOT EXISTS alerts (
                id TEXT PRIMARY KEY,
                title TEXT NOT NULL,
                category TEXT NOT NULL,
                severity TEXT NOT NULL,
                status TEXT NOT NULL,
                asset TEXT NOT NULL,
                user TEXT NOT NULL,
                source TEXT NOT NULL,
                timestamp TEXT NOT NULL,
                summary TEXT NOT NULL,
                details TEXT NOT NULL,
                incident_id TEXT,
                recommended_severity TEXT NOT NULL,
                expected_steps TEXT NOT NULL,
                report_checklist TEXT NOT NULL,
                evidence TEXT NOT NULL,
                timeline TEXT NOT NULL,
                selected_severity TEXT,
                selected_steps TEXT DEFAULT '[]',
                selected_report_items TEXT DEFAULT '[]',
                notes TEXT DEFAULT '[]',
                timeline_entries TEXT DEFAULT '[]',
                evidence_items TEXT DEFAULT '[]',
                score INTEGER DEFAULT 0,
                score_summary TEXT DEFAULT '',
                completed_at TEXT
            )
            """
        )
        conn.execute(
            """
            CREATE TABLE IF NOT EXISTS endpoints (
                hostname TEXT PRIMARY KEY,
                owner TEXT,
                os TEXT,
                criticality TEXT,
                status TEXT
            )
            """
        )
        conn.execute(
            """
            CREATE TABLE IF NOT EXISTS users (
                username TEXT PRIMARY KEY,
                name TEXT,
                department TEXT,
                risk TEXT
            )
            """
        )

        existing = conn.execute("SELECT COUNT(*) AS count FROM alerts").fetchone()["count"]
        if existing == 0:
            for alert in ALERTS:
                conn.execute(
                    """
                    INSERT INTO alerts (
                        id, title, category, severity, status, asset, user, source, timestamp,
                        summary, details, incident_id, recommended_severity, expected_steps,
                        report_checklist, evidence, timeline
                    ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
                    """,
                    (
                        alert["id"], alert["title"], alert["category"], alert["severity"], alert["status"],
                        alert["asset"], alert["user"], alert["source"], alert["timestamp"], alert["summary"],
                        alert["details"], alert.get("incident_id"), alert["recommended_severity"],
                        json.dumps(alert["expected_steps"]), json.dumps(alert["report_checklist"]),
                        json.dumps(alert["evidence"]), json.dumps(alert["timeline"]),
                    ),
                )

        if conn.execute("SELECT COUNT(*) AS count FROM endpoints").fetchone()["count"] == 0:
            for endpoint in ENDPOINTS:
                conn.execute(
                    "INSERT INTO endpoints (hostname, owner, os, criticality, status) VALUES (?, ?, ?, ?, ?)",
                    (endpoint["hostname"], endpoint["owner"], endpoint["os"], endpoint["criticality"], endpoint["status"]),
                )

        if conn.execute("SELECT COUNT(*) AS count FROM users").fetchone()["count"] == 0:
            for user in USERS:
                conn.execute(
                    "INSERT INTO users (username, name, department, risk) VALUES (?, ?, ?, ?)",
                    (user["username"], user["name"], user["department"], user["risk"]),
                )
