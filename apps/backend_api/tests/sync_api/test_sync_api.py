from __future__ import annotations

from datetime import UTC, datetime, timedelta
from uuid import uuid4

import jwt
import pytest
from httpx import AsyncClient

from core.config import get_settings
from core.pagination import CursorState, encode_cursor
from device_registry.repository import DeviceRegistryRepository
from device_registry.service import DeviceRegistryService
from sync_api.repository import SyncApiRepository


async def register_and_login(client: AsyncClient, email: str) -> dict[str, str]:
    await client.post('/auth/register', json={'email': email, 'password': 'password123'})
    response = await client.post('/auth/login', json={'email': email, 'password': 'password123'})
    return response.json()


async def register_device(client: AsyncClient, access_token: str, device_id: str) -> None:
    response = await client.post(
        '/devices',
        json={'device_id': device_id, 'platform': 'ios', 'name': device_id},
        headers={'Authorization': f'Bearer {access_token}', 'User-Agent': 'pytest-agent'},
    )
    assert response.status_code == 201


def sync_headers(access_token: str, device_id: str) -> dict[str, str]:
    return {
        'Authorization': f'Bearer {access_token}',
        'X-Device-Id': device_id,
        'User-Agent': 'pytest-sync-client',
    }


def make_event(
    *,
    event_id: str | None = None,
    entity_type: str = 'memo',
    entity_id: str | None = None,
    operation: str = 'upsert',
    payload: dict | None = None,
    updated_at: datetime | None = None,
    deleted_at: datetime | None = None,
) -> dict:
    return {
        'event_id': event_id or str(uuid4()),
        'entity_type': entity_type,
        'entity_id': entity_id or str(uuid4()),
        'operation': operation,
        'payload': payload or {'title': 'Write docs'},
        'updated_at': (updated_at or datetime.now(tz=UTC)).isoformat(),
        'deleted_at': deleted_at.isoformat() if deleted_at else None,
    }


@pytest.mark.asyncio
async def test_valid_user_and_device_can_push(client: AsyncClient) -> None:
    auth = await register_and_login(client, 'user@example.com')
    await register_device(client, auth['access_token'], 'device-a')

    response = await client.post(
        '/sync/push',
        json={'events': [make_event()]},
        headers=sync_headers(auth['access_token'], 'device-a'),
    )

    assert response.status_code == 200
    body = response.json()
    assert body['accepted'] == 1
    assert body['rejected'] == 0
    assert body['server_cursor']


@pytest.mark.asyncio
async def test_pull_returns_events_after_cursor(client: AsyncClient) -> None:
    auth = await register_and_login(client, 'user@example.com')
    await register_device(client, auth['access_token'], 'device-a')
    await register_device(client, auth['access_token'], 'device-b')

    push = await client.post(
        '/sync/push',
        json={'events': [make_event(payload={'title': 'First'})]},
        headers=sync_headers(auth['access_token'], 'device-a'),
    )
    first_cursor = push.json()['server_cursor']

    await client.post(
        '/sync/push',
        json={'events': [make_event(payload={'title': 'Second'})]},
        headers=sync_headers(auth['access_token'], 'device-a'),
    )
    response = await client.get(
        '/sync/pull',
        params={'cursor': first_cursor},
        headers=sync_headers(auth['access_token'], 'device-b'),
    )

    assert response.status_code == 200
    body = response.json()
    assert len(body['events']) == 1
    assert body['events'][0]['payload']['title'] == 'Second'
    assert body['next_cursor']
    assert body['has_more'] is False


@pytest.mark.asyncio
async def test_duplicate_event_id_is_idempotently_accepted(client: AsyncClient, session_factory) -> None:
    auth = await register_and_login(client, 'user@example.com')
    await register_device(client, auth['access_token'], 'device-a')
    event = make_event(event_id=str(uuid4()))

    first = await client.post(
        '/sync/push',
        json={'events': [event]},
        headers=sync_headers(auth['access_token'], 'device-a'),
    )
    second = await client.post(
        '/sync/push',
        json={'events': [event]},
        headers=sync_headers(auth['access_token'], 'device-a'),
    )

    async with session_factory() as session:
        repo = SyncApiRepository(session)
        persisted = await repo.get_event_by_event_id(event['event_id'])

    assert first.status_code == 200
    assert second.status_code == 200
    assert first.json()['accepted'] == 1
    assert second.json()['accepted'] == 1
    assert persisted is not None


@pytest.mark.asyncio
async def test_changes_propagate_to_another_device(client: AsyncClient) -> None:
    auth = await register_and_login(client, 'user@example.com')
    await register_device(client, auth['access_token'], 'device-a')
    await register_device(client, auth['access_token'], 'device-b')

    await client.post(
        '/sync/push',
        json={'events': [make_event(payload={'title': 'Cross-device'})]},
        headers=sync_headers(auth['access_token'], 'device-a'),
    )
    response = await client.get('/sync/pull', headers=sync_headers(auth['access_token'], 'device-b'))

    assert response.status_code == 200
    assert len(response.json()['events']) == 1
    assert response.json()['events'][0]['payload']['title'] == 'Cross-device'


@pytest.mark.asyncio
async def test_tombstone_event_is_delivered(client: AsyncClient) -> None:
    auth = await register_and_login(client, 'user@example.com')
    await register_device(client, auth['access_token'], 'device-a')
    await register_device(client, auth['access_token'], 'device-b')
    deleted_at = datetime.now(tz=UTC)

    await client.post(
        '/sync/push',
        json={
            'events': [
                make_event(
                    operation='delete',
                    payload={'reason': 'removed'},
                    deleted_at=deleted_at,
                )
            ]
        },
        headers=sync_headers(auth['access_token'], 'device-a'),
    )
    response = await client.get('/sync/pull', headers=sync_headers(auth['access_token'], 'device-b'))

    assert response.status_code == 200
    event = response.json()['events'][0]
    assert event['operation'] == 'delete'
    assert event['deleted_at'] is not None


