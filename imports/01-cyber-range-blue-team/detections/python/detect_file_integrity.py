#!/usr/bin/env python3
"""Detect sensitive file changes in sample FIM logs."""
import argparse
import json
from pathlib import Path

SENSITIVE_PATHS = ["/etc/ssh/sshd_config", "/etc/passwd", "/etc/shadow", "/root/.ssh/authorized_keys"]


def detect(log_path: Path):
    alerts = []
    for line in log_path.read_text(encoding="utf-8", errors="ignore").splitlines():
        matched = [path for path in SENSITIVE_PATHS if path in line]
        if matched:
            alerts.append({
                "rule_id": "BT-FIM-001",
                "title": "Sensitive File Change Event",
                "severity": "high",
                "confidence": "medium",
                "source_log": str(log_path),
                "evidence": {"matched_paths": matched, "line": line},
                "recommendation": "Validate authorization and add the event to the investigation timeline."
            })
    return alerts


def main():
    parser = argparse.ArgumentParser(description="Detect sensitive file change events.")
    parser.add_argument("--log", default="sample-logs/fim.log", help="Path to FIM log")
    args = parser.parse_args()
    print(json.dumps(detect(Path(args.log)), indent=2))


if __name__ == "__main__":
    main()
