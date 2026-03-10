FROM python:3.13-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    UV_LINK_MODE=copy \
    PYTHONPATH=/app/src

ENV APP_ENV=production \
    APP_HOST=0.0.0.0 \
    APP_PORT=8888 \
    DATABASE_URL=postgresql+asyncpg://admin:234Wersdf!@noum.iptime.org:5555/scribble \
    JWT_SECRET=3WlFUhvhgJIG1ARuVdSRLWNXR5Xlu+1TnNdJmSxWVmMcW40kiQk1T7UBUovHNlUI \
    JWT_ALGORITHM=HS256 \
    ACCESS_TOKEN_TTL_MINUTES=15 \
    REFRESH_TOKEN_TTL_DAYS=30 \
    DEVICE_LIMIT_PER_USER=5 \
    SYNC_CURSOR_TTL_DAYS=30

WORKDIR /app

RUN apt-get update \
    && apt-get install -y --no-install-recommends build-essential curl \
    && rm -rf /var/lib/apt/lists/*

RUN pip install --no-cache-dir uv

COPY pyproject.toml uv.lock PROJECT.md ./
RUN uv sync --frozen --no-dev

COPY alembic.ini ./
COPY alembic ./alembic
COPY src ./src
COPY PROJECT.md ./PROJECT.md

EXPOSE 8888

CMD ["sh", "-c", ". .venv/bin/activate && alembic upgrade head && uvicorn main:app --app-dir src --host 0.0.0.0 --port 8888"]
