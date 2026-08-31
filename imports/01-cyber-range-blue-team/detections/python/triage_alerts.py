#!/usr/bin/env python3
"""Summarize JSON alerts for triage practice."""
import argparse
import json
from pathlib import Path

SEVERITY_ORDER = {"critical": 4, "high": 3, "medium": 2, "low": 1}


def load_alerts(path: Path):
    text = path.read_text(encoding="utf-8", errors="ignore").strip()
    if not text:
        return []
    if text.startswith("["):
        return json.loads(text)
    return [json.loads(line) for line in text.splitlines() if line.strip()]


def main():
    parser = argparse.ArgumentParser(description="Summarize JSON alerts by severity.")
    parser.add_argument("--alerts", default="sample-logs/alerts.json", help="Path to JSON or JSONL alerts")
    args = parser.parse_args()
    alerts = load_alerts(Path(args.alerts))
    alerts.sort(key=lambda alert: SEVERITY_ORDER.get(alert.get("severity", "low"), 1), reverse=True)
    for alert in alerts:
        print(f"[{alert.get('severity', 'unknown').upper()}] {alert.get('rule_id')} - {alert.get('title')}")
        print(f"  Confidence: {alert.get('confidence', 'unknown')}")
        print(f"  Source: {alert.get('source_log', 'unknown')}")
        print(f"  Recommendation: {alert.get('recommendation', 'Review evidence and document decision.')}")
        print()


if __name__ == "__main__":
    main()
