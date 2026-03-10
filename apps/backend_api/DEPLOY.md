# Deploy

## Overview

`backend_api` is packaged as a standalone Docker service.

- FastAPI listens on `8888`
- PostgreSQL runs as a separate container
- Alembic migrations run automatically when the backend container starts
- NAS deployment can use either `compose.yaml` or two independent containers on the same Docker network

## Files

- `Dockerfile`
- `compose.yaml`
- `.env.example`

## Default credentials

- DB user: `admin`
- DB password: `234Wersdf!`
- DB name: `scribble`

These are bootstrap defaults only. Change them before exposing the service outside a trusted network.

## Option A: Compose

```bash
docker compose up --build -d
```

## Option B: Separate Containers

### 1. Create network

```bash
docker network create scribble-net
```

### 2. Run PostgreSQL

```bash
docker run -d \
  --name scribble-db \
  --network scribble-net \
  -e POSTGRES_DB=scribble \
  -e POSTGRES_USER=admin \
  -e POSTGRES_PASSWORD='234Wersdf!' \
  -v scribble_postgres_data:/var/lib/postgresql/data \
  -p 5432:5432 \
  postgres:16
```

### 3. Build backend image

```bash
docker build -t scribble-backend-api .
```

### 4. Run backend

```bash
docker run -d \
  --name scribble-backend-api \
  --network scribble-net \
  -e APP_ENV=production \
  -e APP_HOST=0.0.0.0 \
  -e APP_PORT=8888 \
  -e DATABASE_URL='postgresql+asyncpg://admin:234Wersdf!@scribble-db:5432/scribble' \
  -e JWT_SECRET='change-this-in-production' \
  -e JWT_ALGORITHM=HS256 \
  -e ACCESS_TOKEN_TTL_MINUTES=15 \
  -e REFRESH_TOKEN_TTL_DAYS=30 \
  -e DEVICE_LIMIT_PER_USER=5 \
  -e SYNC_CURSOR_TTL_DAYS=30 \
  -p 8888:8888 \
  scribble-backend-api
```

## Export images as tar

If you want to upload the images to a NAS manually, build/pull them first and then export them.

### Backend image

```bash
docker build -t scribble-backend-api .
docker save -o scribble-backend-api.tar scribble-backend-api
```

### PostgreSQL image

```bash
docker pull postgres:16
docker save -o postgres-16.tar postgres:16
```

## Import images on NAS

```bash
docker load -i scribble-backend-api.tar
docker load -i postgres-16.tar
```

## Endpoints

- App: `http://<host>:8888`
- Swagger: `http://<host>:8888/docs`
- ReDoc: `http://<host>:8888/redoc`
- Health: `http://<host>:8888/healthz`

## Notes for NAS

- Keep PostgreSQL volume persistent.
- Replace `JWT_SECRET` before real deployment.
- If the NAS uses a reverse proxy, forward external HTTPS traffic to container port `8888`.
- If the NAS already runs PostgreSQL elsewhere, remove the DB container and point `DATABASE_URL` at that host instead.
- On NAS UIs that create containers one by one, reuse the same Docker network and set the backend DB host to `scribble-db`.

## Migration behavior

Container startup runs:

```sh
alembic upgrade head
uvicorn main:app --app-dir src --host 0.0.0.0 --port 8888
```

This is acceptable for a single-instance NAS deployment. If you later run multiple backend replicas, move migration execution to a separate release step.