@pytest.mark.asyncio
async def test_last_sync_at_is_updated_after_sync(client: AsyncClient, session_factory) -> None:
    auth = await register_and_login(client, 'user@example.com')
    await register_device(client, auth['access_token'], 'device-a')

    await client.post(
        '/sync/push',
        json={'events': [make_event()]},
        headers=sync_headers(auth['access_token'], 'device-a'),
    )

    user_id = extract_user_id(auth['access_token'])
    async with session_factory() as session:
        service = DeviceRegistryService(DeviceRegistryRepository(session))
        device = await service.validate_active_device(user_id, 'device-a')

    assert device.last_sync_at is not None


@pytest.mark.asyncio
async def test_sync_requires_authentication(client: AsyncClient) -> None:
    response = await client.post('/sync/push', json={'events': [make_event()]})

    assert response.status_code == 401
    assert response.json()['error']['code'] == 'UNAUTHORIZED'


@pytest.mark.asyncio
async def test_inactive_device_cannot_sync(client: AsyncClient) -> None:
    auth = await register_and_login(client, 'user@example.com')
    await register_device(client, auth['access_token'], 'device-a')
    await client.delete('/devices/device-a', headers={'Authorization': f"Bearer {auth['access_token']}"})

    push = await client.post(
        '/sync/push',
        json={'events': [make_event()]},
        headers=sync_headers(auth['access_token'], 'device-a'),
    )
    pull = await client.get('/sync/pull', headers=sync_headers(auth['access_token'], 'device-a'))

    assert push.status_code == 403
    assert pull.status_code == 403
    assert push.json()['error']['code'] == 'DEVICE_INACTIVE'
    assert pull.json()['error']['code'] == 'DEVICE_INACTIVE'


@pytest.mark.asyncio
async def test_tampered_cursor_is_rejected(client: AsyncClient) -> None:
    auth = await register_and_login(client, 'user@example.com')
    await register_device(client, auth['access_token'], 'device-a')

    response = await client.get(
        '/sync/pull',
        params={'cursor': 'not-a-valid-cursor'},
        headers=sync_headers(auth['access_token'], 'device-a'),
    )

    assert response.status_code == 410
    assert response.json()['error']['code'] == 'CURSOR_EXPIRED'


@pytest.mark.asyncio
async def test_expired_cursor_is_rejected(client: AsyncClient) -> None:
    auth = await register_and_login(client, 'user@example.com')
    await register_device(client, auth['access_token'], 'device-a')
    expired_cursor = encode_cursor(
        CursorState(
            recorded_at=datetime.now(tz=UTC) - timedelta(days=get_settings().sync_cursor_ttl_days + 1),
            event_id=str(uuid4()),
        )
    )

    response = await client.get(
        '/sync/pull',
        params={'cursor': expired_cursor},
        headers=sync_headers(auth['access_token'], 'device-a'),
    )

    assert response.status_code == 410
    assert response.json()['error']['code'] == 'CURSOR_EXPIRED'


@pytest.mark.asyncio
async def test_missing_event_fields_are_rejected(client: AsyncClient) -> None:
    auth = await register_and_login(client, 'user@example.com')
    await register_device(client, auth['access_token'], 'device-a')

    response = await client.post(
        '/sync/push',
        json={'events': [{'entity_type': 'memo'}]},
        headers=sync_headers(auth['access_token'], 'device-a'),
    )

    assert response.status_code == 422


@pytest.mark.asyncio
async def test_stale_event_is_stored_but_not_returned_as_latest(client: AsyncClient, session_factory) -> None:
    auth = await register_and_login(client, 'user@example.com')
    await register_device(client, auth['access_token'], 'device-a')
    await register_device(client, auth['access_token'], 'device-b')
    entity_id = str(uuid4())

    latest_event = make_event(
        entity_id=entity_id,
        payload={'title': 'newer'},
        updated_at=datetime.now(tz=UTC),
    )
    await client.post(
        '/sync/push',
        json={'events': [latest_event]},
        headers=sync_headers(auth['access_token'], 'device-a'),
    )
    latest_pull = await client.get('/sync/pull', headers=sync_headers(auth['access_token'], 'device-b'))
    latest_cursor = latest_pull.json()['next_cursor']

    stale_event = make_event(
        entity_id=entity_id,
        payload={'title': 'older'},
        updated_at=datetime.now(tz=UTC) - timedelta(days=1),
    )
    await client.post(
        '/sync/push',
        json={'events': [stale_event]},
        headers=sync_headers(auth['access_token'], 'device-a'),
    )
    stale_pull = await client.get(
        '/sync/pull',
        params={'cursor': latest_cursor},
        headers=sync_headers(auth['access_token'], 'device-b'),
    )

    async with session_factory() as session:
        repo = SyncApiRepository(session)
        latest = await repo.get_latest_entity_event(extract_user_id(auth['access_token']), 'memo', entity_id)
        stale = await repo.get_event_by_event_id(stale_event['event_id'])

    assert stale is not None
    assert latest is not None
    assert latest.payload['title'] == 'newer'
    assert stale_pull.status_code == 200
    assert stale_pull.json()['events'] == []


def extract_user_id(access_token: str) -> str:
    settings = get_settings()
    payload = jwt.decode(access_token, settings.jwt_secret, algorithms=[settings.jwt_algorithm])
    return str(payload['sub'])
