from __future__ import annotations

from dataclasses import dataclass
from datetime import UTC, datetime
from uuid import UUID

from core.pagination import CursorState, decode_cursor, encode_cursor, ensure_cursor_not_expired
from device_registry.models import Device
from device_registry.service import DeviceRegistryService
from sync_api.repository import SyncApiRepository
from sync_api.schemas import PullResponse, PushRequest, PushResponse, SyncEventEnvelope


@dataclass(slots=True)
class SyncApiService:
    repository: SyncApiRepository
    device_service: DeviceRegistryService
    pull_limit: int = 100

    async def push(self, user_id: str, device_id: str, payload: PushRequest) -> PushResponse:
        device = await self.device_service.validate_active_device(user_id, device_id)

        accepted = 0
        rejected = 0
        for event in payload.events:
            existing = await self.repository.get_event_by_event_id(str(event.event_id))
            if existing is not None:
                accepted += 1
                continue

            await self.repository.create_event(
                user_id=user_id,
                device=device,
                event=event.model_dump(),
                recorded_at=datetime.now(tz=UTC),
            )
            accepted += 1

        await self.device_service.touch_last_sync_at(user_id, device_id)
        latest_cursor = await self.repository.get_latest_raw_cursor(user_id)
        return PushResponse(
            accepted=accepted,
            rejected=rejected,
            server_cursor=encode_cursor(latest_cursor) if latest_cursor else '',
        )

    async def pull(self, user_id: str, device_id: str, cursor: str | None) -> PullResponse:
        await self.device_service.validate_active_device(user_id, device_id)

        cursor_state = self._decode_cursor(cursor)
        rows = await self.repository.read_effective_events_after(user_id, cursor_state, self.pull_limit)
        has_more = len(rows) > self.pull_limit
        rows = rows[: self.pull_limit]

        next_cursor = cursor
        if rows:
            last_row = rows[-1]
            next_cursor = encode_cursor(
                CursorState(recorded_at=last_row.recorded_at, event_id=str(last_row.event_id))
            )

        await self.device_service.touch_last_sync_at(user_id, device_id)
        return PullResponse(
            events=[self._to_envelope(row) for row in rows],
            next_cursor=next_cursor,
            has_more=has_more,
        )

    def _decode_cursor(self, cursor: str | None) -> CursorState | None:
        if not cursor:
            return None
        state = decode_cursor(cursor)
        ensure_cursor_not_expired(state)
        return state

    def _to_envelope(self, row) -> SyncEventEnvelope:
        return SyncEventEnvelope(
            event_id=UUID(str(row.event_id)),
            entity_type=row.entity_type,
            entity_id=UUID(str(row.entity_id)),
            operation=row.operation,
            payload=row.payload,
            updated_at=row.updated_at,
            deleted_at=row.deleted_at,
        )
