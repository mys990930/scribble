from sqlalchemy.ext.asyncio import AsyncSession

from sync_api.models import SyncEvent


class SyncApiRepository:
    def __init__(self, session: AsyncSession) -> None:
        self._session = session

    async def record_events(self, user_id: str, device_id: str, events: list[dict]) -> int:
        raise NotImplementedError

    async def read_events_after(self, user_id: str, cursor: str | None, limit: int) -> list[SyncEvent]:
        raise NotImplementedError
