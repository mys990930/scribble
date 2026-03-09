from dataclasses import dataclass

from sync_api.repository import SyncApiRepository
from sync_api.schemas import PullResponse, PushRequest, PushResponse


@dataclass(slots=True)
class SyncApiService:
    repository: SyncApiRepository

    async def push(self, user_id: str, device_id: str, payload: PushRequest) -> PushResponse:
        raise NotImplementedError

    async def pull(self, user_id: str, device_id: str, cursor: str | None) -> PullResponse:
        raise NotImplementedError
