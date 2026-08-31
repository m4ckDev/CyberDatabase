#!/usr/bin/env bash
set -euo pipefail

echo "Running local detection scripts..."
python3 scripts/run_all_detections.py
echo "Detection results saved to reports/local-detection-results.json"
