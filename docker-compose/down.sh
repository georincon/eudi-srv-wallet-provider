#!/usr/bin/env bash
# Detiene este stack (-v borra también los volúmenes).
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")"
docker compose down "$@"
