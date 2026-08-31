#!/usr/bin/env python3
"""Detect suspicious process events in sample process logs."""
import argparse
import json
from pathlib import Path

TOKENS = ["process=sh", "process=bash", "whoami", "cmd=\"id\"", "curl ", "wget "]


def detect(log_path: Path):
    alerts = []
    for line in log_path.read_text(encoding="utf-8", errors="ignore").splitlines():
        matched = [token for token in TOKENS if token in line]
        if matched:
            alerts.append({
                "rule_id": "BT-PROC-001",
                "title": "Suspicious Shell-Like Process Event",
                "severity": "high",
                "confidence": "medium",
                "source_log": str(log_path),
                "evidence": {"matched_tokens": matched, "line": line},
                "recommendation": "Review parent process and correlate with web events."
            })
    return alerts


def main():
    parser = argparse.ArgumentParser(description="Detect suspicious process events.")
    parser.add_argument("--log", default="sample-logs/process.log", help="Path to process log")
    args = parser.parse_args()
    print(json.dumps(detect(Path(args.log)), indent=2))


if __name__ == "__main__":
    main()
