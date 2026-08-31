#!/usr/bin/env bash
set -euo pipefail

echo "Starting 01 Cyber Range Blue Team lab..."
docker compose -f docker/docker-compose.yml up --build
