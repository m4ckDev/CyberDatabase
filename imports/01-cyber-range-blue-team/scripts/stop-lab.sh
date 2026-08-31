#!/usr/bin/env bash
set -euo pipefail

echo "Stopping 01 Cyber Range Blue Team lab..."
docker compose -f docker/docker-compose.yml down
