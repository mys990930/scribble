from __future__ import annotations

from datetime import UTC, datetime
from uuid import UUID

from sqlalchemy import Select, func, select
from sqlalchemy.ext.asyncio import AsyncSession

from device_registry.models import Device


class DeviceRegistryRepository:
    def __init__(self, session: AsyncSession) -> None:
        self._session = session

    async def list_devices(self, user_id: str) -> list[Device]:
        stmt: Select[tuple[Device]] = (
            select(Device).where(Device.user_id == UUID(user_id)).order_by(Device.created_at.asc())
        )
        result = await self._session.scalars(stmt)
        return list(result.all())

    async def create_device(
        self,
        user_id: str,
        device_id: str,
        platform: str,
        name: str,
        app_version: str | None,
        last_ip: str | None,
        last_user_agent: str | None,
        last_seen_at: datetime,
    ) -> Device:
        device = Device(
            user_id=UUID(user_id),
            device_id=device_id,
            platform=platform,
            name=name,
            app_version=app_version,
            last_ip=last_ip,
            last_user_agent=last_user_agent,
            registered_at=last_seen_at,
            last_seen_at=last_seen_at,
        )
        self._session.add(device)
        await self._session.commit()
        await self._session.refresh(device)
        return device

    async def reactivate_device(
        self,
        device: Device,
        platform: str,
        name: str,
        app_version: str | None,
        last_ip: str | None,
        last_user_agent: str | None,
        last_seen_at: datetime,
    ) -> Device:
        device.platform = platform
        device.name = name
        device.app_version = app_version
        device.last_ip = last_ip
        device.last_user_agent = last_user_agent
        device.last_seen_at = last_seen_at
        device.deactivated_at = None
        await self._session.commit()
        await self._session.refresh(device)
        return device

    async def get_device(self, user_id: str, device_id: str) -> Device | None:
        stmt: Select[tuple[Device]] = select(Device).where(
            Device.user_id == UUID(user_id),
            Device.device_id == device_id,
        )
        return await self._session.scalar(stmt)

    async def deactivate_device(self, user_id: str, device_id: str) -> Device | None:
        device = await self.get_device(user_id, device_id)
        if device is None:
            return None
        if device.deactivated_at is None:
            device.deactivated_at = datetime.now(tz=UTC)
            await self._session.commit()
            await self._session.refresh(device)
        return device

    async def count_active_devices(self, user_id: str) -> int:
        stmt = select(func.count(Device.id)).where(
            Device.user_id == UUID(user_id),
            Device.deactivated_at.is_(None),
        )
        count = await self._session.scalar(stmt)
        return int(count or 0)

    async def touch_last_sync_at(self, user_id: str, device_id: str, synced_at: datetime) -> Device | None:
        device = await self.get_device(user_id, device_id)
        if device is None:
            return None
        device.last_sync_at = synced_at
        device.last_seen_at = synced_at
        await self._session.commit()
        await self._session.refresh(device)
        return device
