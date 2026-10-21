# OpenSeek-SM Docker v0.0.1

OpenSeek-SM self-hosted installation files. The application image is built in a private source repository. This repository contains deployment configuration and documentation.

## Install

Install Docker Engine with Docker Compose v2, or Docker Desktop, and start Docker.

```bash
git clone https://github.com/LIBERSEEK/OpenSeek-SM-CE.git
cd OpenSeek-SM-CE
bash install.sh
```

The installer generates a random JWT secret and waits for the services to become healthy. Open http://localhost:4007 and register the first account. The deployment runs the application, PostgreSQL, Redis, and Temporal with its own PostgreSQL database.

For a remote server, run `cp .env.docker.example .env`, set a random `JWT_SECRET`, and update `MAIN_URL`, `FRONTEND_URL`, and `NEXT_PUBLIC_BACKEND_URL` to the externally reachable address before running the installer. For HTTPS, configure your reverse proxy and set `NOT_SECURED=false`. Restrict public registration with `DISABLE_REGISTRATION=true` after creating the intended accounts.

## Image

```text
ghcr.io/liberseek/openseek-sm-ce:v0.0.1
```

The release targets Linux amd64 and arm64. The Compose file pins the version; use an explicit version for upgrades.

```bash
docker compose ps
docker compose logs --tail=100 postiz
docker compose stop
docker compose start
```

## Upgrade And Back Up

Back up `.env`, the application PostgreSQL database, Temporal PostgreSQL database, and all named volumes before upgrading. Keep `JWT_SECRET` stable. Database schema updates run when the application starts; rolling back an image alone does not roll back the database.

```bash
docker compose exec -T postiz-postgres pg_dump -U postiz-user postiz-db-local > openseek-db.sql
docker compose exec -T temporal-postgresql pg_dumpall -U temporal > temporal-db.sql
docker compose pull
docker compose up -d --wait --wait-timeout 420
```

Never use `docker compose down -v` when you want to retain data: it removes named volumes.

## Optional Capabilities

Provider credentials and AI API keys must be supplied by the operator in `.env`. RSSHub is an external optional service configured through `RSSHUB_BASE_URL` and `RSSHUB_INTERNAL_TOKEN`. Interactive platform login windows require a browser display; this Docker deployment does not provide a remote desktop for QR login. Those login flows need a separately configured environment with a display.

The application is distributed as an executable container under the applicable commercial authorization. Compiled JavaScript, Python runtime modules, and required runtime assets remain inspectable by recipients of the image; a container is not source encryption.
