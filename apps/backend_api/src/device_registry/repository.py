from sqlalchemy.ext.asyncio import AsyncSession

from device_registry.models import Device


class DeviceRegistryRepository:
    def __init__(self, session: AsyncSession) -> None:
        self._session = session

    async def list_devices(self, user_id: str) -> list[Device]:
        raise NotImplementedError

    async def create_device(self, user_id: str, device_id: str, platform: str, name: str) -> Device:
        raise NotImplementedError

    async def get_device(self, user_id: str, device_id: str) -> Device | None:
        raise NotImplementedError

    async def deactivate_device(self, user_id: str, device_id: str) -> None:
        raise NotImplementedError

    async def count_active_devices(self, user_id: str) -> int:
        raise NotImplementedError

    async def touch_last_sync_at(self, user_id: str, device_id: str) -> None:
        raise NotImplementedError
