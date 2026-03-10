from __future__ import annotations

import uuid
from datetime import datetime

from sqlalchemy import CheckConstraint, DateTime, ForeignKey, Index, String, func
from sqlalchemy.dialects.postgresql import JSONB, UUID
from sqlalchemy.orm import Mapped, mapped_column

from core.database import Base, UUIDPrimaryKeyMixin


class SyncEvent(UUIDPrimaryKeyMixin, Base):
    __tablename__ = 'sync_events'
    __table_args__ = (
        Index('uq_sync_events_event_id', 'event_id', unique=True),
        Index('ix_sync_events_user_recorded', 'user_id', 'recorded_at', 'event_id'),
        Index(
            'ix_sync_events_entity_lww',
            'user_id',
            'entity_type',
            'entity_id',
            'updated_at',
            'recorded_at',
        ),
        Index('ix_sync_events_device_recorded', 'device_pk', 'recorded_at'),
        CheckConstraint("operation in ('upsert', 'delete')", name='sync_events_operation_valid'),
        CheckConstraint(
            "(operation = 'delete' and deleted_at is not null) or "
            "(operation = 'upsert' and deleted_at is null)",
            name='sync_events_deleted_at_matches_operation',
        ),
    )

    event_id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), nullable=False)
    user_id: Mapped[uuid.UUID] = mapped_column(
        UUID(as_uuid=True),
        ForeignKey('users.id', ondelete='CASCADE'),
        nullable=False,
    )
    device_pk: Mapped[uuid.UUID] = mapped_column(
        UUID(as_uuid=True),
        ForeignKey('devices.id', ondelete='CASCADE'),
        nullable=False,
    )
    device_id: Mapped[str] = mapped_column(String(128), nullable=False)
    entity_type: Mapped[str] = mapped_column(String(40), nullable=False)
    entity_id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), nullable=False)
    operation: Mapped[str] = mapped_column(String(20), nullable=False)
    payload: Mapped[dict] = mapped_column(JSONB, nullable=False)
    updated_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), nullable=False)
    deleted_at: Mapped[datetime | None] = mapped_column(DateTime(timezone=True), nullable=True)
    recorded_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        nullable=False,
        server_default=func.now(),
    )
    created_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        nullable=False,
        server_default=func.now(),
    )
