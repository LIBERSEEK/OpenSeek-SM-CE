#!/usr/bin/env bash

set -euo pipefail

root_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$root_dir"

if ! command -v docker >/dev/null 2>&1; then
  echo "Docker is required. Install Docker Desktop or Docker Engine first." >&2
  exit 1
fi
if ! docker compose version >/dev/null 2>&1; then
  echo "Docker Compose v2 is required (docker compose)." >&2
  exit 1
fi
if ! docker info >/dev/null 2>&1; then
  echo "Docker is not running. Start Docker Desktop or Docker Engine first." >&2
  exit 1
fi

if [ ! -f .env ]; then
  cp .env.docker.example .env
  if command -v openssl >/dev/null 2>&1; then
    jwt_secret="$(openssl rand -hex 32)"
  else
    jwt_secret="$(od -An -N32 -tx1 /dev/urandom | tr -d ' \n')"
  fi
  sed "s|JWT_SECRET=change-me-to-a-long-random-value|JWT_SECRET=${jwt_secret}|" .env > .env.tmp
  mv .env.tmp .env
  chmod 600 .env
  echo "Created .env with a generated JWT_SECRET."
fi

legacy_service="$(docker inspect --type container --format '{{ index .Config.Labels \"com.docker.compose.service\" }}' openseek 2>/dev/null || true)"
if [ "$legacy_service" = postiz ]; then
  echo "Stopping the previous service names while preserving database volumes..."
  docker compose down --remove-orphans
fi

echo "Pulling OpenSeek-SM services..."
docker compose pull
echo "Starting OpenSeek-SM..."
docker compose up -d --wait --wait-timeout 420

echo
echo "OpenSeek-SM is ready. Open MAIN_URL configured in .env (default http://localhost:4007)."
echo "Use 'docker compose logs -f openseek' to follow startup."
