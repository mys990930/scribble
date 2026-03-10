from __future__ import annotations

import os
from datetime import UTC, datetime

import pytest
from httpx import AsyncClient

from core.config import get_settings
from device_registry.repository import DeviceRegistryRepository
from device_registry.service import DeviceRegistryService


async def register_and_login(client: AsyncClient, email: str) -> dict[str, str]:
    await client.post('/auth/register', json={'email': email, 'password': 'password123'})
    response = await client.post('/auth/login', json={'email': email, 'password': 'password123'})
    body = response.json()
    return {
        'access_token': body['access_token'],
        'refresh_token': body['refresh_token'],
    }


def auth_headers(access_token: str, user_agent: str = 'pytest-agent') -> dict[str, str]:
    return {
        'Authorization': f'Bearer {access_token}',
        'User-Agent': user_agent,
    }


@pytest.mark.asyncio
async def test_authenticated_user_can_register_device(client: AsyncClient) -> None:
    tokens = await register_and_login(client, 'user@example.com')

    response = await client.post(
        '/devices',
        json={
            'device_id': 'device-1',
            'platform': 'ios',
            'name': 'My iPhone',
            'app_version': '1.0.0',
        },
        headers=auth_headers(tokens['access_token']),
    )

    assert response.status_code == 201
    body = response.json()['device']
    assert body['device_id'] == 'device-1'
    assert body['platform'] == 'ios'
    assert body['name'] == 'My iPhone'
    assert body['is_active'] is True
    assert body['last_seen_at'] is not None


@pytest.mark.asyncio
async def test_user_sees_only_their_own_devices(client: AsyncClient) -> None:
    user1 = await register_and_login(client, 'user1@example.com')
    user2 = await register_and_login(client, 'user2@example.com')

    await client.post(
        '/devices',
        json={'device_id': 'device-1', 'platform': 'ios', 'name': 'User1 iPhone'},
        headers=auth_headers(user1['access_token']),
    )
    await client.post(
        '/devices',
        json={'device_id': 'device-2', 'platform': 'android', 'name': 'User2 Android'},
        headers=auth_headers(user2['access_token']),
    )

    response = await client.get('/devices', headers=auth_headers(user1['access_token']))

    assert response.status_code == 200
    devices = response.json()['devices']
    assert len(devices) == 1
    assert devices[0]['device_id'] == 'device-1'


@pytest.mark.asyncio
async def test_user_can_deactivate_own_device(client: AsyncClient) -> None:
    tokens = await register_and_login(client, 'user@example.com')
    await client.post(
        '/devices',
        json={'device_id': 'device-1', 'platform': 'ios', 'name': 'My iPhone'},
        headers=auth_headers(tokens['access_token']),
    )

    response = await client.delete('/devices/device-1', headers=auth_headers(tokens['access_token']))
    list_response = await client.get('/devices', headers=auth_headers(tokens['access_token']))

    assert response.status_code == 200
    assert response.json() == {'device_id': 'device-1', 'deactivated': True}
    assert list_response.json()['devices'][0]['is_active'] is False


@pytest.mark.asyncio
async def test_deactivated_device_can_be_reactivated_with_same_device_id(client: AsyncClient) -> None:
    tokens = await register_and_login(client, 'user@example.com')
    create_response = await client.post(
        '/devices',
        json={'device_id': 'device-1', 'platform': 'ios', 'name': 'Old Name'},
        headers=auth_headers(tokens['access_token'], user_agent='agent-1'),
    )
    await client.delete('/devices/device-1', headers=auth_headers(tokens['access_token']))

    recreate_response = await client.post(
        '/devices',
        json={'device_id': 'device-1', 'platform': 'ios', 'name': 'New Name', 'app_version': '2.0.0'},
        headers=auth_headers(tokens['access_token'], user_agent='agent-2'),
    )

    assert recreate_response.status_code == 201
    assert recreate_response.json()['device']['id'] == create_response.json()['device']['id']
    assert recreate_response.json()['device']['name'] == 'New Name'
    assert recreate_response.json()['device']['app_version'] == '2.0.0'
    assert recreate_response.json()['device']['is_active'] is True


@pytest.mark.asyncio
async def test_register_requires_authentication(client: AsyncClient) -> None:
    response = await client.post(
        '/devices',
        json={'device_id': 'device-1', 'platform': 'ios', 'name': 'My iPhone'},
    )

    assert response.status_code == 401
    assert response.json()['error']['code'] == 'UNAUTHORIZED'


