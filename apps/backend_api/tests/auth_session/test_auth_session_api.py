from __future__ import annotations

from datetime import UTC, datetime, timedelta

import jwt
import pytest
from httpx import AsyncClient

from core.config import get_settings


@pytest.mark.asyncio
async def test_register_creates_a_new_user(client: AsyncClient) -> None:
    response = await client.post(
        '/auth/register',
        json={'email': 'user@example.com', 'password': 'password123'},
    )

    assert response.status_code == 201
    body = response.json()
    assert body['email'] == 'user@example.com'
    assert body['id']


@pytest.mark.asyncio
async def test_login_returns_access_and_refresh_tokens(client: AsyncClient) -> None:
    await client.post('/auth/register', json={'email': 'user@example.com', 'password': 'password123'})

    response = await client.post(
        '/auth/login',
        json={'email': 'user@example.com', 'password': 'password123'},
    )

    assert response.status_code == 200
    body = response.json()
    assert body['token_type'] == 'bearer'
    assert body['access_token']
    assert body['refresh_token']


@pytest.mark.asyncio
async def test_refresh_rotates_the_current_session(client: AsyncClient) -> None:
    await client.post('/auth/register', json={'email': 'user@example.com', 'password': 'password123'})
    login_response = await client.post(
        '/auth/login',
        json={'email': 'user@example.com', 'password': 'password123'},
    )

    refresh_response = await client.post(
        '/auth/refresh',
        json={'refresh_token': login_response.json()['refresh_token']},
    )

    assert refresh_response.status_code == 200
    body = refresh_response.json()
    assert body['access_token']
    assert body['refresh_token']
    assert body['refresh_token'] != login_response.json()['refresh_token']


@pytest.mark.asyncio
async def test_me_returns_the_current_user(client: AsyncClient) -> None:
    await client.post('/auth/register', json={'email': 'user@example.com', 'password': 'password123'})
    login_response = await client.post(
        '/auth/login',
        json={'email': 'user@example.com', 'password': 'password123'},
    )

    response = await client.get(
        '/auth/me',
        headers={'Authorization': f"Bearer {login_response.json()['access_token']}"},
    )

    assert response.status_code == 200
    assert response.json()['user']['email'] == 'user@example.com'


@pytest.mark.asyncio
async def test_logout_revokes_the_current_session(client: AsyncClient) -> None:
    await client.post('/auth/register', json={'email': 'user@example.com', 'password': 'password123'})
    login_response = await client.post(
        '/auth/login',
        json={'email': 'user@example.com', 'password': 'password123'},
    )
    tokens = login_response.json()

    logout_response = await client.post(
        '/auth/logout',
        headers={'Authorization': f"Bearer {tokens['access_token']}"},
    )
    refresh_response = await client.post('/auth/refresh', json={'refresh_token': tokens['refresh_token']})

    assert logout_response.status_code == 204
    assert refresh_response.status_code == 401
    assert refresh_response.json()['error']['code'] == 'SESSION_REVOKED'


@pytest.mark.asyncio
async def test_register_rejects_duplicate_email(client: AsyncClient) -> None:
    await client.post('/auth/register', json={'email': 'user@example.com', 'password': 'password123'})

    response = await client.post(
        '/auth/register',
        json={'email': 'user@example.com', 'password': 'password123'},
    )

    assert response.status_code == 409
    assert response.json()['error']['code'] == 'EMAIL_ALREADY_EXISTS'


@pytest.mark.asyncio
async def test_login_rejects_wrong_password(client: AsyncClient) -> None:
    await client.post('/auth/register', json={'email': 'user@example.com', 'password': 'password123'})

    response = await client.post(
        '/auth/login',
        json={'email': 'user@example.com', 'password': 'wrong-pass-123'},
    )

    assert response.status_code == 401
    assert response.json()['error']['code'] == 'INVALID_CREDENTIALS'


@pytest.mark.asyncio
async def test_refresh_rejects_expired_token(client: AsyncClient) -> None:
    settings = get_settings()
    await client.post('/auth/register', json={'email': 'user@example.com', 'password': 'password123'})
    login_response = await client.post(
        '/auth/login',
        json={'email': 'user@example.com', 'password': 'password123'},
    )
    refresh_token = login_response.json()['refresh_token']
    payload = jwt.decode(
        refresh_token,
        settings.jwt_secret,
        algorithms=[settings.jwt_algorithm],
        options={'verify_exp': False},
    )
    expired_token = jwt.encode(
        {
            **payload,
            'iat': int((datetime.now(tz=UTC) - timedelta(days=2)).timestamp()),
            'exp': int((datetime.now(tz=UTC) - timedelta(days=1)).timestamp()),
        },
        settings.jwt_secret,
        algorithm=settings.jwt_algorithm,
    )

    response = await client.post('/auth/refresh', json={'refresh_token': expired_token})

    assert response.status_code == 401
    assert response.json()['error']['code'] == 'TOKEN_EXPIRED'


@pytest.mark.asyncio
async def test_refresh_rejects_revoked_session(client: AsyncClient) -> None:
    await client.post('/auth/register', json={'email': 'user@example.com', 'password': 'password123'})
    login_response = await client.post(
        '/auth/login',
        json={'email': 'user@example.com', 'password': 'password123'},
    )
    tokens = login_response.json()

    await client.post('/auth/logout', headers={'Authorization': f"Bearer {tokens['access_token']}"})
    response = await client.post('/auth/refresh', json={'refresh_token': tokens['refresh_token']})

    assert response.status_code == 401
    assert response.json()['error']['code'] == 'SESSION_REVOKED'


@pytest.mark.asyncio
async def test_me_requires_access_token(client: AsyncClient) -> None:
    response = await client.get('/auth/me')

    assert response.status_code == 401
    assert response.json()['error']['code'] == 'UNAUTHORIZED'
