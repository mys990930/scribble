from __future__ import annotations

from dataclasses import dataclass
from datetime import UTC, datetime

from core.config import get_settings
from device_registry.errors import (
    device_already_registered,
    device_inactive,
    device_limit_exceeded,
    device_not_found,
)
from device_registry.models import Device
from device_registry.repository import DeviceRegistryRepository
from device_registry.schemas import (
    DeactivateDeviceResponse,
    DeviceListResponse,
    DevicePayload,
    DeviceResponse,
    RegisterDeviceRequest,
)


@dataclass(slots=True)
class DeviceRegistryService:
    repository: DeviceRegistryRepository

    async def register_device(
        self,
        user_id: str,
        payload: RegisterDeviceRequest,
        last_ip: str | None,
        last_user_agent: str | None,
    ) -> DeviceResponse:
        existing = await self.repository.get_device(user_id, payload.device_id)
        if existing is not None:
            if existing.deactivated_at is None:
                raise device_already_registered()
            await self.enforce_device_limit(user_id)
            device = await self.repository.reactivate_device(
                device=existing,
                platform=payload.platform,
                name=payload.name,
                app_version=payload.app_version,
                last_ip=last_ip,
                last_user_agent=last_user_agent,
                last_seen_at=datetime.now(tz=UTC),
            )
            return DeviceResponse(device=self._to_payload(device))

        await self.enforce_device_limit(user_id)
        device = await self.repository.create_device(
            user_id=user_id,
            device_id=payload.device_id,
            platform=payload.platform,
            name=payload.name,
            app_version=payload.app_version,
            last_ip=last_ip,
            last_user_agent=last_user_agent,
            last_seen_at=datetime.now(tz=UTC),
        )
        return DeviceResponse(device=self._to_payload(device))

    async def list_devices(self, user_id: str) -> DeviceListResponse:
        devices = await self.repository.list_devices(user_id)
        return DeviceListResponse(devices=[self._to_payload(device) for device in devices])

    async def deactivate_device(self, user_id: str, device_id: str) -> DeactivateDeviceResponse:
        device = await self.repository.deactivate_device(user_id, device_id)
        if device is None:
            raise device_not_found()
        return DeactivateDeviceResponse(device_id=device_id, deactivated=True)

    async def validate_active_device(self, user_id: str, device_id: str) -> Device:
        device = await self.repository.get_device(user_id, device_id)
        if device is None:
            raise device_not_found()
        if device.deactivated_at is not None:
            raise device_inactive()
        return device

    async def touch_last_sync_at(self, user_id: str, device_id: str, synced_at: datetime | None = None) -> None:
        device = await self.validate_active_device(user_id, device_id)
        await self.repository.touch_last_sync_at(
            user_id=user_id,
            device_id=device.device_id,
            synced_at=synced_at or datetime.now(tz=UTC),
        )

    async def enforce_device_limit(self, user_id: str) -> None:
        active_count = await self.repository.count_active_devices(user_id)
        if active_count >= get_settings().device_limit_per_user:
            raise device_limit_exceeded()

    def _to_payload(self, device: Device) -> DevicePayload:
        return DevicePayload(
            id=device.id,
            device_id=device.device_id,
            platform=device.platform,
            name=device.name,
            app_version=device.app_version,
            is_active=device.deactivated_at is None,
            last_seen_at=device.last_seen_at,
            last_sync_at=device.last_sync_at,
        )
