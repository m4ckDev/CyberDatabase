#!/usr/bin/env python3
"""Detect repeated failed SSH logins in sample auth logs."""
import argparse
import json
import re
from collections import defaultdict
from pathlib import Path


def parse_field(line: str, field: str) -> str:
    match = re.search(rf"{field}=([^\s]+)", line)
    return match.group(1).strip('"') if match else "unknown"


def detect(log_path: Path, threshold: int = 5):
    counts = defaultdict(list)
    for line in log_path.read_text(encoding="utf-8", errors="ignore").splitlines():
        if "event=Failed" and "sshd" in line and "event=Failed" in line:
            src = parse_field(line, "src")
            counts[src].append(line)

    alerts = []
    for src, lines in counts.items():
        if len(lines) >= threshold:
            users = sorted({parse_field(line, "user") for line in lines})
            alerts.append({
                "rule_id": "BT-AUTH-001",
                "title": "Repeated Failed SSH Login Events",
                "severity": "medium",
                "confidence": "high",
                "source_log": str(log_path),
                "evidence": {"src": src, "failed_count": len(lines), "users": users, "sample": lines[:3]},
                "recommendation": "Review source, targeted accounts, and timeline."
            })
    return alerts


def main():
    parser = argparse.ArgumentParser(description="Detect repeated failed SSH login events.")
    parser.add_argument("--log", default="sample-logs/auth.log", help="Path to auth log")
    parser.add_argument("--threshold", type=int, default=5, help="Failed login threshold")
    args = parser.parse_args()
    alerts = detect(Path(args.log), args.threshold)
    print(json.dumps(alerts, indent=2))


if __name__ == "__main__":
    main()
