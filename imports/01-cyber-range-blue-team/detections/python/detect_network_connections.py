#!/usr/bin/env python3
"""Detect unusual network destination ports in sample network logs."""
import argparse
import json
from pathlib import Path

UNUSUAL_PORTS = ["dport=4444", "dport=1337", "dport=6667"]


def detect(log_path: Path):
    alerts = []
    for line in log_path.read_text(encoding="utf-8", errors="ignore").splitlines():
        matched = [port for port in UNUSUAL_PORTS if port in line]
        if matched:
            alerts.append({
                "rule_id": "BT-NET-001",
                "title": "Unusual Network Destination Port",
                "severity": "medium",
                "confidence": "low",
                "source_log": str(log_path),
                "evidence": {"matched_ports": matched, "line": line},
                "recommendation": "Review process owner, destination, and related process telemetry."
            })
    return alerts


def main():
    parser = argparse.ArgumentParser(description="Detect unusual network connections.")
    parser.add_argument("--log", default="sample-logs/network.log", help="Path to network log")
    args = parser.parse_args()
    print(json.dumps(detect(Path(args.log)), indent=2))


if __name__ == "__main__":
    main()
