from __future__ import annotations

import os
import sys
from collections.abc import AsyncIterator
from pathlib import Path

import asyncpg
import pytest_asyncio
from httpx import ASGITransport, AsyncClient
from sqlalchemy import text
from sqlalchemy.ext.asyncio import AsyncSession, async_sessionmaker, create_async_engine

ROOT = Path(__file__).resolve().parents[1]
SRC = ROOT / 'src'
if str(SRC) not in sys.path:
    sys.path.insert(0, str(SRC))

TEST_DATABASE_URL = 'postgresql+asyncpg://konn@localhost:5432/scribble_test'
TEST_ADMIN_DSN = 'postgresql://konn@localhost:5432/postgres'

os.environ.setdefault('APP_ENV', 'test')
os.environ.setdefault('DATABASE_URL', TEST_DATABASE_URL)
os.environ.setdefault('JWT_SECRET', 'test-secret-key-with-32-bytes-minimum')
os.environ.setdefault('ACCESS_TOKEN_TTL_MINUTES', '15')
os.environ.setdefault('REFRESH_TOKEN_TTL_DAYS', '30')

from core.config import get_settings
from core.database import Base, get_db_session
from main import create_app


@pytest_asyncio.fixture(scope='session', autouse=True)
async def prepare_test_database() -> AsyncIterator[None]:
    admin_conn = await asyncpg.connect(TEST_ADMIN_DSN)
    try:
        exists = await admin_conn.fetchval("SELECT 1 FROM pg_database WHERE datname = 'scribble_test'")
        if not exists:
            await admin_conn.execute('CREATE DATABASE scribble_test')
    finally:
        await admin_conn.close()

    get_settings.cache_clear()
    engine = create_async_engine(TEST_DATABASE_URL, future=True)
    async with engine.begin() as conn:
        await conn.execute(text('CREATE EXTENSION IF NOT EXISTS citext'))
        await conn.run_sync(Base.metadata.drop_all)
        await conn.run_sync(Base.metadata.create_all)
    await engine.dispose()
    yield


@pytest_asyncio.fixture()
async def db_engine() -> AsyncIterator:
    get_settings.cache_clear()
    engine = create_async_engine(TEST_DATABASE_URL, future=True)
    async with engine.begin() as conn:
        await conn.execute(
            text('TRUNCATE TABLE sync_events, devices, auth_sessions, users RESTART IDENTITY CASCADE')
        )
    try:
        yield engine
    finally:
        await engine.dispose()


@pytest_asyncio.fixture()
def session_factory(db_engine):
    return async_sessionmaker(bind=db_engine, class_=AsyncSession, expire_on_commit=False)


@pytest_asyncio.fixture()
async def client(db_engine, session_factory) -> AsyncIterator[AsyncClient]:
    async def override_get_db_session() -> AsyncIterator[AsyncSession]:
        async with session_factory() as session:
            yield session

    app = create_app()
    app.dependency_overrides[get_db_session] = override_get_db_session

    async with AsyncClient(transport=ASGITransport(app=app), base_url='http://testserver') as test_client:
        yield test_client

    app.dependency_overrides.clear()
