from __future__ import annotations

from datetime import datetime
from uuid import UUID

from sqlalchemy import Select, and_, desc, func, or_, select
from sqlalchemy.ext.asyncio import AsyncSession

from core.pagination import CursorState
from device_registry.models import Device
from sync_api.models import SyncEvent


class SyncApiRepository:
    def __init__(self, session: AsyncSession) -> None:
        self._session = session

    async def get_event_by_event_id(self, event_id: str) -> SyncEvent | None:
        stmt: Select[tuple[SyncEvent]] = select(SyncEvent).where(SyncEvent.event_id == UUID(event_id))
        return await self._session.scalar(stmt)

    async def get_latest_entity_event(
        self,
        user_id: str,
        entity_type: str,
        entity_id: str,
    ) -> SyncEvent | None:
        stmt: Select[tuple[SyncEvent]] = (
            select(SyncEvent)
            .where(
                SyncEvent.user_id == UUID(user_id),
                SyncEvent.entity_type == entity_type,
                SyncEvent.entity_id == UUID(entity_id),
            )
            .order_by(
                SyncEvent.updated_at.desc(),
                SyncEvent.recorded_at.desc(),
                SyncEvent.event_id.desc(),
            )
            .limit(1)
        )
        return await self._session.scalar(stmt)

    async def create_event(
        self,
        user_id: str,
        device: Device,
        event: dict,
        recorded_at: datetime,
    ) -> SyncEvent:
        sync_event = SyncEvent(
            user_id=UUID(user_id),
            device_pk=device.id,
            device_id=device.device_id,
            event_id=UUID(str(event['event_id'])),
            entity_type=event['entity_type'],
            entity_id=UUID(str(event['entity_id'])),
            operation=event['operation'],
            payload=event['payload'],
            updated_at=event['updated_at'],
            deleted_at=event.get('deleted_at'),
            recorded_at=recorded_at,
            created_at=recorded_at,
        )
        self._session.add(sync_event)
        await self._session.commit()
        await self._session.refresh(sync_event)
        return sync_event

    async def get_latest_raw_cursor(self, user_id: str) -> CursorState | None:
        stmt: Select[tuple[SyncEvent]] = (
            select(SyncEvent)
            .where(SyncEvent.user_id == UUID(user_id))
            .order_by(SyncEvent.recorded_at.desc(), SyncEvent.event_id.desc())
            .limit(1)
        )
        event = await self._session.scalar(stmt)
        if event is None:
            return None
        return CursorState(recorded_at=event.recorded_at, event_id=str(event.event_id))

    async def read_effective_events_after(
        self,
        user_id: str,
        cursor: CursorState | None,
        limit: int,
    ) -> list[SyncEvent]:
        ranking = (
            select(
                SyncEvent.id.label('id'),
                func.row_number()
                .over(
                    partition_by=(SyncEvent.user_id, SyncEvent.entity_type, SyncEvent.entity_id),
                    order_by=(
                        SyncEvent.updated_at.desc(),
                        SyncEvent.recorded_at.desc(),
                        SyncEvent.event_id.desc(),
                    ),
                )
                .label('rn'),
            )
            .where(SyncEvent.user_id == UUID(user_id))
            .subquery()
        )

        stmt = (
            select(SyncEvent)
            .join(ranking, ranking.c.id == SyncEvent.id)
            .where(ranking.c.rn == 1)
            .where(SyncEvent.user_id == UUID(user_id))
        )

        if cursor is not None:
            stmt = stmt.where(
                or_(
                    SyncEvent.recorded_at > cursor.recorded_at,
                    and_(
                        SyncEvent.recorded_at == cursor.recorded_at,
                        SyncEvent.event_id > UUID(cursor.event_id),
                    ),
                )
            )

        stmt = stmt.order_by(SyncEvent.recorded_at.asc(), SyncEvent.event_id.asc()).limit(limit + 1)
        result = await self._session.scalars(stmt)
        return list(result.all())
