from dataclasses import dataclass

from device_registry.repository import DeviceRegistryRepository
from device_registry.schemas import (
    DeactivateDeviceResponse,
    DeviceListResponse,
    DeviceResponse,
    RegisterDeviceRequest,
)


@dataclass(slots=True)
class DeviceRegistryService:
    repository: DeviceRegistryRepository

    async def register_device(self, user_id: str, payload: RegisterDeviceRequest) -> DeviceResponse:
        raise NotImplementedError

    async def list_devices(self, user_id: str) -> DeviceListResponse:
        raise NotImplementedError

    async def deactivate_device(self, user_id: str, device_id: str) -> DeactivateDeviceResponse:
        raise NotImplementedError

    async def validate_active_device(self, user_id: str, device_id: str) -> None:
        raise NotImplementedError

    async def touch_last_sync_at(self, user_id: str, device_id: str) -> None:
        raise NotImplementedError