@pytest.mark.asyncio
async def test_device_limit_is_enforced(client: AsyncClient, monkeypatch: pytest.MonkeyPatch) -> None:
    monkeypatch.setenv('DEVICE_LIMIT_PER_USER', '1')
    get_settings.cache_clear()
    tokens = await register_and_login(client, 'user@example.com')

    first = await client.post(
        '/devices',
        json={'device_id': 'device-1', 'platform': 'ios', 'name': 'One'},
        headers=auth_headers(tokens['access_token']),
    )
    second = await client.post(
        '/devices',
        json={'device_id': 'device-2', 'platform': 'android', 'name': 'Two'},
        headers=auth_headers(tokens['access_token']),
    )

    assert first.status_code == 201
    assert second.status_code == 409
    assert second.json()['error']['code'] == 'DEVICE_LIMIT_EXCEEDED'
    monkeypatch.delenv('DEVICE_LIMIT_PER_USER', raising=False)
    get_settings.cache_clear()


@pytest.mark.asyncio
async def test_other_users_device_delete_returns_not_found(client: AsyncClient) -> None:
    user1 = await register_and_login(client, 'user1@example.com')
    user2 = await register_and_login(client, 'user2@example.com')

    await client.post(
        '/devices',
        json={'device_id': 'device-1', 'platform': 'ios', 'name': 'User1 iPhone'},
        headers=auth_headers(user1['access_token']),
    )
    response = await client.delete('/devices/device-1', headers=auth_headers(user2['access_token']))

    assert response.status_code == 404
    assert response.json()['error']['code'] == 'DEVICE_NOT_FOUND'


@pytest.mark.asyncio
async def test_active_duplicate_device_registration_is_rejected(client: AsyncClient) -> None:
    tokens = await register_and_login(client, 'user@example.com')
    await client.post(
        '/devices',
        json={'device_id': 'device-1', 'platform': 'ios', 'name': 'My iPhone'},
        headers=auth_headers(tokens['access_token']),
    )

    response = await client.post(
        '/devices',
        json={'device_id': 'device-1', 'platform': 'ios', 'name': 'My iPhone'},
        headers=auth_headers(tokens['access_token']),
    )

    assert response.status_code == 409
    assert response.json()['error']['code'] == 'DEVICE_ALREADY_REGISTERED'


@pytest.mark.asyncio
async def test_validate_active_device_rejects_inactive_device(session_factory, client: AsyncClient) -> None:
    tokens = await register_and_login(client, 'user@example.com')
    await client.post(
        '/devices',
        json={'device_id': 'device-1', 'platform': 'ios', 'name': 'My iPhone'},
        headers=auth_headers(tokens['access_token']),
    )
    await client.delete('/devices/device-1', headers=auth_headers(tokens['access_token']))

    async with session_factory() as session:
        service = DeviceRegistryService(DeviceRegistryRepository(session))
        with pytest.raises(Exception) as exc_info:
            await service.validate_active_device(user_id=_extract_user_id(tokens['access_token']), device_id='device-1')

    assert getattr(exc_info.value, 'code', None) == 'DEVICE_INACTIVE'


@pytest.mark.asyncio
async def test_touch_last_sync_at_updates_timestamp(session_factory, client: AsyncClient) -> None:
    tokens = await register_and_login(client, 'user@example.com')
    await client.post(
        '/devices',
        json={'device_id': 'device-1', 'platform': 'ios', 'name': 'My iPhone'},
        headers=auth_headers(tokens['access_token']),
    )
    synced_at = datetime.now(tz=UTC)

    async with session_factory() as session:
        service = DeviceRegistryService(DeviceRegistryRepository(session))
        await service.touch_last_sync_at(
            user_id=_extract_user_id(tokens['access_token']),
            device_id='device-1',
            synced_at=synced_at,
        )
        device = await service.repository.get_device(_extract_user_id(tokens['access_token']), 'device-1')

    assert device is not None
    assert device.last_sync_at is not None
    assert abs((device.last_sync_at - synced_at).total_seconds()) < 1


def _extract_user_id(access_token: str) -> str:
    import jwt

    settings = get_settings()
    payload = jwt.decode(access_token, settings.jwt_secret, algorithms=[settings.jwt_algorithm])
    return str(payload['sub'])
