#!/usr/bin/env python3
"""Detect suspicious web request patterns in sample web logs."""
import argparse
import json
from pathlib import Path

SUSPICIOUS_TOKENS = ["%27", "../", "passwd", "/admin/debug", "union", "select"]


def detect(log_path: Path):
    alerts = []
    for line in log_path.read_text(encoding="utf-8", errors="ignore").splitlines():
        lower = line.lower()
        matched = [token for token in SUSPICIOUS_TOKENS if token in lower]
        if matched:
            alerts.append({
                "rule_id": "BT-WEB-001",
                "title": "Suspicious Web Request Pattern",
                "severity": "medium",
                "confidence": "medium",
                "source_log": str(log_path),
                "evidence": {"matched_tokens": matched, "line": line},
                "recommendation": "Correlate source IP with auth, process, and network logs."
            })
    return alerts


def main():
    parser = argparse.ArgumentParser(description="Detect suspicious web access log patterns.")
    parser.add_argument("--log", default="sample-logs/web-access.log", help="Path to web access log")
    args = parser.parse_args()
    print(json.dumps(detect(Path(args.log)), indent=2))


if __name__ == "__main__":
    main()
