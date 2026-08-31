from collections import defaultdict, deque
from datetime import datetime, timezone
from pathlib import Path
import json
import os
import re
import time

LOG_DIR = Path(os.environ.get("LOG_DIR", "/data/logs"))
ALERT_PATH = Path(os.environ.get("ALERT_PATH", "/data/reports/generated-alerts.jsonl"))
ALERT_PATH.parent.mkdir(parents=True, exist_ok=True)

failed_by_ip = defaultdict(lambda: deque(maxlen=20))
seen_lines = set()


def now():
    return datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ")


def emit(alert):
    alert.setdefault("timestamp", now())
    alert.setdefault("local_lab_only", True)
    line = json.dumps(alert, sort_keys=True)
    print(line, flush=True)
    with ALERT_PATH.open("a", encoding="utf-8") as f:
        f.write(line + "\n")


def parse_field(line, field):
    match = re.search(rf"{field}=([^\s]+)", line)
    return match.group(1).strip('"') if match else "unknown"


def inspect_line(log_name, line):
    key = f"{log_name}:{line}"
    if key in seen_lines:
        return
    seen_lines.add(key)

    if log_name == "auth.log" and "event=Failed" in line:
        src = parse_field(line, "src")
        user = parse_field(line, "user")
        failed_by_ip[src].append(line)
        if len(failed_by_ip[src]) >= 5:
            emit({
                "rule_id": "BT-AUTH-001",
                "title": "Repeated Failed SSH Login Events",
                "severity": "medium",
                "confidence": "medium",
                "source_log": log_name,
                "evidence": {"src": src, "user": user, "count_recent": len(failed_by_ip[src])},
                "recommendation": "Review authentication timeline and confirm whether the source is expected in the local lab."
            })

    if log_name == "web-access.log" and any(token in line.lower() for token in ["%27", "../", "/admin/debug", "passwd"]):
        emit({
            "rule_id": "BT-WEB-001",
            "title": "Suspicious Web Request Pattern",
            "severity": "medium",
            "confidence": "medium",
            "source_log": log_name,
            "evidence": {"line": line},
            "recommendation": "Review related web requests from the same source and add to the timeline if repeated."
        })

    if log_name == "process.log" and any(token in line for token in [" sh -c ", "process=sh", "whoami"]):
        emit({
            "rule_id": "BT-PROC-001",
            "title": "Suspicious Shell-Like Process Event",
            "severity": "high",
            "confidence": "medium",
            "source_log": log_name,
            "evidence": {"line": line},
            "recommendation": "Correlate with web and auth logs to determine whether this process has a normal explanation."
        })

    if log_name == "fim.log" and any(path in line for path in ["/etc/ssh/sshd_config", "/etc/passwd", "/etc/shadow"]):
        emit({
            "rule_id": "BT-FIM-001",
            "title": "Sensitive File Change Event",
            "severity": "high",
            "confidence": "medium",
            "source_log": log_name,
            "evidence": {"line": line},
            "recommendation": "Validate whether the change was authorized and document the time of change."
        })

    if log_name == "network.log" and any(port in line for port in ["dport=4444", "dport=1337", "dport=6667"]):
        emit({
            "rule_id": "BT-NET-001",
            "title": "Unusual Network Destination Port",
            "severity": "medium",
            "confidence": "low",
            "source_log": log_name,
            "evidence": {"line": line},
            "recommendation": "Review process, destination, and timing before escalating."
        })


def read_logs_once():
    for path in LOG_DIR.glob("*.log"):
        try:
            lines = path.read_text(encoding="utf-8", errors="ignore").splitlines()[-200:]
        except FileNotFoundError:
            continue
        for line in lines:
            inspect_line(path.name, line)


if __name__ == "__main__":
    while True:
        read_logs_once()
        time.sleep(5)
