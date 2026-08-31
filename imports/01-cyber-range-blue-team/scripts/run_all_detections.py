#!/usr/bin/env python3
"""Run all local Python detections against included sample logs."""
import importlib.util
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
DETECTION_DIR = ROOT / "detections" / "python"
OUTPUT = ROOT / "reports" / "local-detection-results.json"

JOBS = [
    ("detect_failed_logins.py", ROOT / "sample-logs" / "auth.log"),
    ("detect_web_attacks.py", ROOT / "sample-logs" / "web-access.log"),
    ("detect_suspicious_processes.py", ROOT / "sample-logs" / "process.log"),
    ("detect_file_integrity.py", ROOT / "sample-logs" / "fim.log"),
    ("detect_network_connections.py", ROOT / "sample-logs" / "network.log"),
]


def load_module(path: Path):
    spec = importlib.util.spec_from_file_location(path.stem, path)
    module = importlib.util.module_from_spec(spec)
    assert spec.loader is not None
    spec.loader.exec_module(module)
    return module


def main():
    all_alerts = []
    for script_name, log_path in JOBS:
        module = load_module(DETECTION_DIR / script_name)
        alerts = module.detect(log_path)
        all_alerts.extend(alerts)
        print(f"{script_name}: {len(alerts)} alert(s)")

    OUTPUT.parent.mkdir(parents=True, exist_ok=True)
    OUTPUT.write_text(json.dumps(all_alerts, indent=2), encoding="utf-8")
    print(f"\nWrote results to {OUTPUT}")


if __name__ == "__main__":
    main()
